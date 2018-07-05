//
//  JYFindPassWordViewController.m
//  WMDoctor
//
//  Created by zhenYan on 2018/7/1.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYFirstLogInViewController.h"
#import "JYFirstLogInView.h"
#import "UIButton+EWTimer.h"
@interface JYFirstLogInViewController ()

@property(nonatomic,strong)JYFirstLogInView *firstLogInView;//找回密码

@end

@implementation JYFirstLogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"首次登录";
    
    [self congifUI];
}


-(void)congifUI{
    [self.view addSubview:self.firstLogInView];
    [self.firstLogInView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(pixelValue(0));
        make.bottom.mas_equalTo(pixelValue(0));
        make.left.mas_equalTo(pixelValue(0));
        make.right.mas_equalTo(pixelValue(0));
    }];
}

-(JYFirstLogInView *)firstLogInView{
    if(!_firstLogInView){
        _firstLogInView = [[JYFirstLogInView alloc]init];
        [_firstLogInView.loginBtn addTarget:self action:@selector(click_loginBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _firstLogInView;
}

#pragma mark - 登录
-(void)click_loginBtn{
    
}
@end
