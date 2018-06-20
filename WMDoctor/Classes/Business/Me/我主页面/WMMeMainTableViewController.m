//
//  WMMeMainTableViewController.m
//  WMDoctor
//  我的主页面
//  Created by JacksonMichael on 2016/12/20.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import "WMMeMainTableViewController.h"
#import "WMServiceViewController.h"
#import "WMGetDoctorInfoAPIManager.h"
#import "WMChangleOnlineStatusAPIManager.h"
#import "WMDoctorInfoModel.h"
#import "WMSettingTableViewController.h"
#import "WMDoctorMainTableViewController.h"
#import "WMMyNameCardViewController.h"
#import "WMMyOrderTableViewController.h"
#import "WMShareWebViewController.h"
#import "AppConfig.h"
#import "WMMyWalletViewController.h"
#import "UINavigationBar+Awesome.h"
#import "WMStarView.h"
#import "WMGetStatusAPIManager.h"
#import "WMStatusModel.h"

#import "WMMyInformationTableViewController.h"
#import "WMAddFriendMenuTableViewController.h"
#import "WMPatientEvaluationViewController.h"
#import "WMMyNameStatusCardViewController.h"
#import "WMDoctorRecordViewController.h"
//textViewControoler
#import "WMQuestionDetailViewController.h"
#import "WMScoreTaskViewController.h"
#import "WMMyMicroBeanViewController.h"
#import "Growing.h"
#import "WMMyNewServiceViewController.h"

@interface WMMeMainTableViewController ()<UIActionSheetDelegate>
{
    WMDoctorInfoModel * model;
    WorkEnvironment _currentEnvir;
    LoginModel * _loginModel;
    UIImageView * _arrowImage;
}

@property (nonatomic,strong) WMStarView * starView;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;    //医生头像ImageView
@property (weak, nonatomic) IBOutlet UILabel *doctorNameLabel;      //医生姓名Label
@property (weak, nonatomic) IBOutlet UILabel *onlineStatusLabel;    //在线标志Label
@property (weak, nonatomic) IBOutlet UIImageView *onlineStatusImageView;        //在线标志图标

@property (weak, nonatomic) IBOutlet UIView * headView;

@end

@implementation WMMeMainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self setupData];   //在viewWillAppear更新
    
    
    [self setupView];
    
    
    //testCode
//    UIBarButtonItem * leftBtn = [[UIBarButtonItem alloc]initWithTitle:@"test" style:UIBarButtonItemStyleDone target:self action:@selector(gotest)];
//    self.navigationItem.leftBarButtonItem = leftBtn;
}

//testFunction
- (void)gotest{
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
    WMScoreTaskViewController * recordVC = (WMScoreTaskViewController *)[storyboard instantiateViewControllerWithIdentifier:@"WMScoreTaskViewController"];
    recordVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:recordVC animated:YES];
}

/**
 UI初始化
 */
- (void)setupView{
    self.tableView.separatorColor=[UIColor colorWithHexString:@"E8E8E8"];
    _headImageView.contentMode=UIViewContentModeScaleAspectFill;
    _headImageView.layer.cornerRadius = 26;
    _headImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    _headImageView.layer.borderWidth = 1;
    _headImageView.layer.masksToBounds = YES;
//    _headImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goMyInformation)];
    [self.headView addGestureRecognizer:singleTap1];
    self.headView.userInteractionEnabled = YES;
    
    
    //设置
    UIBarButtonItem * setBtnItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"bt_setting"] style:UIBarButtonItemStyleDone target:self action:@selector(goSetView)];
    setBtnItem.tintColor = [UIColor colorWithHexString:@"f7f7f7"];
    
    self.navigationItem.rightBarButtonItem = setBtnItem;
    
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.headView.layer addSublayer:[CommonUtil backgroundColorInView:self.headView andStartColorStr:@"02ccff" andEndColorStr:@"1ba0ff"]];
//    });
    self.headView.backgroundColor = [UIColor colorWithHexString:@"18a2ff"];
//    self.headView.backgroundColor = [UIColor colorWithHexString:@"00bcfb"];
    
    
    self.starView = [[WMStarView alloc]initWithFrame:CGRectMake(kScreen_width - 140, 81 - 47, 100, 15)];
    
    [self.headView addSubview:self.starView];
    self.starView.openValue = YES;
    _arrowImage = [[UIImageView alloc]initWithFrame:CGRectMake(kScreen_width - 24, 81-45, 7, 11)];
    _arrowImage.image = [UIImage imageNamed:@"arrow_right"];
    _arrowImage.hidden = YES;
    [self.headView addSubview:_arrowImage];
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear: animated];
    //获取医生信息并更新UI
    
    [self setupData];
    
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
//    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)gofriend{
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Circle" bundle:nil];
    WMAddFriendMenuTableViewController * contactsVC = (WMAddFriendMenuTableViewController *)[storyboard instantiateViewControllerWithIdentifier:@"WMAddFriendMenuTableViewController"];
    contactsVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:contactsVC animated:YES];
    
}

- (void)goMyInformation{
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
    WMMyInformationTableViewController * settingVC = (WMMyInformationTableViewController *)[storyboard instantiateViewControllerWithIdentifier:@"WMMyInformationTableViewController"];
    NSLog(@"controller=%@",settingVC);
    settingVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:settingVC animated:YES];
}

/**
 前往设置页面
 */
- (void)goSetView{
    
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
    WMSettingTableViewController * settingVC = (WMSettingTableViewController *)[storyboard instantiateViewControllerWithIdentifier:@"WMSettingTableViewController"];
    NSLog(@"controller=%@",settingVC);
    settingVC.hidesBottomBarWhenPushed = YES;
    settingVC.backTitle = @"我";
    [self.navigationController pushViewController:settingVC animated:YES];
    
}


/**
 更新状态弹出框
 */
- (void)updateStatus{
    UIActionSheet * sheet = [[UIActionSheet alloc]initWithTitle:@"在线状态" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"在线",@"忙碌",@"休息", nil];
    [sheet showInView:self.view];
    
}


/**
 获取医生基础信息接口
 */
- (void)setupData{
    
    _currentEnvir = [AppConfig currentEnvir];   //获取当前运行环境
    
    WMGetDoctorInfoAPIManager * manager = [[WMGetDoctorInfoAPIManager alloc]init];
    [manager loadDataWithParams:nil withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        model = [[WMDoctorInfoModel alloc]initWithDictionary:responseObject error:nil];
        [_headImageView sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:[UIImage imageNamed:@"ic_head_doc"]];
        _doctorNameLabel.text = model.name;
//        [self setOnlineStatus];
        if ([model.certificationStatus isEqualToString:@"2"]) {
            _onlineStatusLabel.text = model.title;
        }else if ([model.certificationStatus isEqualToString:@"0"]){
            _onlineStatusLabel.text = @"未认证";
        }else if ([model.certificationStatus isEqualToString:@"1"]){
            _onlineStatusLabel.text = @"审核中";
        }else if ([model.certificationStatus isEqualToString:@"3"]){
            _onlineStatusLabel.text = @"未认证";
        }
        
        _loginModel = [WMLoginCache getMemoryLoginModel];
        
        
        //上传用户数据GrowingIO
        [Growing setCS1Value:[NSString stringWithFormat:@"%@",_loginModel.userId] forKey:@"user_id"];
        [Growing setCS2Value:_loginModel.name forKey:@"user_name"];
        [Growing setCS3Value:([_loginModel.sex isEqualToString:@"1"])?@"男":@"女" forKey:@"user_sex"];
        [Growing setCS4Value:@"" forKey:@"user_age"];
        [Growing setCS5Value:(_loginModel.userType)?@"护士":@"医生" forKey:@"user_type"];
        [Growing setCS6Value:@"" forKey:@"company_name"];
        [Growing setCS7Value:@"" forKey:@"department_name"];
        [Growing setCS8Value:model.title forKey:@"job_title"];
        
        
        
//        if (![model.openRenmai isEqualToString:@"1"]) {
//            _arrowImage.hidden = YES;
//            self.headView.userInteractionEnabled = NO;
//        }else{
//            _arrowImage.hidden = NO;
//            self.headView.userInteractionEnabled = YES;
//        }
        _arrowImage.hidden = NO;
        self.headView.userInteractionEnabled = YES;
        if (_loginModel.userType) {
//            _onlineStatusLabel.hidden = YES;  //当前1.4版本不隐藏状态
            _starView.hidden = YES;
            _onlineStatusImageView.hidden = YES;
        }
        [self.starView setStarValue:[model.star floatValue]];
        
        [self.tableView reloadData];
        
    } withFailure:^(ResponseResult *errorResult) {
        
    }];
}


/**
 更改状态UI
 */
- (void)setOnlineStatus{
    
    NSString * str = @"";
    
    if ([model.status isEqualToString:@"0"]) {
        str = @"休息";
        _onlineStatusImageView.image = [UIImage imageNamed:@"ic_mine_offline"];
    }else if ([model.status isEqualToString:@"1"]){
        str = @"忙碌";
        _onlineStatusImageView.image = [UIImage imageNamed:@"ic_mine_busy"];
    }else if([model.status isEqualToString:@"2"]){
        str = @"在线";
        _onlineStatusImageView.image = [UIImage imageNamed:@"ic_mine_online"];
    }
    
    NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc]initWithString:str];
    
    
    
    //创建一个图片
    UIImage * image1 =  [UIImage imageNamed:@"ic_mine_change"];
    NSTextAttachment * attachment1 = [[NSTextAttachment alloc] init];
    attachment1.bounds = CGRectMake(0, -3, 15, 15);
    attachment1.image = image1;
    NSAttributedString * attachStr1 = [NSAttributedString attributedStringWithAttachment:attachment1];
    [attStr insertAttributedString:attachStr1 atIndex:str.length];
    
    
    _onlineStatusLabel.attributedText = attStr;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Table view data source


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00000001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"医生护士：%d",_loginModel.userType);
    if (!_loginModel) {
        return  0.f;
    }else{
        if (_loginModel.userType) {    //护士
            if (indexPath.section == 2) {
                return 50.f;
            }else{
                return 0.0f;
            }
        }else{  //医生
            if ([model.payVisible isEqualToString:@"0"] && indexPath.section == 1 && indexPath.row == 0) {
                return 0.f;
            }else{
                return 50.0f;
            }
        }
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"indexPath.row==%ld",(long)indexPath.row);
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:     //我的主页(我的服务)
            {
//                UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
//                WMDoctorMainTableViewController * doctorVC = [storyboard instantiateViewControllerWithIdentifier:@"WMDoctorMainTableViewController"];
//                doctorVC.backTitle = @"我";
//                doctorVC.hidesBottomBarWhenPushed = YES;
//                [self.navigationController pushViewController:doctorVC animated:YES];
                
                UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
                WMMyNewServiceViewController * doctorVC = [storyboard instantiateViewControllerWithIdentifier:@"WMMyNewServiceViewController"];
                doctorVC.backTitle = @"我";
                doctorVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:doctorVC animated:YES];
                
            }
                break;
            case 1:     //我的名片
            {
                
                LoginModel * loginModel = [WMLoginCache getMemoryLoginModel];
//                loginModel.certStatus = @"1";   //自测试
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
//                        statusModel.status = @"1";  //测试
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
                
                
            }
                break;
            case 2:     //患者评价
            {
                WMPatientEvaluationViewController * myNameCardVC = [WMPatientEvaluationViewController new];
                myNameCardVC.backTitle = @"我";
                myNameCardVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:myNameCardVC animated:YES];
            }
                break;
        }
    }else if (indexPath.section == 1){
        switch (indexPath.row) {
            case 0:     //我的钱包
            {
                WMMyWalletViewController * walletVC = [[WMMyWalletViewController alloc]init];
                walletVC.hidesBottomBarWhenPushed = YES;
                
                walletVC.urlString = (_currentEnvir == 0)?H5_URL_MYWALLET_FORMAL:(_currentEnvir == 3)?H5_URL_MYWALLET_PRE:H5_URL_MYWALLET_TEST;
                
                walletVC.backTitle = @"我";
                [self.navigationController pushViewController:walletVC animated:YES];
            }
                break;
            case 1:     //我的订单
            {
                UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
                WMMyOrderTableViewController * myOrderVC = [storyboard instantiateViewControllerWithIdentifier:@"WMMyOrderTableViewController"];
                myOrderVC.hidesBottomBarWhenPushed = YES;
                myOrderVC.backTitle = @"我";
                [self.navigationController pushViewController:myOrderVC animated:YES];
            }
                break;
            case 2:     //我的微积分
            {
                WMMyMicroBeanViewController *myMicroBeanViewController = [[WMMyMicroBeanViewController alloc] init];
                myMicroBeanViewController.backTitle = @"";
                myMicroBeanViewController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:myMicroBeanViewController animated:YES];
            }
                break;
        }
    }else if (indexPath.section == 2){
        switch (indexPath.row) {
            case 0:     //小脉助手
            {
                [self gotoWMService];
            }
                break;
                
            case 1:     //分享给朋友
            {
                WMShareWebViewController * shareVC = [[WMShareWebViewController alloc]init];
                shareVC.urlString = (_currentEnvir == 0)?H5_URL_SHAREFRIEND:(_currentEnvir == 3)?H5_URL_SHAREFRIEND_PRE:H5_URL_SHAREFRIEND_TEST;
                shareVC.backTitle = @"我";
                shareVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:shareVC animated:YES];
            }
                break;
        }
    }
    
}


/**
 小脉助手跳转 by:茭白
 */
-(void)gotoWMService{
    //小脉助手
    WMServiceViewController *serviceVC=[[WMServiceViewController alloc]init];
    serviceVC.conversationType = ConversationType_CUSTOMERSERVICE;
    serviceVC.targetId = RONGCLOUD_SERVICE_ID;
    serviceVC.title = @"小脉助手";
    serviceVC.backName=@"我";
    //serviceVC.csInfo=customerServiceInfo;
    serviceVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController showViewController:serviceVC sender:nil];
    

}

#pragma mark -- UIActionSheetDelegate


/**
 状态选择点击处理

 @param actionSheet 当前选中Sheet
 @param buttonIndex 选中索引
 */
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString * str;
    if (buttonIndex == 0) {
        str = @"2";
    }else if (buttonIndex == 1){
        str = @"1";
    }else if(buttonIndex == 2){
        str = @"0";
    }
    
    if (str) {
        WMChangleOnlineStatusAPIManager * manager = [[WMChangleOnlineStatusAPIManager alloc]init];
        [manager loadDataWithParams:@{@"status":str} withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
//            model.status = responseObject[@"status"];     //由于返回空，这里用str也行
            model.status = str;
            [self setOnlineStatus];     //改变一下状态UI
        } withFailure:^(ResponseResult *errorResult) {
            
        }];
    }
    
}

- (void)actionSheetCancel:(UIActionSheet *)actionSheet{
    
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
