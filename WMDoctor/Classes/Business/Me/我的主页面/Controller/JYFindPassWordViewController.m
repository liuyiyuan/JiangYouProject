//
//  JYFindPassWordViewController.m
//  WMDoctor
//
//  Created by zhenYan on 2018/7/1.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYFindPassWordViewController.h"
#import "JYFindPassWordView.h"
#import "UIButton+EWTimer.h"
#import "JYGetVerificationCodeAPIManager.h"
#import "JYVerificationCodeModel.h"
@interface JYFindPassWordViewController ()

@property(nonatomic,strong)JYFindPassWordView *findPassWordView;//找回密码

@end

@implementation JYFindPassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"找回密码";
    
    [self congifUI];
}


-(void)congifUI{
    [self.view addSubview:self.findPassWordView];
    [self.findPassWordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(pixelValue(0));
        make.bottom.mas_equalTo(pixelValue(0));
        make.left.mas_equalTo(pixelValue(0));
        make.right.mas_equalTo(pixelValue(0));
    }];
}

-(JYFindPassWordView *)findPassWordView{
    if(!_findPassWordView){
        _findPassWordView = [[JYFindPassWordView alloc]init];
       _findPassWordView.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
        [_findPassWordView.getCodeBtn addTarget:self action:@selector(click_getCodeBtn) forControlEvents:UIControlEventTouchUpInside];
        [_findPassWordView.loginBtn addTarget:self action:@selector(click_loginBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _findPassWordView;
}

#pragma mark - 获取验证码
-(void)click_getCodeBtn{
    [_findPassWordView.getCodeBtn startCountDownTime:60 withCountDownBlock:^{
        [_findPassWordView.getCodeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
        
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
    
}
@end
