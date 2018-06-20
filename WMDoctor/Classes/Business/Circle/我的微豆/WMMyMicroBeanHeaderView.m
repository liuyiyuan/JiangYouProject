//
//  WMMyMicroBeanHeaderView.m
//  WMDoctor
//
//  Created by xugq on 2017/11/28.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMMyMicroBeanHeaderView.h"
#import "WMTabBarController.h"
#import "WMNavgationController.h"
#import "WMMicroExplainWebViewController.h"
#import "WMScoreTaskViewController.h"

@implementation WMMyMicroBeanHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView{
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_width, 107)];
    bottomView.backgroundColor = [UIColor colorWithHexString:@"18a2ff"];
    [self addSubview:bottomView];
    
    UIImageView *beanImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 48, 21, 21)];
    beanImageView.image = [UIImage imageNamed:@"microBean"];
    [bottomView addSubview:beanImageView];
    
    self.score = [[UILabel alloc] initWithFrame:CGRectMake(beanImageView.right + 7, 24, 150, 59)];
    self.score.textColor = [UIColor whiteColor];
    self.score.font = [UIFont systemFontOfSize:42];
    self.score.text = @"1200";
    [self addSubview:self.score];
    
    UIButton *getBeanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    getBeanBtn.frame = CGRectMake(kScreen_width - 100, 39, 85, 30);
    getBeanBtn.layer.masksToBounds = YES;
    getBeanBtn.layer.cornerRadius = 15;
    getBeanBtn.layer.borderWidth = 0.5;
    getBeanBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    [getBeanBtn setTitle:@"获取微豆" forState:UIControlStateNormal];
    [getBeanBtn setTintColor:[UIColor whiteColor]];
    getBeanBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [getBeanBtn addTarget:self action:@selector(getBeanBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:getBeanBtn];
    
    UIView *beanIntroduceView = [[UIView alloc] initWithFrame:CGRectMake(0, bottomView.bottom, kScreen_width, 35)];
    beanIntroduceView.backgroundColor = [UIColor colorWithHexString:@"0E8FE7"];
    [self addSubview:beanIntroduceView];
    
    UILabel *beanIntroduceLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 65, 35)];
    beanIntroduceLabel.textColor = [UIColor whiteColor];
    beanIntroduceLabel.font = [UIFont systemFontOfSize:12];
    beanIntroduceLabel.text = @"什么是微豆";
    [beanIntroduceView addSubview:beanIntroduceLabel];
    
    UIButton *beanIntroduceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    beanIntroduceBtn.frame = CGRectMake(beanIntroduceLabel.right + 12, 9, 17, 17);
    [beanIntroduceBtn setImage:[UIImage imageNamed:@"microBeanIntroduce"] forState:UIControlStateNormal];
    [beanIntroduceBtn addTarget:self action:@selector(beanIntroduceBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [beanIntroduceView addSubview:beanIntroduceBtn];
    
    UIView *beanExchangeView = [[UIView alloc] initWithFrame:CGRectMake(0, beanIntroduceView.bottom, kScreen_width, 43)];
    beanExchangeView.backgroundColor = [UIColor colorWithHexString:@"F5F5F9"];
    [self addSubview:beanExchangeView];
    
    UILabel *beanExchangeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 70, 43)];
    beanExchangeLabel.textColor = [UIColor colorWithHexString:@"999999"];
    beanExchangeLabel.font = [UIFont systemFontOfSize:14];
    beanExchangeLabel.text = @"微豆兑换";
    [beanExchangeView addSubview:beanExchangeLabel];
    self.currentEnvir = [AppConfig currentEnvir];   //获取当前运行环境
}

//获取微豆
- (void)getBeanBtnClickAction:(UIButton *)button{
    WMTabBarController * tabBarController = (WMTabBarController *)self.window.rootViewController;
    WMNavgationController * navController = (WMNavgationController*)tabBarController.viewControllers[tabBarController.selectedIndex];
    
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
    WMScoreTaskViewController * recordVC = (WMScoreTaskViewController *)[storyboard instantiateViewControllerWithIdentifier:@"WMScoreTaskViewController"];
    recordVC.hidesBottomBarWhenPushed = YES;
    [navController pushViewController:recordVC animated:YES];
}

//微豆说明
- (void)beanIntroduceBtnClickAction:(UIButton *)button{
    WMTabBarController * tabBarController = (WMTabBarController *)self.window.rootViewController;
    WMNavgationController * navController = (WMNavgationController*)tabBarController.viewControllers[tabBarController.selectedIndex];
    WMMicroExplainWebViewController *microExplainWebViewController = [[WMMicroExplainWebViewController alloc] init];
    //这种方式保证返回的值肯定不是nil
    NSString * urlStr = (self.currentEnvir == 0)?H5_URL_BEANEXPLAIN:(self.currentEnvir == 3)?H5_URL_BEANEXPLAIN_PRE:H5_URL_BEANEXPLAIN_Test;
    microExplainWebViewController.urlString = urlStr;//@"http://test.m.myweimai.com/yisheng/exchange_info.html";
    microExplainWebViewController.backTitle = @"";
    [navController pushViewController:microExplainWebViewController animated:YES];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
