//
//  WMNoCounselingView.m
//  WMDoctor
//
//  Created by xugq on 2018/1/30.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "WMNoCounselingView.h"

#import "WMTabBarController.h"
#import "WMNavgationController.h"

@implementation WMNoCounselingView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView{
    float icon_x = (kScreen_width - 130) / 2;
    CGRect rect = CGRectMake(icon_x, 50, 130, 130);
    UIImageView *noDataIcon = [[UIImageView alloc] initWithFrame:rect];
    UIImage *iconImage = [UIImage imageNamed:@"noCounseling"];
    [noDataIcon setImage: iconImage];
    [self addSubview:noDataIcon];
    
    float lab_x = (kScreen_width - 60) / 2;
    CGRect labRect = CGRectMake(lab_x, noDataIcon.bottom + 20, 60, 20);
    UILabel *awokeLabel = [[UILabel alloc] initWithFrame:labRect];
    awokeLabel.font = [UIFont systemFontOfSize:14];
    awokeLabel.text = @"暂无消息";
    awokeLabel.textColor = [UIColor colorWithHexString:@"999999"];
    [self addSubview:awokeLabel];
    
    LoginModel *loginModel = [WMLoginCache getMemoryLoginModel];
    if (loginModel.userType) {
        return;
    }
    
    self.makeMoneyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    float makeMoney_x = (kScreen_width - 180) / 2;
    self.makeMoneyBtn.frame = CGRectMake(makeMoney_x, awokeLabel.bottom + 20, 180, 40);
    [self.makeMoneyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.makeMoneyBtn.layer.masksToBounds = YES;
    self.makeMoneyBtn.layer.cornerRadius = 5;
    self.makeMoneyBtn.backgroundColor = [UIColor colorWithHexString:@"18A2FF"];
    self.makeMoneyBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.makeMoneyBtn addTarget:self action:@selector(makeMoneyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.makeMoneyBtn];
}

- (void)makeMoneyBtnClick{
    NSLog(@"咨询赚钱");
    WMTabBarController * tabBarController = (WMTabBarController *)self.window.rootViewController;
    WMNavgationController * navController = (WMNavgationController*)tabBarController.viewControllers[tabBarController.selectedIndex];
    WMBaseWKWebController * webVC = [[WMBaseWKWebController alloc]init];
    if ([self.makeMoneyBtn.titleLabel.text isEqualToString:@"如何通过咨询服务赚钱"]) {
        webVC.urlString = H5_URL_COUNSELINGMAKEMONEY_FORMAL;//(_currentEnvir == 0)?H5_URL_SHAREFRIEND:(_currentEnvir == 3)?H5_URL_SHAREFRIEND_PRE:H5_URL_SHAREFRIEND_TEST;
    } else{
        webVC.urlString = H5_URL_DOCTORFINGERPOST;
    }
    webVC.backTitle = @"";
    webVC.hidesBottomBarWhenPushed = YES;
    [navController pushViewController:webVC animated:YES];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
