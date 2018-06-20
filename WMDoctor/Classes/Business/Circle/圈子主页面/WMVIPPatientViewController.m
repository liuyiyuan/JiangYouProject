//
//  WMVIPPatientViewController.m
//  WMDoctor
//
//  Created by 茭白 on 2017/3/16.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMVIPPatientViewController.h"
#import "WMVIPPatientTableViewCell.h"
#import "WMCricleVIPPatientAPIManager.h"
#import "WMVPIPatientsModel.h"
#import "WMRCDataManager.h"
#import "WMRCConversationViewController.h"
#import "WMMyNameCardViewController.h"
#import "WMMyNameStatusCardViewController.h"
#import "WMGetStatusAPIManager.h"
#import "WMStatusModel.h"
#import "WMSearchPatientCell.h"
#import "WMPatientDataViewController.h"
@interface WMVIPPatientViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
}
@property(nonatomic, strong) WMVPIPatientsModel *VPIPatientsModel;
@property(nonatomic, strong)NSMutableArray *dataSource;//数据源
@end

@implementation WMVIPPatientViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_tableView) {
        [_tableView reloadData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self setupData];

     // Do any additional setup after loading the view.
}
-(void)setupView{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=[UIColor colorWithHexString:@"f4f4f4"];
    _tableView.tableFooterView=[[UIView alloc] init];
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [_tableView setSeparatorInset:UIEdgeInsetsMake(0,80,0,0)];
    [self.view addSubview:_tableView];
}

-(void)setupData{
    self.title=self.titleStr;
    self.view.backgroundColor=[UIColor colorWithHexString:@"f4f4f4"];
    _dataSource=[[NSMutableArray alloc] initWithCapacity:0];
    [self loadDefaultData];
}


- (void)loadDefaultData{
    
    WMCricleVIPPatientAPIManager *VIPPatientAPIManager=[[WMCricleVIPPatientAPIManager alloc]init];
    
    [VIPPatientAPIManager loadDataWithParams:nil withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        //强制转化不行。
        self.VPIPatientsModel=[[WMVPIPatientsModel alloc] initWithDictionary:responseObject error:nil];
        [_dataSource addObjectsFromArray:self.VPIPatientsModel.vipPatients];
       
        if (_dataSource.count == 0) {
            [_tableView showListEmptyView:@"Circle_VIPhuanzhequesheng" title:@"暂无患者" buttonTitle:@"添加患者" completion:^(UIButton *button) {
                [self jumpCard];
            }];
        } else{
            [_tableView removeListEmptyViewForNeedToChangeSeparator:NO];
            [_tableView reloadData];
        }
        
        
    } withFailure:^(ResponseResult *errorResult) {
        
        if (_dataSource.count==0) {
            if (self.VPIPatientsModel.vipPatients.count==0) {
                [_tableView showListEmptyView:@"Circle_VIPhuanzhequesheng" title:@"暂无患者" buttonTitle:@"添加患者" completion:^(UIButton *button) {
                    [self jumpCard];
                }];
            }
        }
    }];
    
}

#pragma mark--UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    NSLog(@"dddd=%lu",(unsigned long)self.dataSource.count);
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WMVPIPatientsDetailModel *patient = self.dataSource[indexPath.row];
    WMSearchPatientCell *patientReportedCell = (WMSearchPatientCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (!patientReportedCell) {
        patientReportedCell=[[[NSBundle mainBundle]loadNibNamed:@"WMSearchPatientCell" owner:self options:Nil] lastObject];
    }
    [patientReportedCell vipPatientVCSetValueWithWMVPIPatientsDetailModel:patient];
    return patientReportedCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    WMVPIPatientsDetailModel *model = self.VPIPatientsModel.vipPatients[indexPath.row];
    //跳转到患者资料页
    WMPatientDataViewController *patientDataViewController = [[WMPatientDataViewController alloc] init];
    patientDataViewController.userId = model.weimaihao;
    patientDataViewController.vipPatientModel = model;
    [self.navigationController pushViewController:patientDataViewController animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
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
