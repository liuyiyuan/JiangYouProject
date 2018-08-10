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
#import "SDCycleScrollView.h"
#import "JYStoreCarefullyChooseAPIManager.h"
#import "JYStoreCarefullyChooseView.h"
#import "JYPanicBuyView.h"
#import "JYGroupBuyView.h"
#import "JYWelfareView.h"



@interface JYShoppingMallViewController ()<TopicScrollViewDelegate, SDCycleScrollViewDelegate, UIScrollViewDelegate>{
    WYTopicScrollView *_topicScrollView;
    JYMenuSelectorView *_menuSelectorView;
    
}

@property(nonatomic, strong)JYStoreCarefullyChooseView *carefullyChooseView;
@property(nonatomic, strong)JYPanicBuyView *panicBuyView;
@property(nonatomic, strong)JYGroupBuyView *groupBuyView;
@property(nonatomic, strong)JYWelfareView *welfareView;

@property(nonatomic, strong) NSMutableArray *dataSource;
@property(nonatomic, strong) UIScrollView *scrollView;


@end

@implementation JYShoppingMallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    [self initView];
    [self setupView];
    [self setupCarefullyChooseView];
    [self setupPanicBuyView];
    [self setupGroupBuyView];
    [self setupWelfareView];
}

- (void)initData{
    self.dataSource = [NSMutableArray array];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(JYStoreModuleNoti) name:@"JYStoreModuleClickPanicBuy" object:nil];
}

- (void)JYStoreModuleNoti{
    NSLog(@"1");
    [self.scrollView setContentOffset:CGPointMake(kScreenWidth, 0) animated:YES];
}

- (void)setupView{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, kScreenWidth, kScreenHeight - 44)];
    _scrollView.pagingEnabled = YES;
    _scrollView.contentSize = CGSizeMake(kScreenWidth * 5, kScreenHeight);
    _scrollView.scrollEnabled = YES;
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

- (void)setupCarefullyChooseView{
    self.carefullyChooseView = [[JYStoreCarefullyChooseView alloc] initWithFrame:CGRectMake(0, 0, kScreen_width, kScreenHeight - 44)];
    [self.scrollView addSubview:self.carefullyChooseView];
}

- (void)setupPanicBuyView{
    self.panicBuyView = [[JYPanicBuyView alloc] initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight - 44 - 49)];
    [self.scrollView addSubview:self.panicBuyView];
}

- (void)setupGroupBuyView{
    self.groupBuyView = [[JYGroupBuyView alloc] initWithFrame:CGRectMake(kScreenWidth * 2, 0, kScreenWidth, kScreenHeight - 44 - 49)];
    [self.scrollView addSubview:self.groupBuyView];
}

- (void)setupWelfareView{
    self.welfareView = [[JYWelfareView alloc] initWithFrame:CGRectMake(kScreenWidth * 3, 0, kScreenWidth, kScreenHeight - 44 - 49)];
    [self.scrollView addSubview:self.welfareView];
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    NSLog(@"scrollview did zoom");
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    NSLog(@"scrollview will begin dragging");
}

@end
