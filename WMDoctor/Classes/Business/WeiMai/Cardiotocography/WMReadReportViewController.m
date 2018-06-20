//
//  WMReadReportViewController.m
//  WMDoctor
//
//  Created by JacksonMichael on 2017/7/8.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMReadReportViewController.h"
#import "WMAllReportListModel.h"
#import "WMAllReportListGetAPIManager.h"
#import "WMAllReportGetPageParamModel.h"
#import "WMReadReportTableViewCell.h"
#import "WMReportDetailViewController.h"
#import "WMReportListModel.h"

@interface WMReadReportViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableDictionary *_pageDics;
    WMAllReportListModel * _modelsss;
    WMAllReportGetPageParamModel * _customModels;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic, strong)NSMutableArray *dataSource;//数据源
@end

@implementation WMReadReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
//    [self loadDefaultData];
    // Do any additional setup after loading the view.
}


-(void)loadDefaultData{
    [self loadDataWithPage:1];
    
}
-(void)loadMoreData{
    NSInteger nextIndex = [[_pageDics valueForKey:@"currentPage"] integerValue]+1;
    [self loadDataWithPage:nextIndex];
}

- (void)setupUI{
    //初始化
    self.tableView.mj_header = [MJWeiMaiHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadDefaultData)];
    __weak typeof(self) weakSelf = self;
    MJWeiMaiFooter *footer = [MJWeiMaiFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
    self.tableView.mj_footer = footer;
    self.dataSource=[[NSMutableArray  alloc] initWithCapacity:0];
    _pageDics=[[NSMutableDictionary alloc]init];
    
    _modelsss = [WMAllReportListModel new];
    _customModels = [WMAllReportGetPageParamModel new];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.title = @"已处理报告";
}

- (void)loadDataWithPage:(NSInteger)pageIndex{
    
    _customModels.page_no = [NSString stringWithFormat:@"%ld",(long)pageIndex];
    _customModels.page_row = kPAGEROW;
    _customModels.begin_date = @"";
    _customModels.end_date = @"";
    _customModels.status = @"1";
    LoginModel *themodel = [WMLoginCache getMemoryLoginModel];
    
    _customModels.p_uid = themodel.phone;
    
    WMAllReportListGetAPIManager * apiManagers = [WMAllReportListGetAPIManager new];
    [apiManagers loadDataWithParams:_customModels.toDictionary withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        _modelsss = (WMAllReportListModel *)responseObject;
        
        WMAllReportListModels * modelss = (WMAllReportListModels *)_modelsss.allReportsResult;
        
        
        
        if (pageIndex == 1) {
            [_dataSource removeAllObjects];
        }
        [_dataSource addObjectsFromArray:modelss.items];
        [_pageDics setValue:[NSString stringWithFormat:@"%@",_customModels.page_no] forKey:@"currentPage"];
        //        _orderModel = model.orders;
        self.tableView.backgroundView = nil;
        if (_dataSource.count == 0) {
            self.tableView.mj_footer.hidden = YES;
            [self.tableView showBackgroundView:@"暂无报告" type:BackgroundTypeNOReport];
        }
        else if ([[_pageDics valueForKey:@"currentPage"] floatValue]<[modelss.pagecount floatValue]) {
            self.tableView.backgroundView = nil;
            self.tableView.mj_footer.hidden = NO;
        }
        else {
            self.tableView.backgroundView = nil;
            self.tableView.mj_footer.hidden = YES;
        }
        [self.tableView reloadData];
        
        if ([self.tableView.mj_header isRefreshing]) {
            
            [self.tableView.mj_header endRefreshing];
            
        }
        if ([self.tableView.mj_footer isRefreshing]) {
            
            [self.tableView.mj_footer endRefreshing];
            
        }
        
        
    } withFailure:^(ResponseResult *errorResult) {
        if ([self.tableView.mj_header isRefreshing]) {
            [self.tableView.mj_header endRefreshing];
        }
        if ([self.tableView.mj_footer isRefreshing]) {
            [self.tableView.mj_footer endRefreshing];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 107.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.000000001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.000000001f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"WeiMai" bundle:nil];
    WMReportDetailViewController * reportVC = [storyboard instantiateViewControllerWithIdentifier:@"WMReportDetailViewController"];
    reportVC.title = ((WMAllReportListModelItems *)_dataSource[indexPath.row]).tname;
    reportVC.report_id = ((WMAllReportListModelItems *)_dataSource[indexPath.row]).mid;
    [self.navigationController pushViewController:reportVC animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WMReadReportTableViewCell * cell = (WMReadReportTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"WMReadReportTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setCellValue:(WMAllReportListModelItems *)_dataSource[indexPath.row]];
    
    
    return cell;
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self loadDefaultData];
}
@end
