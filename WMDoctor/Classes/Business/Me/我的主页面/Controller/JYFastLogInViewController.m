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
    NSLog(@"phonenumber : %@", _fastLogInView.phoneNumberTextField.text);
    JYGetVerificationCodeAPIManager *getVerifCodeAPIManager = [[JYGetVerificationCodeAPIManager alloc] init];
    NSDictionary *param = @{
                            @"tel" : _fastLogInView.phoneNumberTextField.text
                            };
    [getVerifCodeAPIManager loadDataWithParams:param withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"getVerifCode data : %@", responseObject);
    } withFailure:^(ResponseResult *errorResult) {
        NSLog(@"getVerifCode error : %@", errorResult);
    }];
    
    AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
    responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = responseSerializer;
    [manager GET:@"http://39.104.124.199:8080/jeecmsv9f/jyqss/mobile/user/loginOnByValidCode?tel=13122221111" parameters:@{} progress:nil success:
     ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSLog(@"请求成功---%@---%@",responseObject,[responseObject class]);
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"请求失败--%@",error);
     }];
    
}
#pragma mark - 登录
-(void)click_loginBtn{
    
}
@end
