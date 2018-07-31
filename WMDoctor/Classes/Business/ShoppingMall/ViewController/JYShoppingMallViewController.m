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
#import "SDCycleScrollView.h"
#import "JYShoppingMallAPIManager.h"
#import "JYShoppingMallModel.h"
#import "JYStoreCarefullyChooseAPIManager.h"


@interface JYShoppingMallViewController ()<TopicScrollViewDelegate, SDCycleScrollViewDelegate, UIScrollViewDelegate>{
    WYTopicScrollView *_topicScrollView;
    JYMenuSelectorView *_menuSelectorView;
    UIScrollView *_scrollView;
}

@property(nonatomic, strong) SDCycleScrollView *cycleScrollView;        //轮播
//@property(nonatomic, strong) WMHomeModuleView *homeModuleView;  //轮播下的横向滑动小模块
@property(nonatomic, strong) NSMutableArray *dataSource;


@end

@implementation JYShoppingMallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    [self initView];
    [self setupView];
//    [self initBannerView];
//    [self loadShoppingMallRequest];
//    [self loadStoreCarefullyChooseRquest];
}

- (void)initData{
    self.dataSource = [NSMutableArray array];
}

- (void)setupView{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _scrollView.pagingEnabled = YES;
    _scrollView.contentSize = CGSizeMake(kScreenWidth * 5, kScreenHeight);
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
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

- (void)initBannerView{
    self.cycleScrollView.imageURLStringsGroup = @[];
    self.cycleScrollView.frame = CGRectMake(0, 44, kScreen_width,kScreen_width*221/375.0);
    self.cycleScrollView.delegate = self;
    [self.view addSubview:self.cycleScrollView];
}

//- (void)initHomeModuleView{
//    [self.homeModuleView setValueWithModelArray:@[]];
//    self.homeModuleView.frame = CGRectMake(0, 44 + 98, kScreen_width, 98);
//    [self.view addSubview:self.homeModuleView];
//}
//
//- (WMHomeModuleView *)homeModuleView {
//    if (!_homeModuleView) {
//        _homeModuleView = [[WMHomeModuleView alloc] initWithFrame:CGRectMake(0, 155, kScreen_width, 98)];
//        _homeModuleView.delegate = self;
//    }
//    return _homeModuleView;
//}

- (SDCycleScrollView *)cycleScrollView{
    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero delegate:self placeholderImage:[UIImage imageNamed:@"img_default"]];
        
        _cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
        _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        _cycleScrollView.autoScrollTimeInterval = 5;
        _cycleScrollView.titleLabelTextColor = [UIColor clearColor];
        _cycleScrollView.titleLabelBackgroundColor = [UIColor clearColor];
        _cycleScrollView.currentPageDotImage = [UIImage imageNamed:@"ic_banner_point_select"];
        _cycleScrollView.pageDotImage = [UIImage imageNamed:@"ic_banner_point_unselect"];
    }
    return _cycleScrollView;
}

//WMHomeModuleDelegate
//- (void)goModuleWith:(HomeAppModel *)appModel{
//
//}

- (void)loadShoppingMallRequest{
    JYShoppingMallAPIManager *shoppingMallAPIManager = [[JYShoppingMallAPIManager alloc] init];
    [shoppingMallAPIManager loadDataWithParams:@{} withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"shoppingmall request response : %@", responseObject);
        for (NSDictionary *dic in responseObject) {
            JYShoppingMallModel *shopMall = [[JYShoppingMallModel alloc] initWithDictionary:dic error:nil];
            [self.dataSource addObject:shopMall];
        };
        
    } withFailure:^(ResponseResult *errorResult) {
        NSLog(@"shoppingmall request error : %@", errorResult);
    }];
}

- (void)loadStoreCarefullyChooseRquest{
    JYStoreCarefullyChooseAPIManager *storeCarefullyChooseAPIManager = [[JYStoreCarefullyChooseAPIManager alloc] init];
    [storeCarefullyChooseAPIManager loadDataWithParams:@{} withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"store carefullychoose request response : %@", responseObject);
    } withFailure:^(ResponseResult *errorResult) {
        NSLog(@"store carefullychoose request error : %@", errorResult);
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
