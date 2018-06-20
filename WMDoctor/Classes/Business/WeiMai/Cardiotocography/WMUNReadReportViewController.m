//
//  WMUNReadReportViewController.m
//  WMDoctor
//
//  Created by JacksonMichael on 2017/7/8.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMUNReadReportViewController.h"
#import "WMAllReportListModel.h"
#import "WMAllReportListGetAPIManager.h"
#import "WMAllReportGetPageParamModel.h"
#import "WMUNReadReportTableViewCell.h"
#import "WMReportDetailViewController.h"
#import "WMAllReportListViewController.h"

@interface WMUNReadReportViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableDictionary *_pageDic;
    WMAllReportListModel * _model;
    WMAllReportGetPageParamModel * _customModel;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic, strong)NSMutableArray *dataSource;//数据源
@end

@implementation WMUNReadReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self loadDefaultData];
    self.automaticallyAdjustsScrollViewInsets = NO;
    // Do any additional setup after loading the view.
}


-(void)loadDefaultData{
    [self loadDataWithPage:1];
    
}
-(void)loadMoreData{
    NSInteger nextIndex = [[_pageDic valueForKey:@"currentPage"] integerValue]+1;
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
    _pageDic=[[NSMutableDictionary alloc]init];
    
    _model = [WMAllReportListModel new];
    _customModel = [WMAllReportGetPageParamModel new];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(receiveNotificiation:) name:@"updateCount" object:nil];
    
    self.title = @"待处理报告";
}

- (void)receiveNotificiation:(NSNotification*)sender{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self loadDefaultData];
        
    });
    
}

- (void)loadDataWithPage:(NSInteger)pageIndex{
    
    _customModel.page_no = [NSString stringWithFormat:@"%ld",(long)pageIndex];
    _customModel.page_row = kPAGEROW;
    _customModel.begin_date = @"";
    _customModel.end_date = @"";
    _customModel.status = @"0";
    LoginModel *themodel = [WMLoginCache getMemoryLoginModel];
    
    _customModel.p_uid = themodel.phone;
    
    WMAllReportListGetAPIManager * apiManager = [WMAllReportListGetAPIManager new];
    [apiManager loadDataWithParams:_customModel.toDictionary withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        _model = (WMAllReportListModel *)responseObject;
        
        WMAllReportListModels * models = (WMAllReportListModels *)_model.allReportsResult;
        NSDictionary * dic = [[NSDictionary alloc]initWithObjectsAndKeys:models.records,@"theValue", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WMUNReadReportViewController" object:@"unReadCount" userInfo:dic];
        
        if (pageIndex == 1) {
            [_dataSource removeAllObjects];
        }
        [_dataSource addObjectsFromArray:models.items];
        [_pageDic setValue:[NSString stringWithFormat:@"%@",_customModel.page_no] forKey:@"currentPage"];
        //        _orderModel = model.orders;
        self.tableView.backgroundView = nil;
        if (_dataSource.count == 0) {
            self.tableView.mj_footer.hidden = YES;
            [self.tableView showBackgroundView:@"暂无报告" type:BackgroundTypeNOUNReport];
        }
        else if ([[_pageDic valueForKey:@"currentPage"] floatValue]<[models.pagecount floatValue]) {
            self.tableView.backgroundView = nil;
            self.tableView.mj_footer.hidden = NO;
        }
        else {
            self.tableView.backgroundView = nil;
            self.tableView.mj_footer.hidden = YES;
        }
        [self.tableView reloadData];
        
//        self.lastTitle = [NSString stringWithFormat:@"待处理(%lu)",(unsigned long)_dataSource.count];
        
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
    return 80.f;
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
    WMUNReadReportTableViewCell * cell = (WMUNReadReportTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"WMUNReadReportTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setCellValue:(WMAllReportListModelItems *)_dataSource[indexPath.row]];
    
    
    return cell;
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateCount" object:nil];
    
}

//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:YES];
//    [self loadDefaultData];
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
