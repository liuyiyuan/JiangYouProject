//
//  JYFindPassWordViewController.m
//  WMDoctor
//
//  Created by zhenYan on 2018/7/1.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYFastLogInViewController.h"
#import "JYFastLogInView.h"
#import "UIButton+EWTimer.h"
#import "JYGetVerificationCodeAPIManager.h"
#import "JYVerificationCodeModel.h"
#import "JYFastLoginAPIManager.h"
#import "JYLoginNewModel.h"
#import "JYLoginCodeView.h"
#import "JYCompareValidCodeManager.h"//校对验证码
@interface JYFastLogInViewController ()

@property(nonatomic,strong)JYFastLogInView *fastLogInView;//找回密码

@property (nonatomic, strong) JYLoginCodeView *CodeView;//图形验证码

@end

@implementation JYFastLogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"快捷登录";
    
    [self congifUI];
}


-(void)congifUI{
    [self.view addSubview:self.fastLogInView];
    [self.fastLogInView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(pixelValue(0));
        make.bottom.mas_equalTo(pixelValue(0));
        make.left.mas_equalTo(pixelValue(0));
        make.right.mas_equalTo(pixelValue(0));
    }];
}

-(JYFastLogInView *)fastLogInView{
    if(!_fastLogInView){
        _fastLogInView = [[JYFastLogInView alloc]init];
        _fastLogInView.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
        [_fastLogInView.getCodeBtn addTarget:self action:@selector(click_getCodeBtn) forControlEvents:UIControlEventTouchUpInside];
        [_fastLogInView.loginBtn addTarget:self action:@selector(click_loginBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fastLogInView;
}

-(JYLoginCodeView *)CodeView{
    if(!_CodeView){
        _CodeView = [[JYLoginCodeView alloc]init];
        _CodeView.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT);
        _CodeView.backgroundColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:0.5];
        [_CodeView.cancelButton addTarget:self action:@selector(click_codeViewCancelButton) forControlEvents:UIControlEventTouchUpInside];
        [_CodeView.doneButton addTarget:self action:@selector(click_codeViewDoneButton) forControlEvents:UIControlEventTouchUpInside];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click_codeImageView)];
        [_CodeView.codeImageView addGestureRecognizer:tap];
    }
    return _CodeView;
}
#pragma mark - 图形验证码取消按钮
-(void)click_codeViewCancelButton{
    [self.CodeView removeFromSuperview];
}
#pragma mark - 图形验证码确定按钮
-(void)click_codeViewDoneButton{
    NSDictionary *param = @{
                            @"tel":self.fastLogInView.phoneNumberTextField.text,
                            @"validCode":self.CodeView.codeTextField.text
                            };
    JYCompareValidCodeManager *CompareValidCodeManager = [[JYCompareValidCodeManager alloc] init];
    [CompareValidCodeManager loadDataWithParams:param withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        JYVerificationCodeModel *codeModel = [[JYVerificationCodeModel alloc] initWithDictionary:responseObject error:nil];
            [_fastLogInView.getCodeBtn startCountDownTime:60 withCountDownBlock:^{
                [_fastLogInView.getCodeBtn setBackgroundColor:[UIColor colorWithHexString:@"#138CFF"]];
                [_fastLogInView.getCodeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
        
            }];
        [self.CodeView removeFromSuperview];
        
        NSLog(@"codeModel : %@", codeModel);
    } withFailure:^(ResponseResult *errorResult) {
        NSLog(@"get ver code error : %@", errorResult);
    }];
}

#pragma mark - 图形验证码刷新
-(void)click_codeImageView{
    [self click_getCodeBtn];
}
#pragma mark - 获取验证码
-(void)click_getCodeBtn{

    
    NSDictionary *param = @{
                            @"tel":self.fastLogInView.phoneNumberTextField.text
                            };
    JYGetVerificationCodeAPIManager *getVerCodeAPIManager = [[JYGetVerificationCodeAPIManager alloc] init];
    [getVerCodeAPIManager loadDataWithParams:param withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        JYVerificationCodeModel *codeModel = [[JYVerificationCodeModel alloc] initWithDictionary:responseObject error:nil];
        
        // 将base64字符串转为NSData
        NSData *decodeData = [[NSData alloc]initWithBase64EncodedString:codeModel.validCodeImg options:(NSDataBase64DecodingIgnoreUnknownCharacters)];
        // 将NSData转为UIImage
        UIImage *decodedImage = [UIImage imageWithData: decodeData];
        
        self.CodeView.codeImageView.image = decodedImage;
        
        [self.navigationController.view addSubview:self.CodeView];
        
        NSLog(@"codeModel : %@", codeModel);
    } withFailure:^(ResponseResult *errorResult) {
        NSLog(@"get ver code error : %@", errorResult);
    }];
    
}
#pragma mark - 登录
-(void)click_loginBtn{
    JYFastLoginAPIManager *fastLoginAPIManager = [[JYFastLoginAPIManager alloc] init];
    NSDictionary *param = @{
                            @"tel" : self.fastLogInView.phoneNumberTextField.text,
                            @"validCode" : self.fastLogInView.codeTextField.text
                            };
    [fastLoginAPIManager loadDataWithParams:param withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"fast login data : %@", responseObject);
        JYLoginNewModel *loginedUser = [[JYLoginNewModel alloc] initWithDictionary:responseObject error:nil];
        if ([UIApplication sharedApplication].delegate.window.rootViewController != nil) {
            [UIApplication sharedApplication].delegate.window.rootViewController = nil;
        }
        UITabBarController * tabBarController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"WMTabBarController"];
        [UIApplication sharedApplication].delegate.window.rootViewController = tabBarController;
//        [[NSNotificationCenter defaultCenter] postNotificationName:kLoginInSuccessNotification
//                                                            object:nil
//                                                          userInfo:nil];
        [[NSUserDefaults standardUserDefaults] setObject:loginedUser.toDictionary forKey:@"JYLoginUserInfo"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        NSLog(@"logined User : %@", loginedUser);
    } withFailure:^(ResponseResult *errorResult) {
        NSLog(@"fast login error : %@", errorResult);
    }];
}
@end
