//
//  JYShoppingMallViewController.m
//  WMDoctor
//
//  Created by xugq on 2018/6/27.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYShoppingMallViewController.h"
#import "WYTopicScrollView.h"
#import "WYTopicHeader.h"
#import "WYTopic.h"

@interface JYShoppingMallViewController ()<TopicScrollViewDelegate>{
    WYTopicScrollView *_topicScrollView;
}

@end

@implementation JYShoppingMallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
}

- (void)initView{
    WYTopicHeader *header = [[WYTopicHeader alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kTopicHeaderHeight)];
    _topicScrollView = header.topicScrollView;
    _topicScrollView.topicDelegate = self;
    [self.view addSubview:header];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)topicScrollViewDidChanged:(NSArray *)selectedArray{
    NSLog(@"selectedArray : %@", selectedArray);
}

- (void)topicScrollViewDidSelectButton:(NSInteger)selectedButtonIndex{
    NSLog(@"selectedButtonIndex : %ld", selectedButtonIndex);
}

@end
