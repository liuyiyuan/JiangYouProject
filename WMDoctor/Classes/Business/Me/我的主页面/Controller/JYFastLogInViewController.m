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
@interface JYFastLogInViewController ()

@property(nonatomic,strong)JYFastLogInView *fastLogInView;//找回密码

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

#pragma mark - 获取验证码
-(void)click_getCodeBtn{
    [_fastLogInView.getCodeBtn startCountDownTime:60 withCountDownBlock:^{
        [_fastLogInView.getCodeBtn setBackgroundColor:[UIColor colorWithHexString:@"#138CFF"]];
        [_fastLogInView.getCodeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
        
    }];
    
    NSDictionary *param = @{
                            @"tel":@"15395713725"
                            };
    JYGetVerificationCodeAPIManager *getVerCodeAPIManager = [[JYGetVerificationCodeAPIManager alloc] init];
    [getVerCodeAPIManager loadDataWithParams:param withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        JYVerificationCodeModel *codeModel = [[JYVerificationCodeModel alloc] initWithDictionary:responseObject error:nil];
        NSLog(@"codeModel : %@", codeModel);
    } withFailure:^(ResponseResult *errorResult) {
        NSLog(@"get ver code error : %@", errorResult);
    }];
    
}
#pragma mark - 登录
-(void)click_loginBtn{
    JYFastLoginAPIManager *fastLoginAPIManager = [[JYFastLoginAPIManager alloc] init];
    NSDictionary *param = @{
                            @"tel" : @"15395713725",
                            @"validCode" : @""
                            };
    [fastLoginAPIManager loadDataWithParams:param withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"fast login data : %@", responseObject);
        JYLoginNewModel *loginedUser = [[JYLoginNewModel alloc] initWithDictionary:responseObject error:nil];
        NSLog(@"logined User : %@", loginedUser);
    } withFailure:^(ResponseResult *errorResult) {
        NSLog(@"fast login error : %@", errorResult);
    }];
}
@end
