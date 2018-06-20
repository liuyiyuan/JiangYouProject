//
//  WMPatientReportedViewController.m
//  WMDoctor
//
//  Created by 茭白 on 2016/12/14.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import "WMPatientReportedViewController.h"
#import "WMPatientReportedAPIManager.h"
#import "WMPatientReportedParamModel.h"
#import "WMPatientReportedModel.h"
#import "WMMyNameCardViewController.h"
#import "WMAllPatienCell.h"
#import "WMAllPatienAcceptCell.h"
#import "WMPatientsAcceptAPIManager.h"
#import "WMRCDataManager.h"
#import "WMRCConversationViewController.h"
#import "WMMyNameStatusCardViewController.h"
#import "WMGetStatusAPIManager.h"
#import "WMStatusModel.h"
#import "WMSearchPatientCell.h"
#import "WMPatientDataViewController.h"
@interface WMPatientReportedViewController ()<UITableViewDelegate,UITableViewDataSource,WMAllPatienCellDelegate>
{
    UITableView *_tableView;
    NSMutableDictionary *_pageDic;
}
@property(nonatomic, strong)NSMutableArray *dataSource;//数据源
@end


@implementation WMPatientReportedViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_tableView) {
        [_tableView reloadData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=self.titleStr;
    [self setupView];
    //[self buildAcceptSuccessView];
    [self setupData];
    [self loadDefaultData];
    self.view.backgroundColor=[UIColor colorWithHexString:@"f4f4f4"];

}

- (void)setupView{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_width, kScreen_height - SafeAreaTopHeight ) style:UITableViewStylePlain];
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
- (void)setupData{
    self.dataSource=[[NSMutableArray  alloc] initWithCapacity:0];
    _pageDic=[[NSMutableDictionary alloc]init];
    
}
- (void)loadDefaultData{
    
    [self loadDataWithPage:1];
}
- (void)loadMoreData{
    NSInteger nextIndex = [[_pageDic valueForKey:@"currentPage"] integerValue]+1;
    [self loadDataWithPage:nextIndex];
}
- (void)loadDataWithPage:(NSInteger)pageIndex{
    WMPatientReportedParamModel *patientReportedParamModel=[[WMPatientReportedParamModel alloc]init];
    patientReportedParamModel.pageNum=[NSString stringWithFormat:@"%ld",(long)pageIndex];
    patientReportedParamModel.pageSize=kPAGEROW;
    WMPatientReportedAPIManager *cricleMainAPIManger=[[WMPatientReportedAPIManager alloc]init];
    [cricleMainAPIManger loadDataWithParams:patientReportedParamModel.toDictionary withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        WMPatientReportedDataModel *patientReportedDataModel=(WMPatientReportedDataModel *)responseObject;
        
        if (pageIndex == 1) {
            [_dataSource removeAllObjects];
        }
        [_dataSource addObjectsFromArray:patientReportedDataModel.list];
        [_pageDic setValue:[NSString stringWithFormat:@"%@",patientReportedDataModel.currentPage] forKey:@"currentPage"];
        
        if (_dataSource.count == 0) {
            NSLog(@"最后一页");
            _tableView.mj_footer.hidden = YES;
            [_tableView showListEmptyView:@"Circle_huanzhebaodaoquesheng" title:@"您还没有患者请求" buttonTitle:@"添加患者" completion:^(UIButton *button) {
                [self jumpCard];
            }];
        } else if([[_pageDic valueForKey:@"currentPage"] floatValue]<[patientReportedDataModel.totalPage floatValue]) {
            [_tableView removeListEmptyViewForNeedToChangeSeparator:NO];
            _tableView.mj_footer.hidden = NO;
        } else{
             [_tableView removeListEmptyViewForNeedToChangeSeparator:NO];
            _tableView.mj_footer.hidden = YES;
        }
        [_tableView reloadData];
        
        if ([_tableView.mj_header isRefreshing]) {
            
            [_tableView.mj_header endRefreshing];
        }
        if ([_tableView.mj_footer isRefreshing]) {
            
            [_tableView.mj_footer endRefreshing];
        }
    } withFailure:^(ResponseResult *errorResult) {
        NSLog(@"error=%@",errorResult);
        
        if (_dataSource.count<=0) {
            [_tableView showListEmptyView:@"Circle_huanzhebaodaoquesheng" title:@"您还没有患者请求" buttonTitle:@"添加患者" completion:^(UIButton *button) {
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
            //                        statusModel.status = @"1";  //测试
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
    
    WMPatientReportedModel *patient = _dataSource[indexPath.row];
    
    if ([patient.acceptMark intValue] == 0) {//接受
        WMSearchPatientCell *patientReportedCell=(WMSearchPatientCell *)[tableView cellForRowAtIndexPath:indexPath];
        
        if (!patientReportedCell) {
            patientReportedCell=[[[NSBundle mainBundle]loadNibNamed:@"WMSearchPatientCell" owner:self options:Nil] lastObject];
        }
        [patientReportedCell setSelectionStyle:UITableViewCellSelectionStyleDefault];
        [patientReportedCell patientReportedVCSetValueWithWMPatientReportedModel:patient];
        patientReportedCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return patientReportedCell;
        
    }else {
        WMSearchPatientCell *patientReportedCell = (WMSearchPatientCell *)[tableView cellForRowAtIndexPath:indexPath];
        
        if (!patientReportedCell) {
            patientReportedCell=[[[NSBundle mainBundle]loadNibNamed:@"WMSearchPatientCell" owner:self options:Nil] lastObject];
        }
        [patientReportedCell setSelectionStyle:UITableViewCellSelectionStyleDefault];
        [patientReportedCell patientReportedVCSetValueWithWMPatientReportedModel:patient];
        return patientReportedCell;
    }
}
#pragma mark--WMAllPatienCellDelegate
-(void)acceptPatientReportAction:(UIButton *)button{
    
    
     WMPatientReportedModel *model=_dataSource[button.tag-200];
    WMPatientsAcceptAPIManager *patientsAcceptAPIManager=[[WMPatientsAcceptAPIManager alloc]init];
    NSDictionary *paramPic=[[NSDictionary alloc] initWithObjectsAndKeys:model.liushuihao,@"liushuihao", nil];
    [patientsAcceptAPIManager loadDataWithParams:paramPic withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSLog(@"jiaobairesponseObject=%@",responseObject);
        NSString *rewardMark=[responseObject objectForKey:@"rewardMark"];
        //奖励标志 0:不奖励，1:奖励
        if ([rewardMark intValue]==0) {
            NSString *title=[NSString stringWithFormat:@"患者已向您报到成功，你可以邀请更多患者扫码关注您"];
            
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"新患者报到咯！" message:title preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [self loadDefaultData];
            }]];
            [self presentViewController:alertController animated:YES completion:NULL];
        }
        else{
            NSString *title=[NSString stringWithFormat:@"该患者为新注册用户，恭喜你获得5元现金奖励"];
            
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"现金奖励来啦！" message:title preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {

                [self loadDefaultData];

            }]];
            
            [self presentViewController:alertController animated:YES completion:NULL];
        }
        
        
    } withFailure:^(ResponseResult *errorResult) {
        
        
    }];
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
    WMPatientReportedModel *patient = _dataSource[indexPath.row];
    
    //跳转到患者资料页
    WMPatientDataViewController *patientDataViewController = [[WMPatientDataViewController alloc] init];
    patientDataViewController.userId = patient.weimaihao;
    patientDataViewController.patientReportedModel = patient;
    [self.navigationController pushViewController:patientDataViewController animated:YES];
}
-(void)buildAcceptSuccessView{
    
    UIView *topTipView=[[UIView alloc]init];
    
    topTipView.frame=CGRectMake(0, 64, kScreen_width, 40);
    topTipView.backgroundColor=[UIColor colorWithHexString:@"50e3a6"];
    topTipView.alpha=0.9;
    [self.view addSubview:topTipView];
    
    UILabel *tipLabel=[[UILabel alloc] init];
    tipLabel.frame=CGRectMake(0, 10, topTipView.frame.size.width, 20);
    tipLabel.font=[UIFont systemFontOfSize:14.0];
    tipLabel.textColor=[UIColor colorWithHexString:@"098f57"];
    tipLabel.text=@"接受成功";
    tipLabel.textAlignment=NSTextAlignmentCenter;
    [topTipView addSubview:tipLabel];
    
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [topTipView removeFromSuperview];
        
    });
    
}

- (void)dealloc
{
    NSLog(@"verifyCode dealloc");
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
