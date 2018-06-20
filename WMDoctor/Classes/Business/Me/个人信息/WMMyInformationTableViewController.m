//
//  WMMyInformationTableViewController.m
//  WMDoctor
//  微脉选择器（高端酷炫业务逻辑处理，但已废弃）
//  Created by JacksonMichael on 2017/3/21.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMMyInformationTableViewController.h"
#import "WMSchoolListTableViewController.h"
#import "WMDoctorInformationModel.h"
#import "WMDoctorInfoAPIManager.h"
#import "WMSelectorTableViewController.h"
#import "WMDoctorInfoSaveAPIManager.h"
#import "WMDoctorInformationCustomModel.h"
#import "NSString+IDCardVerify.h"
#import "WMEducationSelectViewController.h"
#import "WMProvinceSelectViewController.h"
#import "ZYQAssetPickerController.h"
#import "BlockUI.h"
#import "WMAvatarAPIManager.h"
#import "WMNamePerfectViewController.h"
#import "WMHospitalChooseViewController.h"
#import "WMJobsChooseViewController.h"
#import "WMMultilineTextViewController.h"
#import "WMGetStatusAPIManager.h"
#import "WMStatusModel.h"
#import "WMInfoTransitionViewController.h"
#import "WMSectionChooseViewController.h"
#import "WMCertificationViewController.h"
#import "WMGetStatusLoadingAPIManager.h"
#import "WMRCUserInfoEntitys+CoreDataClass.h"

@import Photos;
@import AssetsLibrary;
#define IMAGESIZE_M 1024*1024
@interface WMMyInformationTableViewController ()<ZYQAssetPickerControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    WMDoctorInformationModel * _model;
    NSArray * _defaultTagsArr;
    NSMutableArray * _choiceTagsArr;
    WMDoctorInformationCustomModel * _saveModel;
    //登陆信息
    LoginModel * _loginModel;
}

@property (nonatomic,strong)NSMutableArray *photos;
@property (nonatomic,assign)int SupportNumber;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;        //姓名标签
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;        //地区标签
@property (weak, nonatomic) IBOutlet UILabel *schoolLabel;      //学校标签

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;    //个人头像
@property (weak, nonatomic) IBOutlet UIImageView *renzhengImageView;    //认证图标
@property (weak, nonatomic) IBOutlet UILabel *renzhengLabel;    //认证文字

@property (weak, nonatomic) IBOutlet UILabel *hospitalLabel;    //医院标签
@property (weak, nonatomic) IBOutlet UILabel *departmentLabel;  //科室标签
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;       //职称标签

@property (weak, nonatomic) IBOutlet UILabel *goodAtLabel;      //擅长标签
@property (weak, nonatomic) IBOutlet UILabel *profilesLabel;    //简介标签


@property (weak, nonatomic) IBOutlet UITableViewCell *nameCell;         //姓名cell
@property (weak, nonatomic) IBOutlet UITableViewCell *renzhengCell;     //认证cell
@property (weak, nonatomic) IBOutlet UITableViewCell *hospitalCell;     //医院cell
@property (weak, nonatomic) IBOutlet UITableViewCell *departmentCell;   //科室cell
@property (weak, nonatomic) IBOutlet UITableViewCell *titleCell;        //职称cell

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameConstarints;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *renzhengConstarints;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hospitalConstarints;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *departmentConstarints;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleConstarints;



//@property (weak, nonatomic) IBOutlet UITextField *addressTextField;

@end

@implementation WMMyInformationTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupData];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    [center addObserver:self selector:@selector(receiveNotificiation:) name:@"SelectArea" object:@"area"];
    [center addObserver:self selector:@selector(addressNotificiation:) name:@"SelectAreaCode" object:@"area"];
    
    [center addObserver:self selector:@selector(receiveSchoolNotificiation:) name:@"SelectSchoolName" object:@"schoolName"];
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (void)setupUI{
    
//    [self.customTextField setValue:@10 forKey:@"limit"];
//    [self.idCardTextField setValue:@18 forKey:@"limit"];
//    self.saveBtn.backgroundColor = [UIColor colorWithHexString:@"18a2ff"];
    self.headImageView.layer.cornerRadius = 25;
    self.headImageView.clipsToBounds = YES;
    
    
}

- (void)setupData{
    
    _defaultTagsArr = [NSArray array];
    _choiceTagsArr = [NSMutableArray array];
    _saveModel = [[WMDoctorInformationCustomModel alloc]init];
    self.photos=[[NSMutableArray alloc]initWithCapacity:0];
    
    WMDoctorInfoAPIManager * apiManager = [[WMDoctorInfoAPIManager alloc]init];
    [apiManager loadDataWithParams:nil withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        _model = (WMDoctorInformationModel *)responseObject;
        LoginModel * loginModel = [WMLoginCache getMemoryLoginModel];
        loginModel.certStatus = _model.certificationStatus;
        [WMLoginCache setDiskLoginModel:loginModel];
        [WMLoginCache setMemoryLoginModel:loginModel];
        [self initData];
        [self.tableView reloadData];
    } withFailure:^(ResponseResult *errorResult) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    }else if (section == 1){
        return 3;
    }else if (section == 2){
        return 2;
    }else{
        return 2;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.00000001f;
    }else{
        return 10.0f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.000000000001f;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    return [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_width, 10)];
    return  nil;
    if (section == 2) {
        UIView * bigView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_width, 75)];
        bigView.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
        UIView * view = [[UIView alloc]init];
        if (_defaultTagsArr.count % 3 == 0) {
            view.frame = CGRectMake(0, 10, kScreen_width, 55 * (_defaultTagsArr.count/3) + 10);
        }else{
            view.frame = CGRectMake(0, 10, kScreen_width, 55 * ((_defaultTagsArr.count/3)+1) + 10);
        }
        
        view.backgroundColor = [UIColor whiteColor];
        
        //以下可删除
        UIButton * labelBtn1 = [[UIButton alloc]initWithFrame:CGRectMake(15, 15, (kScreen_width - 30-20)/3, 34)];
        [labelBtn1 setTitle:@"好玩的" forState:UIControlStateNormal];
        [self changeBtnStyle:labelBtn1 forSelect:NO];
        
        UIButton * labelBtn2 = [[UIButton alloc]initWithFrame:CGRectMake(15+((kScreen_width - 30-20)/3)+10, 15, (kScreen_width - 30-20)/3, 34)];
        [labelBtn2 setTitle:@"有趣的" forState:UIControlStateNormal];
        [self changeBtnStyle:labelBtn2 forSelect:NO];
        
        UIButton * labelBtn3 = [[UIButton alloc]initWithFrame:CGRectMake(15+((kScreen_width - 30-20)/3)*2+20, 15, (kScreen_width - 30-20)/3, 34)];
        [labelBtn3 setTitle:@"严肃的" forState:UIControlStateNormal];
        [self changeBtnStyle:labelBtn3 forSelect:NO];
        
        UIButton * labelBtn4 = [[UIButton alloc]initWithFrame:CGRectMake(15, 59, (kScreen_width - 30-20)/3, 34)];
        [labelBtn4 setTitle:@"幽默的" forState:UIControlStateNormal];
        [self changeBtnStyle:labelBtn4 forSelect:NO];
        
        UIButton * labelBtn5 = [[UIButton alloc]initWithFrame:CGRectMake(15+((kScreen_width - 30-20)/3)+10, 59, (kScreen_width - 30-20)/3, 34)];
        [labelBtn5 setTitle:@"爱装逼" forState:UIControlStateNormal];
        [self changeBtnStyle:labelBtn5 forSelect:NO];
        
        UIButton * labelBtn6 = [[UIButton alloc]initWithFrame:CGRectMake(15+((kScreen_width - 30-20)/3)*2+20, 59, (kScreen_width - 30-20)/3, 34)];
        [labelBtn6 setTitle:@"大天使" forState:UIControlStateNormal];
        [self changeBtnStyle:labelBtn6 forSelect:NO];
        
        [labelBtn1 addTarget:self action:@selector(changeBtnStyle:) forControlEvents:UIControlEventTouchUpInside];
        [labelBtn2 addTarget:self action:@selector(changeBtnStyle:) forControlEvents:UIControlEventTouchUpInside];
        [labelBtn3 addTarget:self action:@selector(changeBtnStyle:) forControlEvents:UIControlEventTouchUpInside];
        [labelBtn4 addTarget:self action:@selector(changeBtnStyle:) forControlEvents:UIControlEventTouchUpInside];
        [labelBtn5 addTarget:self action:@selector(changeBtnStyle:) forControlEvents:UIControlEventTouchUpInside];
        [labelBtn6 addTarget:self action:@selector(changeBtnStyle:) forControlEvents:UIControlEventTouchUpInside];
        
//        [view addSubview:labelBtn1];
//        [view addSubview:labelBtn2];
//        [view addSubview:labelBtn3];
//        [view addSubview:labelBtn4];
//        [view addSubview:labelBtn5];
//        [view addSubview:labelBtn6];
        [bigView addSubview:view];
        
        
        for (int i = 0; i < _defaultTagsArr.count; i++) {
            int x=((i%3)*10+(i%3)*((kScreen_width - 30-20)/3));
            int y=(i/3)*10+(i/3)*34;
            NSLog(@"X:%d   Y:%d",x,y);
            
            UIButton * labelBtn = [[UIButton alloc]initWithFrame:CGRectMake(x+15, y+15, (kScreen_width - 30-20)/3, 34)];
            [labelBtn setTitle:_defaultTagsArr[i] forState:UIControlStateNormal];
            [self changeBtnStyle:labelBtn forSelect:NO];
            for (int j = 0; j <_choiceTagsArr.count; j++) {
                if ([_choiceTagsArr[j] isEqualToString:_defaultTagsArr[i]]) {
                    [self changeBtnStyle:labelBtn forSelect:YES];
                    labelBtn.selected = YES;
                }
            }
            [labelBtn addTarget:self action:@selector(changeBtnStyle:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:labelBtn];
        }
        
        UIView * borderView = [[UIView alloc]init];
        if (_defaultTagsArr.count % 3 == 0) {
            borderView.frame = CGRectMake(0, 55 * (_defaultTagsArr.count/3) +9, kScreen_width, 0.5);
        }else{
            borderView.frame = CGRectMake(0, 55 * ((_defaultTagsArr.count/3)+1) +9, kScreen_width, 0.5);
        }
        borderView.backgroundColor = [UIColor colorWithHexString:@"dedede"];
        [view addSubview:borderView];
        
        return bigView;
    }
    return nil;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"indexPath.row==%ld",(long)indexPath.row);
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self changedImageAction];
        }else if(indexPath.row == 1){   //姓名
            WMNamePerfectViewController *namePerfectVC=[[WMNamePerfectViewController alloc] init];
            namePerfectVC.save_model = _model;
            namePerfectVC.isInfo = true;
            [self.navigationController pushViewController:namePerfectVC animated:YES];
        }else if (indexPath.row == 2){  //实名认证
            WMCertificationViewController * goVC = [WMCertificationViewController new];
            goVC.isFirstLogin = false;
            
            [self.navigationController pushViewController:goVC animated:YES];
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {       //医院
            WMHospitalChooseViewController *hospitalChooseVC=[[WMHospitalChooseViewController alloc] init];
            hospitalChooseVC.isInfo = true;
            hospitalChooseVC.save_model = _model;
            [self.navigationController pushViewController:hospitalChooseVC animated:YES];
        }else if (indexPath.row == 1){  //科室
            
            if (!stringIsEmpty(_model.hospitalName)) {
                WMSectionChooseViewController *sectionChooseVC=[[WMSectionChooseViewController alloc] init];
                sectionChooseVC.organizationCode=_model.hospitalCode;
                sectionChooseVC.hosName=_model.hospitalName;
                sectionChooseVC.isInfo = true;
                sectionChooseVC.save_model = _model;
                [self.navigationController pushViewController:sectionChooseVC animated:YES];
            }
        }else if (indexPath.row == 2){  //职称
            WMJobsChooseViewController *jobsChooseVC=[[WMJobsChooseViewController alloc] init];
            jobsChooseVC.save_model = _model;
            jobsChooseVC.isInfo = true;
            [self.navigationController pushViewController:jobsChooseVC animated:YES];
        }
    }else if(indexPath.section == 2){
        WMGetStatusLoadingAPIManager * apiManager = [WMGetStatusLoadingAPIManager new];
        [apiManager loadDataWithParams:nil withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
            WMStatusModel * statusModel = (WMStatusModel *)responseObject;
//                                    statusModel.status = @"0";  //测试
            LoginModel * loginModel = [WMLoginCache getMemoryLoginModel];
            loginModel.certStatus = statusModel.status;
            [WMLoginCache setDiskLoginModel:loginModel];
            [WMLoginCache setMemoryLoginModel:loginModel];
            if ([statusModel.status isEqualToString:@"0"] || [statusModel.status isEqualToString:@"3"]) {
                UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
                WMInfoTransitionViewController * myNameCardVC = [storyboard instantiateViewControllerWithIdentifier:@"WMInfoTransitionViewController"];
                myNameCardVC.backTitle = @"我";
                myNameCardVC.save_model = _model;
                if (indexPath.row == 0) {
                    myNameCardVC.typeStr = @"擅长";
                    
                }else{
                    myNameCardVC.typeStr = @"简介";
                }
                
                myNameCardVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:myNameCardVC animated:YES];
            }else{
                if (indexPath.row == 0) {
                    WMMultilineTextViewController * goVC = [WMMultilineTextViewController new];
                    goVC.save_model = _model;
                    goVC.typeStr = @"擅长";
                    [self.navigationController pushViewController:goVC animated:YES];
                }else if(indexPath.row == 1){
                    WMMultilineTextViewController * goVC = [WMMultilineTextViewController new];
                    goVC.typeStr = @"简介";
                    goVC.save_model = _model;
                    [self.navigationController pushViewController:goVC animated:YES];
                }
            }
        } withFailure:^(ResponseResult *errorResult) {
            
        }];
        
        
    }
    
    
    
    if (indexPath.section == 3) {
        if (indexPath.row == 0) {   //所在地区
            WMProvinceSelectViewController * goVC = [[WMProvinceSelectViewController alloc]init];
            goVC.customModel = nil;
            goVC.isArea = YES;
            goVC.saveModel = _saveModel;
            [self.navigationController pushViewController:goVC animated:YES];
        }
    }
//    if (indexPath.section == 1) {
//        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
//        WMSchoolListTableViewController * doctorVC = [storyboard instantiateViewControllerWithIdentifier:@"WMSchoolListTableViewController"];
//        [self.navigationController pushViewController:doctorVC animated:YES];
//    }
    
    
}


#pragma mark - CosomFunction

/**
 改变按钮样式

 @param btn 需要改变的按钮
 @param flag 是否显示
 */
- (void)changeBtnStyle:(UIButton *)btn forSelect:(BOOL)flag{
    btn.layer.cornerRadius = 17;
    btn.layer.borderWidth = 1;
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    if (!flag) {
        btn.layer.borderColor = [UIColor colorWithHexString:@"dedede"].CGColor;
        btn.backgroundColor = [UIColor colorWithHexString:@"f9f9f9"];
        [btn setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
        [btn setImage:nil forState:UIControlStateNormal];
    }else{
        btn.layer.borderColor = [UIColor colorWithHexString:@"18a2ff"].CGColor;
        btn.backgroundColor = [UIColor whiteColor];
        [btn setTitleColor:[UIColor colorWithHexString:@"18a2ff"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"ic_selected"] forState:UIControlStateNormal];
    }
}

- (void)changeBtnStyle:(UIButton *)btn{
    
    if (btn.selected) {
        [self changeBtnStyle:btn forSelect:NO];
        btn.selected = NO;
        
        for (int i=0; i<_choiceTagsArr.count; i++) {
            if ([_choiceTagsArr[i] isEqualToString:btn.titleLabel.text]) {
                [_choiceTagsArr removeObjectAtIndex:i];
                return;
            }
        }
        
        
    }else{
        if (_choiceTagsArr.count >= 3) {
            [WMHUDUntil showMessageToWindow:@"最多选择3个标签"];
            return;
        }
        [self changeBtnStyle:btn forSelect:YES];
        btn.selected = YES;
        
        for (int i=0; i<_choiceTagsArr.count; i++) {
            if ([_choiceTagsArr[i] isEqualToString:btn.titleLabel.text]) {
                return;
            }
        }
        [_choiceTagsArr addObject:btn.titleLabel.text];
    }
    
    NSLog(@"choiceArr:%lu",(unsigned long)_choiceTagsArr.count);
    
    NSLog(@"btnTitle:%@ and Selected:%d",btn.titleLabel.text,btn.selected);
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initData];
}

- (void)initData{
    
//    _defaultTagsArr = [_model.defaultTags componentsSeparatedByString:@","];
//    if (!stringIsEmpty(_model.choiceTags)) {
//        _choiceTagsArr = [[_model.choiceTags componentsSeparatedByString:@"|"] mutableCopy];
//    }
    
    if (stringIsEmpty(_model.area)) {   //地区
        self.areaLabel.text = @"让更多同乡找到你";
        self.areaLabel.textColor = [UIColor colorWithHexString:@"999999"];
    }else{
        self.areaLabel.text = _model.area;
        self.areaLabel.textColor = [UIColor colorWithHexString:@"333333"];
    }
    if (stringIsEmpty(_model.schoolName)) {     //学校
        self.schoolLabel.text = @"让同窗校友轻松找到你";
        self.schoolLabel.textColor = [UIColor colorWithHexString:@"999999"];
    }else{
        self.schoolLabel.text = _model.schoolName;
        self.schoolLabel.textColor = [UIColor colorWithHexString:@"333333"];
    }
    
    if (stringIsEmpty(_model.skill)) {     //擅长
        self.goodAtLabel.text = @"让患者更信任你";
        self.goodAtLabel.textColor = [UIColor colorWithHexString:@"999999"];
    }else{
        self.goodAtLabel.text = _model.skill;
        self.goodAtLabel.textColor = [UIColor colorWithHexString:@"333333"];
    }
    
    if (stringIsEmpty(_model.intro)) {     //简介
        self.profilesLabel.text = @"让患者更了解你";
        self.profilesLabel.textColor = [UIColor colorWithHexString:@"999999"];
    }else{
        self.profilesLabel.text = _model.intro;
        self.profilesLabel.textColor = [UIColor colorWithHexString:@"333333"];
    }
    
    if (stringIsEmpty(_model.hospitalName)) {     //医院
        self.hospitalLabel.text = @"请选择医院";
        self.hospitalLabel.textColor = [UIColor colorWithHexString:@"999999"];
    }else{
        self.hospitalLabel.text = _model.hospitalName;
        self.hospitalLabel.textColor = [UIColor colorWithHexString:@"333333"];
    }
    
    if (stringIsEmpty(_model.officeName)) {     //科室
        self.departmentLabel.text = @"请选择科室";
        self.departmentLabel.textColor = [UIColor colorWithHexString:@"999999"];
    }else{
        self.departmentLabel.text = _model.officeName;
        self.departmentLabel.textColor = [UIColor colorWithHexString:@"333333"];
    }
    
    if (stringIsEmpty(_model.title)) {     //职称
        self.titleLabel.text = @"请选择职称";
        self.titleLabel.textColor = [UIColor colorWithHexString:@"999999"];
    }else{
        self.titleLabel.text = _model.title;
        self.titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    }
    
    
    self.nameCell.accessoryType = UITableViewCellAccessoryNone;
    self.renzhengCell.accessoryType = UITableViewCellAccessoryNone;
    self.hospitalCell.accessoryType = UITableViewCellAccessoryNone;
    self.departmentCell.accessoryType = UITableViewCellAccessoryNone;
    self.titleCell.accessoryType = UITableViewCellAccessoryNone;
    
    self.renzhengCell.userInteractionEnabled = NO;
    self.hospitalCell.userInteractionEnabled = NO;
    self.departmentCell.userInteractionEnabled = NO;
    self.titleCell.userInteractionEnabled = NO;
    self.nameCell.userInteractionEnabled = NO;
    
    self.nameConstarints.constant = 15;
    self.hospitalConstarints.constant = 15;
    self.departmentConstarints.constant = 15;
    self.titleConstarints.constant = 15;
    self.renzhengConstarints.constant = 15;
    
    _model.certificationStatus = [WMLoginCache getMemoryLoginModel].certStatus;
//    _model.certificationStatus = @"0"; //测试
    
    //认证
    if ([_model.certificationStatus isEqualToString:@"0"] || [_model.certificationStatus isEqualToString:@"3"]) {  //未认证
        self.renzhengLabel.text = @"未认证";
        self.renzhengLabel.textColor = [UIColor colorWithHexString:@"ff1c1c"];
        self.renzhengImageView.image = nil;
        
        self.nameCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.renzhengCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.hospitalCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.departmentCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.titleCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        self.nameConstarints.constant = 0;
        self.hospitalConstarints.constant = 0;
        self.departmentConstarints.constant = 0;
        self.titleConstarints.constant = 0;
        self.renzhengConstarints.constant = 0;
        
        self.renzhengCell.userInteractionEnabled = YES;
        self.hospitalCell.userInteractionEnabled = YES;
        self.departmentCell.userInteractionEnabled = YES;
        self.titleCell.userInteractionEnabled = YES;
        self.nameCell.userInteractionEnabled = YES;
    }else if([_model.certificationStatus isEqualToString:@"1"]){    //审核中
        self.renzhengLabel.text = @"审核中";
        self.renzhengLabel.textColor = [UIColor colorWithHexString:@"ff1c1c"];
        self.renzhengImageView.image = nil;
    }else if([_model.certificationStatus isEqualToString:@"2"]){    //已认证
        self.renzhengLabel.text = @"已认证";
        self.renzhengLabel.textColor = [UIColor colorWithHexString:@"18a2ff"];
        self.renzhengImageView.image = [UIImage imageNamed:@"ic_yirenzheng"];
    }else{
        self.renzhengLabel.text = @"未认证";
        self.renzhengLabel.textColor = [UIColor colorWithHexString:@"ff1c1c"];
        self.renzhengImageView.image = nil;
    }
    
    //医生头像
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:_model.photo] placeholderImage:[UIImage imageNamed:@"ic_head_doc"]];
    
    
    
//    self.phoneLabel.text = _model.phone;
//    self.idCardTextField.text = _model.idcard;
//    self.addressTextField.text = _model.address;
    self.nameLabel.text = _model.name;
//    self.customTextField.text = _model.customTags;
    
}

- (void)receiveNotificiation:(NSNotification*)sender{
    _model.area = [sender.userInfo objectForKey:@"areaStr"];
    self.areaLabel.text = [sender.userInfo objectForKey:@"areaStr"];
    self.areaLabel.textColor = [UIColor colorWithHexString:@"333333"];
}

- (void)receiveSchoolNotificiation:(NSNotification*)sender{
    _model.schoolName = [sender.userInfo objectForKey:@"schoolName"];
    self.schoolLabel.text = [sender.userInfo objectForKey:@"schoolName"];
    self.schoolLabel.textColor = [UIColor colorWithHexString:@"333333"];
}

- (void)addressNotificiation:(NSNotification*)sender{
    if ([[sender.userInfo objectForKey:@"areaStyle"] isEqualToString:@"1"]) {
        _saveModel.provinceId = [sender.userInfo objectForKey:@"areaStrCode"];
    }else if ([[sender.userInfo objectForKey:@"areaStyle"] isEqualToString:@"2"]){
        _saveModel.cityId = [sender.userInfo objectForKey:@"areaStrCode"];
    }else if ([[sender.userInfo objectForKey:@"areaStyle"] isEqualToString:@"3"]){
        _saveModel.areaId = [sender.userInfo objectForKey:@"areaStrCode"];
    }else if ([[sender.userInfo objectForKey:@"areaStyle"] isEqualToString:@"4"]){
        _saveModel.streetId = [sender.userInfo objectForKey:@"areaStrCode"];
    }else if ([[sender.userInfo objectForKey:@"areaStyle"] isEqualToString:@"5"]){
        _saveModel.villageId = [sender.userInfo objectForKey:@"areaStrCode"];
    }
    
}


- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SelectArea" object:@"area"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SelectAreaCode" object:@"area"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SelectSchoolName" object:@"schoolName"];
    
}
//- (IBAction)saveBtn:(id)sender {
//    
//    if (![self.idCardTextField.text isEqualToString:@""] && ![NSString validateIDCardNumber:self.idCardTextField.text]) {
//        [WMHUDUntil showMessageToWindow:@"请输入正确的身份证号"];
//        return;
//    }
//    
//    _saveModel.idcard = self.idCardTextField.text;
//    _saveModel.area = [self.areaLabel.text isEqualToString:@"让更多同乡找到你"]?@"":self.areaLabel.text;
//    _saveModel.address = @"";
//    _saveModel.customTags = self.customTextField.text;
//    NSString * choiceTagsStr = @"";
//    if (_choiceTagsArr.count > 0) {
//        for (int i = 0; i < _choiceTagsArr.count; i++) {
//            choiceTagsStr = [NSString stringWithFormat:@"%@%@|",choiceTagsStr,_choiceTagsArr[i]];
//        }
//        choiceTagsStr = [choiceTagsStr substringToIndex:choiceTagsStr.length -1];
//        
//    }
//    _saveModel.tags = choiceTagsStr;
//    
//    WMDoctorInfoSaveAPIManager * apiManager = [[WMDoctorInfoSaveAPIManager alloc]init];
//    [apiManager loadDataWithParams:_saveModel.toDictionary withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
//        NSLog(@"%@",responseObject);
//        [WMHUDUntil showMessageToWindow:@"保存成功"];
//        [self.navigationController popViewControllerAnimated:YES];
//    } withFailure:^(ResponseResult *errorResult) {
//        
//    }];
//    
//}

#pragma mark--相机
- (void)changedImageAction{
    __weak typeof(self) weakself = self;
    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"照相机",@"相册", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
    [actionSheet showInView:self.view withCompletionHandler:^(NSInteger buttonIndex) {
        switch (buttonIndex) {
            case 0://照相机
            {
                NSString *mediaType = AVMediaTypeVideo;
                AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
                if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
                    [WMHUDUntil showMessage:@"相机权限受限制" toView:weakself.view];
                    return;
                }
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {//相机权限
                    if (granted) {
                        if ([weakself isCameraAvailable] && [weakself doesCameraSupportTakingPhotos])
                        {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                UIImagePickerController *controller = [[UIImagePickerController alloc] init];
                                controller.sourceType = UIImagePickerControllerSourceTypeCamera;
                                controller.allowsEditing = NO;
                                controller.delegate = weakself;
                                [weakself presentViewController:controller animated:YES completion:NULL];
                            });
                            
                        }
                    }
                }];
                
                
            }
                break;
            case 1://相册
            {
                [weakself jumpPhotoAlbum];
            }
                break;
                
            default:
                break;
        }
    }];
}

#pragma mark--跳转相册
-(void)jumpPhotoAlbum{
    dispatch_async(dispatch_get_main_queue(), ^{
        _SupportNumber=1-(int )self.photos.count;
        ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
        picker.maximumNumberOfSelection = _SupportNumber;
        picker.assetsFilter = [ALAssetsFilter allAssets];//[PHAsset]
        picker.showEmptyGroups=NO;
        picker.delegate=self;
        picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
                NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
                return duration >= 1;
            } else {
                return YES;
            }
        }];
        
        [self presentViewController:picker animated:YES completion:NULL];
  
    });
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSLog(@"拿到图片");
    [picker dismissViewControllerAnimated:YES completion:^{
        
        
        UIImage * endImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        UIImage *newImage=[self CutPictures:endImage];
        
        if (self.photos.count<2) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.photos addObject:newImage];
                self.headImageView.image = newImage;
                [self saveHeadphoto];
//                [_tableView reloadData];
                
            });
        }
        //先判断大小 如果图片大于10M
        
    }];
    
}

- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}
- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *) kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}
- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *) kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *) kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
#pragma mark - 相机相关代码
- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
    
}
#pragma mark - ZYQAssetPickerController Delegate
-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
        });
        NSMutableArray *artayCount=[NSMutableArray new];
        for (int i=0; i<assets.count; i++) {
            ALAsset *asset=assets[i];
            
            UIImage *tempImg=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
            
            UIImage *newImage=[self CutPictures: tempImg];
            
            [artayCount addObject:newImage];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
            });
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.photos addObjectsFromArray:artayCount];
            self.headImageView.image = [self.photos firstObject];
            [self saveHeadphoto];
//            if (_idcardTextField.text.length>0 && self.photos.count>0) {
//                _sureButton.backgroundColor=[UIColor colorWithHexString:@"18a2ff"];
//                [_sureButton setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
//                _sureButton.enabled=YES;
//            }
//            else{
//                _sureButton.backgroundColor=[UIColor colorWithHexString:@"cccccc"];
//                [_sureButton setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
//                _sureButton.enabled=NO;
//            }
//            [_tableView reloadData];
            
        });
        
        
    });
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}
#pragma mark--把图片转化为流
-(NSData *)imageConversionDateWithImage:(UIImage *)image{
    
    NSData * newData = UIImageJPEGRepresentation(image, 1);
    return newData;
}
-(UIImage *)CutPictures:(UIImage *)image{
    
    NSData * data = UIImageJPEGRepresentation(image, 1);
    NSLog(@"%lu==",(unsigned long)data.length);
    //先判断大小 如果图片大于10M
    if (data.length<IMAGESIZE_M) {
        //_base64Str = nil;
        //_base64Str = [data base64EncodedStringWithOptions:0];
        return image;
    }
    else if (data.length<IMAGESIZE_M*4){
        NSLog(@"大于");
        UIImage * newImage=[self imageWithImage:image minification:0.5];
        return newImage;
    }
    else if (data.length<IMAGESIZE_M*9){
        UIImage * newImage=[self imageWithImage:image minification:0.3];
        return newImage;
        
    }
    else if (data.length<IMAGESIZE_M*16){
        UIImage * newImage=[self imageWithImage:image minification:0.25];
        return newImage;
    }
    else if (data.length<IMAGESIZE_M*25){
        UIImage * newImage=[self imageWithImage:image minification:0.2];
        return newImage;
    }
    else {
        [PopUpUtil confirmWithTitle:@"温馨提示" message:@"图片过大，无法上传"  toViewController:self buttonTitles:@[@"确定"] completionBlock:^(NSUInteger buttonIndex) {
            
        }];
        
        return nil;
    }
    
}

//对图片尺寸进行压缩--图文咨询的图片压缩
- (UIImage *)imageWithImage:(UIImage*)image minification:(float )multiple{
    CGSize oldSize = CGSizeZero;
    oldSize=CGSizeMake(image.size.width*multiple, image.size.height*multiple);
    // Create a graphics image context
    UIGraphicsBeginImageContext(oldSize);
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,oldSize.width,oldSize.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    // End the context
    UIGraphicsEndImageContext();
    // Return the new image.
    return newImage;
}

#pragma mark - 接口调用

- (void)saveHeadphoto{
    WMAvatarAPIManager * apiManager = [WMAvatarAPIManager new];
    [apiManager setFormDataBlock:^(id<AFMultipartFormData> formData) {
        
        NSData *data=[self imageConversionDateWithImage:[self.photos firstObject]];
        [self.photos removeAllObjects];
        [formData appendPartWithFileData:data name:@"file" fileName:@"file.jpg" mimeType:@"image/jpeg"];
        
    }];
    
    [apiManager loadDataWithParams:nil withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        
        
        NSLog(@"responseObject=%@",responseObject);
        //更新本地缓存
        _loginModel = [WMLoginCache getMemoryLoginModel];
        NSLog(@"userId = %@", _loginModel.userId);
        NSLog(@"userId = %@", [RCIM sharedRCIM].currentUserInfo.userId);

        _loginModel.avatar = [responseObject objectForKey:@"photo"];
        [WMLoginCache setMemoryLoginModel:_loginModel];
        
        RCUserInfo *userInfo = [[RCUserInfo alloc] init];
        userInfo.name = _loginModel.name;
        userInfo.sex = _loginModel.sex;
        userInfo.portraitUri = _loginModel.avatar;
        userInfo.userId = [RCIM sharedRCIM].currentUserInfo.userId;
        
        //头像跟新后，在融云的服务器跟新头像
        [[RCIM sharedRCIM] refreshUserInfoCache:userInfo withUserId:[RCIM sharedRCIM].currentUserInfo.userId];
        [WMRCUserInfoEntitys savePatientEntity:userInfo];
        
    } withFailure:^(ResponseResult *errorResult) {
        NSLog(@"responseObject=%@",errorResult);
        
    }];
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
