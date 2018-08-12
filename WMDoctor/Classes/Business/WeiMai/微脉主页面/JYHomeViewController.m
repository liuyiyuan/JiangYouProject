//
//  WYNewsVC.m
//  WYNews
//
//  Created by dai.fengyi on 15/5/26.
//  Copyright (c) 2015年 childrenOurFuture. All rights reserved.
//

#import "JYHomeViewController.h"
#import "WYNetwork.h"
#import "WYTopicHeader.h"
#import "WYTopicScrollView.h"
#import "WYNewsScrollView.h"
#import "WYNewsTableController.h"
#import "WYTopic.h"
#import "JYHomeNewAPIManager.h"
#import "ZJScrollPageView.h"
#import "JYNewsViewController.h"//关注
#import "JYHomeBeautyPittureViewController.h"//美图
#import "JYHomeVideoViewController.h"//视频
#import "JYHomeBBSViewController.h"//论坛
#import "JYHomeSameCityViewController.h"//同城
#import "JYHomeRecommendedViewController.h"//推荐
@interface JYHomeViewController () <ZJScrollPageViewDelegate>

@property(strong, nonatomic)NSArray<NSString *> *titles;
@property(strong, nonatomic)NSArray<UIViewController *> *childVcs;
@property (nonatomic, strong) ZJScrollPageView *scrollPageView;

@end

@implementation JYHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"效果示例";
    self.navigationController.navigationBar.hidden = YES;

    //必要的设置, 如果没有设置可能导致内容显示不正常
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    ZJSegmentStyle *style = [[ZJSegmentStyle alloc] init];
    //显示滚动条
    style.showLine = YES;
    // 颜色渐变
    style.gradualChangeTitleColor = YES;
    // 滚动条的颜色
    style.scrollLineColor = [UIColor colorWithRed:4 / 255.0 green:79 / 255.0 blue:128 / 255.0 alpha:1];
    // 标题一般状态的颜色
    style.normalTitleColor = [UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255 / 255.0 alpha:1];
    // 标题选中状态的颜色
    style.selectedTitleColor = [UIColor colorWithRed:4 / 255.0 green:79 / 255.0 blue:128 / 255.0 alpha:1];
    self.titles = @[@"关注",
                    @"推荐",
                    @"论坛",
                    @"同城",
                    @"视频",
                    @"美图",
                    @"情感",
                    @"视频",
                    @"无厘头",
                    @"美女图片",
                    @"今日房价",
                    @"头像",
                    ];
    // 初始化
    _scrollPageView = [[ZJScrollPageView alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - tarBarHeight - STATUS_BAR_HEIGHT) segmentStyle:style titles:self.titles parentViewController:self delegate:self];
    _scrollPageView.backgroundColor = [UIColor colorWithHexString:@"#50B8FB"];
    
    UIView *backView = [[UIView alloc]init];
    backView.backgroundColor = [UIColor colorWithHexString:@"#50B8FB"];
    backView.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - tarBarHeight);
    [self.view addSubview:backView];
    
    [backView addSubview:_scrollPageView];
}


- (NSInteger)numberOfChildViewControllers {
    return self.titles.count;
}

- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
    UIViewController<ZJScrollPageViewChildVcDelegate> *childVc = reuseViewController;
    
    if (!childVc) {
        if(index == 0){
            childVc = [[JYNewsViewController alloc] init];//关注
        }else if(index == 1){
            childVc = [[JYHomeRecommendedViewController alloc] init];//推荐
        }else if(index == 2){
            childVc = [[JYHomeBBSViewController alloc] init];//视频
        }else if(index == 3){
            childVc = [[JYHomeSameCityViewController alloc] init];//同城
        }else if(index == 4){
            childVc = [[JYHomeVideoViewController alloc] init];//视频
        }else{
            childVc = [[JYHomeBeautyPittureViewController alloc] init];//美图
            
        }
        
    }
    
    //    NSLog(@"%ld-----%@",(long)index, childVc);
    
    return childVc;
}


- (BOOL)shouldAutomaticallyForwardAppearanceMethods {
    return NO;
}

@end
