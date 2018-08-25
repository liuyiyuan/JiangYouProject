//
//  JYCircleViewController.m
//  WMDoctor
//
//  Created by jiangqi on 2018/7/6.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYCircleViewController.h"
#import "JYCircleHeaderView.h"
#import "JYMeTableViewCell.h"
#import "ZJScrollPageView.h"
#import "JYCircleDynamicViewController.h"
#import "JYCircleMessageViewController.h"
#import "JYCircleCircleViewController.h"
@interface JYCircleViewController ()<ZJScrollPageViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) JYCircleHeaderView *headerView;

@property (nonatomic, strong) ZJScrollPageView *scrollPageView;

@property(strong, nonatomic)NSArray<NSString *> *titles;

@property(strong, nonatomic)NSArray<UIViewController *> *childVcs;

@property (nonatomic, strong) UIView *firstLine;

@property (nonatomic, strong) UIView *secondLine;
@end

@implementation JYCircleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
    self.title = @"圈子";
    
    [self configUI];
}

-(void)configUI{
    
    [self.view addSubview:self.headerView];
    
    self.headerView.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, pixelValue(632));

    
    
    //必要的设置, 如果没有设置可能导致内容显示不正常
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    ZJSegmentStyle *style = [[ZJSegmentStyle alloc] init];
    style.titleFont = [UIFont systemFontOfSize:pixelValue(34)];
    style.scrollTitle = NO;
    //显示滚动条
    style.showLine = YES;
    // 颜色渐变
    style.gradualChangeTitleColor = YES;
    // 滚动条的颜色
    style.scrollLineColor = [UIColor colorWithRed:77 / 255.0 green:169 / 255.0 blue:255 / 255.0 alpha:1];
    // 标题一般状态的颜色
    style.normalTitleColor = [UIColor colorWithRed:110 / 255.0 green:110 / 255.0 blue:110 / 255.0 alpha:1];
    // 标题选中状态的颜色
    style.selectedTitleColor = [UIColor colorWithRed:77 / 255.0 green:169 / 255.0 blue:255 / 255.0 alpha:1];
    self.titles = @[@"动态",
                    @"圈子",
                    @"消息",
                    ];
    // 初始化
    _scrollPageView = [[ZJScrollPageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headerView.frame) + pixelValue(10), UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - tarBarHeight - STATUS_BAR_HEIGHT) segmentStyle:style titles:self.titles parentViewController:self delegate:self];
    _scrollPageView.backgroundColor = [UIColor whiteColor];
    _scrollPageView.segmentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.scrollPageView];
   
    [self.scrollPageView addSubview:self.firstLine];
    
    self.firstLine.frame = CGRectMake(UI_SCREEN_WIDTH / 3, pixelValue(20), pixelValue(2), pixelValue(40));
    
    [self.scrollPageView addSubview:self.secondLine];
    
    self.secondLine.frame = CGRectMake(UI_SCREEN_WIDTH / 3 * 2,pixelValue(20), pixelValue(1), pixelValue(40));
    
    
}

- (NSInteger)numberOfChildViewControllers {
    return self.titles.count;
}

- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
    UIViewController<ZJScrollPageViewChildVcDelegate> *childVc = reuseViewController;
    
    if (!childVc) {
        if(index == 0){
            childVc = [[JYCircleDynamicViewController alloc] init];//动态
        }else if(index == 1){
            childVc = [[JYCircleCircleViewController alloc] init];//圈友
        }else if(index == 2){
            childVc = [[JYCircleMessageViewController alloc] init];//消息
        }
        
    }
    
    //    NSLog(@"%ld-----%@",(long)index, childVc);
    
    return childVc;
}

- (void)scrollPageController:(UIViewController *)scrollPageController childViewControllWillAppear:(UIViewController *)childViewController forIndex:(NSInteger)index{
    if(index == 2){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.3 animations:^{
                self.headerView.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, pixelValue(632));
                self.scrollPageView.frame = CGRectMake(0, CGRectGetMaxY(self.headerView.frame) + pixelValue(10), UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - tarBarHeight - STATUS_BAR_HEIGHT);
            }];
        });
       
    }
    
}

- (BOOL)shouldAutomaticallyForwardAppearanceMethods {
    return NO;
}

#pragma mark - tableView滑动到顶部
-(void)CircleDynamicTop{
    [UIView animateWithDuration:0.3 animations:^{
        self.headerView.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, pixelValue(632));
        self.scrollPageView.frame = CGRectMake(0, CGRectGetMaxY(self.headerView.frame) + pixelValue(10), UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - tarBarHeight - STATUS_BAR_HEIGHT);
    }];
}
#pragma mark - tableView滑动到非顶部
-(void)CircleDynamicUnTop{
    [UIView animateWithDuration:0.3 animations:^{
        self.headerView.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, 0);
        self.scrollPageView.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - tarBarHeight - STATUS_BAR_HEIGHT);
        
    }];
}

-(JYCircleHeaderView *)headerView{
    if(!_headerView){
        _headerView = [[JYCircleHeaderView alloc]init];
    }
    return _headerView;
}

-(UIView *)firstLine{
    if(!_firstLine){
        _firstLine = [[UIView alloc]init];
        _firstLine.backgroundColor = [UIColor colorWithRed:110 / 255.0 green:110 / 255.0 blue:110 / 255.0 alpha:1];
    }
    return _firstLine;
}
-(UIView *)secondLine{
    if(!_secondLine){
        _secondLine = [[UIView alloc]init];
        _secondLine.backgroundColor = [UIColor colorWithRed:110 / 255.0 green:110 / 255.0 blue:110 / 255.0 alpha:1];
    }
    return _secondLine;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(CircleDynamicTop) name:@"CircleDynamicTop" object:nil];
      [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(CircleDynamicUnTop) name:@"CircleDynamicUnTop" object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
