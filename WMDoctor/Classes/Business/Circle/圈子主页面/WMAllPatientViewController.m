//
//  WMAllPatientViewController.m
//  WMDoctor
//
//  Created by 茭白 on 2017/2/21.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMAllPatientViewController.h"
#import "WMAllPatientTableViewCell.h"
#import "WMTotalPatientsAPIManagere.h"
#import "WMPatientReportedParamModel.h"
#import "WMTotalPatientsDataModel.h"
#import "WMRCDataManager.h"
#import "WMRCConversationViewController.h"
#import "WMMyNameCardViewController.h"
#import "WMMyNameStatusCardViewController.h"
#import "WMGetStatusAPIManager.h"
#import "WMStatusModel.h"
#import "WMSearchPatientCell.h"
#import "WMPatientDataViewController.h"
@interface WMAllPatientViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSMutableDictionary *_pageDic;
}
@property(nonatomic, strong)NSMutableArray *dataSource;//数据源

@end

@implementation WMAllPatientViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_tableView) {
        [_tableView reloadData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupData];
    [self setupView];
    [self loadDefaultData];

    // Do any additional setup after loading the view.
}
-(void)setupView{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_width, kScreen_height - SafeAreaTopHeight) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.tableFooterView=[UIView new];
    [_tableView setSeparatorInset:UIEdgeInsetsMake(0,70,0,0)];
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:_tableView];
    _tableView.backgroundColor=[UIColor colorWithHexString:@"f4f4f4"];
    _tableView.mj_header = [MJWeiMaiHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadDefaultData)];
    __weak typeof(self) weakSelf = self;
    MJWeiMaiFooter *footer = [MJWeiMaiFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
     
    _tableView.mj_footer = footer;
}

-(void)setupData{
    self.title=@"所有患者";
    self.view.backgroundColor=[UIColor colorWithHexString:@"f4f4f4"];
    self.dataSource=[[NSMutableArray  alloc] initWithCapacity:0];
    _pageDic=[[NSMutableDictionary alloc]init];
}

-(void)loadDefaultData{
    
    [self loadDataWithPage:1];
    
}

-(void)loadMoreData{
    NSInteger nextIndex = [[_pageDic valueForKey:@"currentPage"] integerValue]+1;
    [self loadDataWithPage:nextIndex];
}
- (void)loadDataWithPage:(NSInteger)pageIndex{
    
    WMPatientReportedParamModel *patientReportedParamModel=[[WMPatientReportedParamModel alloc]init];
    patientReportedParamModel.pageNum=[NSString stringWithFormat:@"%ld",(long)pageIndex];
    patientReportedParamModel.pageSize=kPAGEROW;
    
    
    WMTotalPatientsAPIManagere *totalPatientsAPIManagere=[[WMTotalPatientsAPIManagere alloc]init];
    
    [totalPatientsAPIManagere loadDataWithParams:patientReportedParamModel.toDictionary withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"responseObject : %@", responseObject);
        //强制转化不行。
        WMTotalPatientsDataModel *totalPatientsDataModel=[[WMTotalPatientsDataModel alloc] initWithDictionary:responseObject error:nil];
        if (pageIndex==1) {
            [_dataSource removeAllObjects];
        }
                
        [_dataSource addObjectsFromArray:totalPatientsDataModel.list];
        
        [_pageDic setValue:[NSString stringWithFormat:@"%@",totalPatientsDataModel.currentPage] forKey:@"currentPage"];
        if (_dataSource.count == 0) {
            NSLog(@"最后一页");
            [_tableView showListEmptyView:@"Circle_suoyouhuanzhequesheng" title:@"您还没有患者请求" buttonTitle:@"添加患者" completion:^(UIButton *button) {
                [self jumpCard];
                
            }];
            _tableView.mj_footer.hidden = YES;
             
        }else{
            [_tableView removeListEmptyViewForNeedToChangeSeparator:NO];
        }
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        if (totalPatientsDataModel.list.count < [kPAGEROW intValue]) {
            [_tableView.mj_footer endRefreshingWithNoMoreData];
        }
        [_tableView reloadData];
        
        
    } withFailure:^(ResponseResult *errorResult) {
        
        if (_dataSource.count<=0) {
            
            [_tableView showListEmptyView:@"Circle_suoyouhuanzhequesheng" title:@"您还没有患者请求" buttonTitle:@"添加患者" completion:^(UIButton *button) {
                [self jumpCard];
            }];
        }
        
        if ([_tableView.mj_header isRefreshing]) {
            [_tableView.mj_header endRefreshing];
        }
        if ([_tableView.mj_footer isRefreshing]) {
            [_tableView.mj_footer endRefreshing];
        }

    }];
       
}
-(void)jumpCard{
    __weak typeof(self) weakSelf=self;
    LoginModel * loginModel = [WMLoginCache getMemoryLoginModel];
    if ([loginModel.certStatus isEqualToString:@"2"]) { //先判断内存中的状态，如果已认证通过就直接进去不请求接口了
        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
        WMMyNameCardViewController * myNameCardVC = [storyboard instantiateViewControllerWithIdentifier:@"WMMyNameCardViewController"];
        myNameCardVC.backTitle = @"我";
        myNameCardVC.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:myNameCardVC animated:YES];
    }else{
        WMGetStatusAPIManager * apiManager = [WMGetStatusAPIManager new];
    [apiManager loadDataWithParams:nil withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        WMStatusModel * statusModel = (WMStatusModel *)responseObject;
        if ([statusModel.status isEqualToString:@"2"]) {
            UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
            WMMyNameCardViewController * myNameCardVC = [storyboard instantiateViewControllerWithIdentifier:@"WMMyNameCardViewController"];
            myNameCardVC.backTitle = @"返回";
            myNameCardVC.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:myNameCardVC animated:YES];
        }else{
            UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
            WMMyNameStatusCardViewController * myNameCardVC = [storyboard instantiateViewControllerWithIdentifier:@"WMMyNameStatusCardViewController"];
            myNameCardVC.backTitle = @"返回";
            myNameCardVC.status = statusModel.status;
            myNameCardVC.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:myNameCardVC animated:YES];
        }
    } withFailure:^(ResponseResult *errorResult) {
        
    }];
    }
}
#pragma mark--UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataSource.count;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WMTotalPatientsModel *patient=_dataSource[indexPath.row];
    WMSearchPatientCell *patientReportedCell = (WMSearchPatientCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (!patientReportedCell) {
        patientReportedCell=[[[NSBundle mainBundle]loadNibNamed:@"WMSearchPatientCell" owner:self options:Nil] lastObject];
    }
    [patientReportedCell allPatientVCSetValueWithWMTotalPatientsModel:patient];
    return patientReportedCell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    WMTotalPatientsModel *model=_dataSource[indexPath.row];
    //跳转到患者资料页
    WMPatientDataViewController *patientDataViewController = [[WMPatientDataViewController alloc] init];
    patientDataViewController.userId = [NSString stringWithFormat:@"%@", model.weimaihao];
    patientDataViewController.totalPatientModel = model;
    [self.navigationController pushViewController:patientDataViewController animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
