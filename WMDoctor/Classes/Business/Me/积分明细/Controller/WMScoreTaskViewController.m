//
//  WMScoreTaskViewController.m
//  WMDoctor
//
//  Created by JacksonMichael on 2017/11/28.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMScoreTaskViewController.h"
#import "WMScoreTaskListCell.h"
#import "WMGetTaskListAPIManager.h"
#import "WMScoreTaskModel.h"
#import "WMMyInformationTableViewController.h"
#import "WMShareWebViewController.h"
#import "WMGetStatusAPIManager.h"
#import "WMMyNameCardViewController.h"
#import "WMStatusModel.h"
#import "WMMyNameStatusCardViewController.h"
#import "AppConfig.h"
#import "WMDaySignAPIManager.h" //签到

@interface WMScoreTaskViewController ()<UITableViewDelegate,UITableViewDataSource,WMScoreTaskCellDelegate>
{
    WorkEnvironment _currentEnvir;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSArray * dataScore;

@property (nonatomic,strong) WMScoreTaskListModel * listScore;

@end

@implementation WMScoreTaskViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initUI];
    [self initData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

- (void)initUI{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    self.tableView.backgroundColor = [UIColor colorWithHexString:@"dedede"];
    self.view.backgroundColor = [UIColor colorWithHexString:@"dedede"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _currentEnvir = [AppConfig currentEnvir];   //获取当前运行环境
}

- (void)initData{
    WMGetTaskListAPIManager * apiManager = [WMGetTaskListAPIManager new];
    [apiManager loadDataWithParams:nil withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"responseObject:%@",responseObject);
        WMScoreTaskModel * model = (WMScoreTaskModel *)responseObject;
        _dataScore = model.tasks;
        
        [self.tableView reloadData];
    } withFailure:^(ResponseResult *errorResult) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_dataScore) {
        return _dataScore.count;
    }else{
        return 0;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_dataScore) {
        WMScoreTaskListModel * listModel =  (WMScoreTaskListModel *)_dataScore[section];
        return listModel.taskRuleList.count;
    }else{
        return 0;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WMScoreTaskListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"WMScoreTaskListCell" forIndexPath:indexPath];
    WMScoreTaskListModel * listModel =  (WMScoreTaskListModel *)_dataScore[indexPath.section];
    NSArray * arrlist = listModel.taskRuleList;
    WMScoreTaskDetailModel * model = (WMScoreTaskDetailModel *)arrlist[indexPath.row];
    [cell setCellValue:model];
    cell.delegate = self;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}



#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 43;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0000001;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView * sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_width, 43)];
    UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(11, 15, 100, 20)];
    WMScoreTaskListModel * listModel =  (WMScoreTaskListModel *)_dataScore[section];
    title.text = listModel.taskTypeName;
    title.font = [UIFont systemFontOfSize:14];
    title.textColor = [UIColor colorWithHexString:@"999999"];
    [sectionView addSubview:title];
    return sectionView;
}


-(void)cellBtnClick:(NSString *)Code{
    if ([Code isEqualToString:@"1001"]) {       //与患者交流
        [self.tabBarController setSelectedIndex:1];
    }else if([Code isEqualToString:@"1002"]){       //在医生朋友圈内发言
        [self.tabBarController setSelectedIndex:1];
    }else if([Code isEqualToString:@"1003"]){       //发布一条今日医声
        [self.tabBarController setSelectedIndex:1];
    }else if([Code isEqualToString:@"1004"]){       //注册认证
        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
        WMMyInformationTableViewController * settingVC = (WMMyInformationTableViewController *)[storyboard instantiateViewControllerWithIdentifier:@"WMMyInformationTableViewController"];
        NSLog(@"controller=%@",settingVC);
        settingVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:settingVC animated:YES];
    }else if([Code isEqualToString:@"1005"]){       //完善信息
        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
        WMMyInformationTableViewController * settingVC = (WMMyInformationTableViewController *)[storyboard instantiateViewControllerWithIdentifier:@"WMMyInformationTableViewController"];
        NSLog(@"controller=%@",settingVC);
        settingVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:settingVC animated:YES];
    }else if([Code isEqualToString:@"1006"]){       //完成5个患者报到
        LoginModel * loginModel = [WMLoginCache getMemoryLoginModel];
        if ([loginModel.certStatus isEqualToString:@"2"]) { //先判断内存中的状态，如果已认证通过就直接进去不请求接口了
            UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
            WMMyNameCardViewController * myNameCardVC = [storyboard instantiateViewControllerWithIdentifier:@"WMMyNameCardViewController"];
            myNameCardVC.backTitle = @"我";
            myNameCardVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:myNameCardVC animated:YES];
        }else{
            WMGetStatusAPIManager * apiManager = [WMGetStatusAPIManager new];
            [apiManager loadDataWithParams:nil withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
                WMStatusModel * statusModel = (WMStatusModel *)responseObject;
                loginModel.certStatus = statusModel.status;
                [WMLoginCache setDiskLoginModel:loginModel];
                [WMLoginCache setMemoryLoginModel:loginModel];
                if ([statusModel.status isEqualToString:@"2"]) {
                    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
                    WMMyNameCardViewController * myNameCardVC = [storyboard instantiateViewControllerWithIdentifier:@"WMMyNameCardViewController"];
                    myNameCardVC.backTitle = @"我";
                    myNameCardVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:myNameCardVC animated:YES];
                }else{
                    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
                    WMMyNameStatusCardViewController * myNameCardVC = [storyboard instantiateViewControllerWithIdentifier:@"WMMyNameStatusCardViewController"];
                    myNameCardVC.backTitle = @"我";
                    myNameCardVC.status = statusModel.status;
                    myNameCardVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:myNameCardVC animated:YES];
                }
            } withFailure:^(ResponseResult *errorResult) {
                
            }];
        }
    }else if([Code isEqualToString:@"1007"]){       //完成首个付费订单
        
    }else if([Code isEqualToString:@"1008"]){       //邀请同行并认证成功
        WMShareWebViewController * shareVC = [[WMShareWebViewController alloc]init];
        shareVC.urlString = (_currentEnvir == 0)?H5_URL_SHAREFRIEND:(_currentEnvir == 3)?H5_URL_SHAREFRIEND_PRE:H5_URL_SHAREFRIEND_TEST;
        shareVC.backTitle = @"我";
        shareVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:shareVC animated:YES];
    }else if([Code isEqualToString:@"1000"]){       //签到
        WMDaySignAPIManager * apiManager = [WMDaySignAPIManager new];
        [apiManager loadDataWithParams:nil withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSDate * date = [NSDate date];
            NSString * todayString = [[date description] substringToIndex:10];
            LoginModel * loginM = [WMLoginCache getMemoryLoginModel];
            NSString * phone = [NSString stringWithFormat:@"%@,%@",todayString,loginM.phone];
            [defaults setObject:phone forKey:@"daySign"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self initData];
        } withFailure:^(ResponseResult *errorResult) {
            
        }];
    }
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
