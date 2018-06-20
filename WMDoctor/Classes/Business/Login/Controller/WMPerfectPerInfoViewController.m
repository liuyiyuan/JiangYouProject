//
//  WMPerfectPerInfoViewController.m
//  WMDoctor
//
//  Created by 茭白 on 2017/5/15.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMPerfectPerInfoViewController.h"
#import "WMNamePerfectViewController.h"
#import "WMHospitalChooseViewController.h"
#import "WMJobsChooseViewController.h"
#import "WMCertificationViewController.h"
#import "WMCertificationTextTableViewCell.h"
#import "WMSectionChooseViewController.h"
#import "WMVerifyCodeParam.h"
#import "WMDevice.h"
#import "WMPerfectPerInfoAPIManager.h"
#import "WMLoginMainViewController.h"
#import "WMCertificationViewController.h"

@interface WMPerfectPerInfoViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
}
@property(nonatomic ,strong)UIView *headerView;
@property(nonatomic ,strong)UIButton *sureButton;
@end

@implementation WMPerfectPerInfoViewController

- (void)viewDidLoad {
    self.fd_interactivePopDisabled = YES;
    [super viewDidLoad];
    self.navigationItem.title=@"完善个人信息";
    
    [self setupView];
   
    // Do any additional setup after loading the view.
}
-(void)backButtonAction:(UIBarButtonItem *)item{
    
    [self cleanInformationModel];
    NSArray * arr =  self.navigationController.viewControllers;
    for (int i = 0; i < arr.count;i++) {
        UIViewController * views = (UIViewController *)arr[i];
        if([NSStringFromClass(views.class) isEqualToString:@"WMLoginMainViewController"]){
            WMLoginMainViewController *VC=(WMLoginMainViewController *)views;
            //VC.photos=self.array;
            [self.navigationController popToViewController:VC animated:YES];
        }
        
    }
   
   
}
-(void)cleanInformationModel{
    [WMInformationModel shareInformationModel].name=nil;
    [WMInformationModel shareInformationModel].jobName=nil;
    [WMInformationModel shareInformationModel].jobBH=nil;
    [WMInformationModel shareInformationModel].jobType=nil;
    [WMInformationModel shareInformationModel].hosName=nil;
    [WMInformationModel shareInformationModel].hosBH=nil;
    [WMInformationModel shareInformationModel].SectionName=nil;
    [WMInformationModel shareInformationModel].SectionBH=nil;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_tableView reloadData];
    
}
-(void)setupView{
    self.view.backgroundColor=[UIColor colorWithHexString:@"f4f4f4"];
    _tableView=[[UITableView alloc]init];
    _tableView.frame=CGRectMake(0, 0, kScreen_width, kScreen_height);
    _tableView.backgroundColor=[UIColor colorWithHexString:@"f4f4f4"];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.tableFooterView=[UIView new];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.separatorInset=UIEdgeInsetsMake(0,0,0,0);
    _tableView.tableHeaderView=self.headerView;
    
    [self.view addSubview:_tableView];
    
    
    _sureButton=[UIButton buttonWithType:UIButtonTypeCustom];
    _sureButton.frame=CGRectMake(15, 250+20, kScreen_width-15*2, 48);
    _sureButton.backgroundColor=[UIColor colorWithHexString:@"18a2ff"];
    [_sureButton setTitle:@"立即体验" forState:UIControlStateNormal];
    [_sureButton setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    _sureButton.layer.cornerRadius=4;
    [_sureButton addTarget:self action:@selector(sureAction:) forControlEvents:UIControlEventTouchUpInside];
    _sureButton.layer.masksToBounds=YES;
    [_tableView addSubview:_sureButton];
    
    
    
    
}
-(void)sureAction:(UIButton *)button{
    
    
    WMInformationModel *infomationModel=[WMInformationModel shareInformationModel];
    if (stringIsEmpty(infomationModel.name)) {
    
        [PopUpUtil alertWithMessage:@"请填写姓名" toViewController:self withCompletionHandler:^{
            
        }];
        return;
    }
    if (stringIsEmpty(infomationModel.jobName)) {
        [PopUpUtil alertWithMessage:@"请填写职业" toViewController:self withCompletionHandler:^{
            
        }];
         return;
    }
    if (stringIsEmpty(infomationModel.hosName)) {
        [PopUpUtil alertWithMessage:@"请填写医院" toViewController:self withCompletionHandler:^{
            
        }];
         return;
    }
    if (stringIsEmpty(infomationModel.SectionName)) {
        [PopUpUtil alertWithMessage:@"请填写科室" toViewController:self withCompletionHandler:^{
            
        }];
         return;
    }
    
    
    WMVerifyCodeParam * param = [[WMVerifyCodeParam alloc]init];
    param.phone = _phoneNumber;
    //param.verifyCode = _codeTextField.text;
    param.phoneId = [WMDevice currentDevice].uuidString;
    param.phoneModel = [WMDevice currentDevice].deviceModel;
    param.phoneOS = [WMDevice currentDevice].systemVersion;
    param.clientType=@"IOS";
    param.organizationCode=infomationModel.hosBH;
    param.name=infomationModel.name;
    param.departmentCode=infomationModel.SectionBH;
    param.jobLevel=infomationModel.jobBH;
    param.jobType=infomationModel.jobType;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    param.cid = [defaults objectForKey:@"clientId"];
    
    
    WMPerfectPerInfoAPIManager *perfectPerInfoAPIManager=[[WMPerfectPerInfoAPIManager alloc] init];
    [perfectPerInfoAPIManager loadDataWithParams:param.toDictionary withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSLog(@"responseObject=%@",responseObject);
        
        LoginModel * login = [[LoginModel alloc] init];
        login.avatar = responseObject[@"avatar"];
        login.name = responseObject[@"name"];
        login.phone = responseObject[@"phone"];
        login.rongToken = responseObject[@"rongToken"];
        login.sessionId = responseObject[@"sessionId"];
        login.sex = responseObject[@"sex"];
        login.status = responseObject[@"treatStatus"];
        login.userCode = responseObject[@"userCode"];
        login.userId = responseObject[@"userId"];
        login.loginFlag = @"1";
        login.certStatus=responseObject[@"certStatus"];
#warning -mark need modificate from API
        
        //TO DO>>>
        login.userType = [responseObject[@"userType"]  boolValue];
        
        
        [self cleanInformationModel];
        
        [WMLoginCache setDiskLoginModel:login];
        [WMLoginCache setMemoryLoginModel:login];
        
        LoginModel * model = [WMLoginCache getDiskLoginModel];
        RCUserInfo *_currentUserInfo =[[RCUserInfo alloc] initWithUserId:[NSString stringWithFormat:@"%@",model.userCode] name:model.name portrait:model.avatar];
        
        
        //头像跟新后，在融云的服务器跟新头像
        [RCIM sharedRCIM].currentUserInfo=_currentUserInfo;
        [[RCIM sharedRCIM]
         refreshUserInfoCache:_currentUserInfo
         withUserId:[NSString stringWithFormat:@"%@",model.userCode]];
        WMCertificationViewController *certificationVC=[[WMCertificationViewController alloc] init];
        certificationVC.isFirstLogin=YES;
        [self.navigationController pushViewController:certificationVC animated:YES];
        
        /*
        [[NSNotificationCenter defaultCenter] postNotificationName:kLoginInSuccessNotification
                                                            object:nil
                                                          userInfo:@{@"EnterType":@"CheckEnter"}];
         */
        
    } withFailure:^(ResponseResult *errorResult) {
        
    }];
    NSLog(@"恭喜你顺利过关");
    
    
}
#pragma mark--UITableViewDataSource

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    //cell.textLabel.textColor=[UIColor defaultColor];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.textLabel.font=[UIFont systemFontOfSize:14.0];
        cell.textLabel.textColor=[UIColor colorWithHexString:@"333333"];
        cell.detailTextLabel.font=[UIFont systemFontOfSize:14.0];
        cell.detailTextLabel.textColor=[UIColor colorWithHexString:@"999999"];
        
    }

    WMInformationModel *informationModel=[WMInformationModel shareInformationModel];

     cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (indexPath.row==0) {
         cell.textLabel.text=@"姓名";
        if (!stringIsEmpty(informationModel.name) ) {
            cell.detailTextLabel.text=informationModel.name;
            cell.detailTextLabel.textColor=[UIColor colorWithHexString:@"333333"];
        }else{
          cell.detailTextLabel.text=@"请填写真实姓名";
        }
        
    }
    else if (indexPath.row==1){
         cell.textLabel.text=@"职业";
        if (!stringIsEmpty(informationModel.jobName)) {
            cell.detailTextLabel.text=informationModel.jobName;
            cell.detailTextLabel.textColor=[UIColor colorWithHexString:@"333333"];
        }else{
           cell.detailTextLabel.text=@"请选择职业";
        }
        
    }
    else if (indexPath.row==2){
         cell.textLabel.text=@"医院";
        if (!stringIsEmpty(informationModel.hosName)) {
            cell.detailTextLabel.text=informationModel.hosName;
            cell.detailTextLabel.textColor=[UIColor colorWithHexString:@"333333"];
        }else{
            cell.detailTextLabel.text=@"请选择医院";
        }
        
    }
    else{
         cell.textLabel.text=@"科室";
        if (!stringIsEmpty(informationModel.SectionName)) {
             cell.detailTextLabel.text=informationModel.SectionName;
             cell.detailTextLabel.textColor=[UIColor colorWithHexString:@"333333"];
        }else{
            cell.detailTextLabel.text=@"请选择科室";
        }
        
    }
    
    return cell;
    
}
#pragma mark--UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
     WMInformationModel *informationModel=[WMInformationModel shareInformationModel];
    if (indexPath.row==0) {
        
            WMNamePerfectViewController *namePerfectVC=[[WMNamePerfectViewController alloc] init];
            [self.navigationController pushViewController:namePerfectVC animated:YES];
        
        
    }
    else if (indexPath.row==1){
       
            WMJobsChooseViewController *hospitalChooseVC=[[WMJobsChooseViewController alloc] init];
            [self.navigationController pushViewController:hospitalChooseVC animated:YES];
    
       
    }

    else if (indexPath.row==2){
       
            WMHospitalChooseViewController *hospitalChooseVC=[[WMHospitalChooseViewController alloc] init];
            [self.navigationController pushViewController:hospitalChooseVC animated:YES];
        
        

       
    }
    else{
        
        if (!stringIsEmpty(informationModel.hosBH)) {
            WMSectionChooseViewController *sectionChooseVC=[[WMSectionChooseViewController alloc] init];
            sectionChooseVC.organizationCode=informationModel.hosBH;
            sectionChooseVC.hosName=informationModel.hosName;
            [self.navigationController pushViewController:sectionChooseVC animated:YES];
            
        }
        else{
            WMHospitalChooseViewController *hospitalChooseVC=[[WMHospitalChooseViewController alloc] init];
            [self.navigationController pushViewController:hospitalChooseVC animated:YES];
        }
        
        
        
        
            
            
        
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_width, 50)];
        _headerView.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
        UILabel *label=[[UILabel alloc] init];
        label.frame=CGRectMake(15, 15, kScreen_width-15*2, 30);
        label.text=@"为了给你提供更好的服务，请填写真实的个人信息";
        label.textColor=[UIColor colorWithHexString:@"666666"];
        label.font=[UIFont systemFontOfSize:12.0];
        label.textAlignment=NSTextAlignmentCenter;
        [_headerView addSubview:label];
    }
    return _headerView;
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
