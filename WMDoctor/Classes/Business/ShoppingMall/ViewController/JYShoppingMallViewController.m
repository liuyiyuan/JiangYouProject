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
#import "JYMenuSelectorView.h"
#import "JYLoginAPIManager.h"
#import <AFURLRequestSerialization.h>
#import <AFNetworking.h>
#import <AFSecurityPolicy.h>
#import <AFURLSessionManager.h>
#import <AFHTTPSessionManager.h>
#import <AFAutoPurgingImageCache.h>


@interface JYShoppingMallViewController ()<TopicScrollViewDelegate>{
    WYTopicScrollView *_topicScrollView;
    JYMenuSelectorView *_menuSelectorView;
}

@end

@implementation JYShoppingMallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    [self login];
}

- (void)initView{
    self.title = @"江油商城";
    WYTopicHeader *header = [[WYTopicHeader alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kTopicHeaderHeight)];
    _topicScrollView = header.topicScrollView;
    _topicScrollView.topicDelegate = self;
    
    _menuSelectorView = [[JYMenuSelectorView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    [_menuSelectorView setMenuWithArr:@[@"精选", @"抢购", @"团购", @"福利", @"商城", @"贴吧"]];
    [self.view addSubview:_menuSelectorView];
}

- (void)login{
    
    
    NSDictionary *param = @{
                             @"name" : @"aaa",
                             @"age" : @"11"
                             };
    JYLoginAPIManager *loginAPIManager = [[JYLoginAPIManager alloc] init];
    [loginAPIManager loadDataWithParams:param withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"responseObject : %@", responseObject);
        NSDictionary *dic = (NSDictionary *)responseObject;
        NSLog(@"dic : %@", dic);
    } withFailure:^(ResponseResult *errorResult) {
        NSLog(@"login error : %@", errorResult);
    }];
    
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
