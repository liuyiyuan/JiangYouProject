//
//  JYLoginViewController.m
//  WMDoctor
//
//  Created by jiangqi on 2018/7/5.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYLoginViewController.h"
#import "JYLoninView.h"
#import "JYFindPassWordViewController.h"//忘记密码
#import "JYFastLogInViewController.h"//快捷登录
#import "JYFirstLogInViewController.h"//首次登录
#import <AFNetworking.h>
#import "JYLoginNewAPIManager.h"
#import "FSAES128.h"
//#import "JYLoginModel.h"
#import "JYLoginNewModel.h"
@interface JYLoginViewController ()

@property (nonatomic, strong) JYLoninView *loginView;

@end

@implementation JYLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    
    
    [self configUI];
}

-(void)configUI{
    [self.view addSubview:self.loginView];
    
    [self.loginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(pixelValue(0));
        make.right.mas_equalTo(pixelValue(0));
        make.bottom.mas_equalTo(pixelValue(0));
        make.top.mas_equalTo(pixelValue(0));
    }];
}

-(JYLoninView *)loginView{
    if(!_loginView){
        _loginView = [[JYLoninView alloc]init];
        [_loginView.eyeButton addTarget:self action:@selector(click_eyeButton:) forControlEvents:UIControlEventTouchUpInside];
        [_loginView.loginButton addTarget:self action:@selector(click_loginButton) forControlEvents:UIControlEventTouchUpInside];
        [_loginView.forgetPassWordButton addTarget:self action:@selector(click_forgetPassWordButton) forControlEvents:UIControlEventTouchUpInside];
        [_loginView.firstLoginButton addTarget:self action:@selector(click_firstLoginButton) forControlEvents:UIControlEventTouchUpInside];
        [_loginView.smsFastLoginButton addTarget:self action:@selector(click_smsFastLoginButton) forControlEvents:UIControlEventTouchUpInside];
        [_loginView.weChatButton addTarget:self action:@selector(click_weChatButton) forControlEvents:UIControlEventTouchUpInside];
        [_loginView.qqButton addTarget:self action:@selector(click_sqqButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginView;
}

#pragma mark - 眼睛点击
-(void)click_eyeButton:(UIButton *)btn{
    btn.selected = !btn.selected;
    if (btn.selected) { // 按下去了就是明文
        NSString *tempPwdStr = self.loginView.passWordTextField.text;
        self.loginView.passWordTextField.text = @""; // 这句代码可以防止切换的时候光标偏移
        self.loginView.passWordTextField.secureTextEntry = NO;
        self.loginView.passWordTextField.text = tempPwdStr;
        [self.loginView.eyeButton setImage:[UIImage imageNamed:@"login_open_eye"] forState:UIControlStateNormal];
    } else { // 暗文
        NSString *tempPwdStr = self.loginView.passWordTextField.text;
       self.loginView.passWordTextField.text = @"";
        self.loginView.passWordTextField.secureTextEntry = YES;
        self.loginView.passWordTextField.text = tempPwdStr;
        [self.loginView.eyeButton setImage:[UIImage imageNamed:@"login_close_eye"] forState:UIControlStateNormal];
    }
}
#pragma mark - 忘记密码
-(void)click_forgetPassWordButton{
    [self.navigationController pushViewController:[JYFindPassWordViewController new] animated:YES];
}

#pragma mark - 首次登录
-(void)click_firstLoginButton{
    [self.navigationController pushViewController:[JYFirstLogInViewController new] animated:YES];
}

#pragma mark - 首次登录
-(void)click_smsFastLoginButton{
    [self.navigationController pushViewController:[JYFastLogInViewController new] animated:YES];
}


#pragma mark - 登录点击
-(void)click_loginButton{
    NSDictionary *param = @{
                           @"tel":@"15395713725",
                           @"password":@"1"
                           };
    
    JYLoginNewAPIManager *loginAPIManager = [[JYLoginNewAPIManager alloc] init];
    [loginAPIManager loadDataWithParams:param withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"login success data : %@", responseObject);
        JYLoginNewModel *loginUser = [[JYLoginNewModel alloc] initWithDictionary:responseObject error:nil];
        NSLog(@"login success model : %@", loginUser);
        [[NSNotificationCenter defaultCenter] postNotificationName:kLoginInSuccessNotification
                                                            object:nil
                                                          userInfo:nil];
        [[NSUserDefaults standardUserDefaults] setObject:loginUser.toDictionary forKey:@"JYLoginUserInfo"];
    } withFailure:^(ResponseResult *errorResult) {
        NSLog(@"login error : %@", errorResult);
    }];
}
#pragma mark - 微信登录按钮
-(void)click_weChatButton{
    
}

#pragma mark - qq登录按钮
-(void)click_sqqButton{
    
}



@end

