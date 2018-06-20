//
//  WMCricleMainViewController.m
//  WMDoctor
//
//  Created by 茭白 on 2016/12/14.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import "WMCricleMainViewController.h"
#import "WMPatientReportedViewController.h"
#import "WMCricleMainAPIManager.h"
#import "WMCricleMainCell.h"
#import "WMCricleMainParamModel.h"
#import "WMAllPatientViewController.h"
#import "WMVIPPatientViewController.h"
#import "WMCricleFriendViewController.h"
#import "WMCricleHomeAPIManager.h"
#import "WMGroupRCDataManager.h"
#import "RCIMGroupViewController.h"
#import "WMSearchPatientViewController.h"
#import "UISearchBar+WMLeftPlaceholder.h"
#import "WMTagPatientViewController.h"

@interface WMCricleMainViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate, UISearchBarDelegate>
{
    UITableView  *_tableView;
    NSDictionary *_pageDic;
    LoginModel * _loginModel;
    WMCricleHomePageModel *_cricleHomePageModel;
}
@property(nonatomic, strong) NSMutableArray *dataSource;//数据源
@property(nonatomic, strong) UISearchBar *searchBar;


@end

@implementation WMCricleMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupData];
    [self setupView];
    self.view.backgroundColor=[UIColor colorWithHexString:@"f4f4f4"];
    // Do any additional setup after loading the view.
}

- (UIView *)setHeaderView{
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_width, 52)];
    bottomView.backgroundColor = [UIColor whiteColor];
    
    //搜索框
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(15, 10, kScreen_width - 30, 32)];
    _searchBar.delegate= self;
    _searchBar.barTintColor = [UIColor whiteColor];//外色
    [_searchBar setLeftPlaceholder:@"输入关键词搜索患者"];
    _searchBar.showsCancelButton = NO;
    _searchBar.barStyle = UIBarStyleDefault;
    _searchBar.layer.cornerRadius = _searchBar.height/2.0;
    _searchBar.layer.masksToBounds = YES;
    [_searchBar setImage:[UIImage imageNamed:@"ic_sousuo"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateSelected|UIControlStateNormal];
    [_searchBar.layer setBorderWidth:0.8];
    [_searchBar.layer setBorderColor:[UIColor colorWithHexString:@"dedede"].CGColor];
    _searchBar.barTintColor = [UIColor colorWithHexString:@"F3F5F9"];
    UITextField *searchField = [_searchBar valueForKey:@"_searchField"];
    searchField.backgroundColor = [UIColor colorWithHexString:@"F3F5F9"];
    [bottomView addSubview:_searchBar];
    return bottomView;
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    WMSearchPatientViewController *searchPatientVC = [[WMSearchPatientViewController alloc] init];
    searchPatientVC.backTitle = @"";
    [self.navigationController pushViewController:searchPatientVC animated:YES];
    return NO;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJRefreshFastAnimationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView.mj_header beginRefreshing];
    });
}

-(void)setupView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, kScreen_height - SafeAreaTopHeight) style:UITableViewStyleGrouped];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=[UIColor colorWithHexString:@"f4f4f4"];
    _tableView.separatorColor=[UIColor colorWithHexString:@"E8E8E8"];
    _tableView.tableFooterView=[UIView new];
    _tableView.tableHeaderView = [self setHeaderView];
    
    _loginModel = [WMLoginCache getMemoryLoginModel];
    if (_loginModel.userType) {        //护士圈子暂停使用
        UIView * backView = [[UIView alloc]initWithFrame:_tableView.bounds];
        
        UIImageView * theImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 40, 160, 160)];
        theImage.center = CGPointMake(kScreen_width/2, 40+80+64);
        theImage.image = [UIImage imageNamed:@"Circle_default"];
        
        UILabel * theLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreen_width, 20)];
        theLabel.center = CGPointMake(kScreen_width/2, 230+64);
        theLabel.textAlignment = NSTextAlignmentCenter;
        theLabel.text = @"尽请期待";
        theLabel.font = [UIFont systemFontOfSize:14];
        theLabel.textColor = [UIColor colorWithHexString:@"999999"];
        [backView addSubview:theImage];
        [backView addSubview:theLabel];
        _tableView.backgroundView = backView;
        [self.view addSubview:_tableView];
        return;
    }
    
    
    _tableView.mj_header = [MJWeiMaiHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadCricleHomeRequest)];
    [_tableView.mj_header beginRefreshing];
    [self.view addSubview:_tableView];
}
- (void)setupData{
    self.dataSource=[[NSMutableArray alloc]initWithCapacity:0];
}

- (void)loadCricleHomeRequest{
    WMCricleHomeAPIManager *cricleHomeAPIManager = [[WMCricleHomeAPIManager alloc] init];
    NSDictionary *param = @{};
    [cricleHomeAPIManager loadDataWithParams:param withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        [self.dataSource removeAllObjects];
        _cricleHomePageModel = (WMCricleHomePageModel *)responseObject;
        if (_cricleHomePageModel.patiens.count > 0) {
            [self.dataSource addObject:_cricleHomePageModel.patiens];
        }
        if (_cricleHomePageModel.tagGroups.count > 0) {
            [self.dataSource addObject:_cricleHomePageModel.tagGroups];
        }
        if (self.dataSource.count==0) {
            [_tableView showBackgroundView:@"暂无数据" type:BackgroundTypeEmpty];
        } else{
            [_tableView removeBackgroundViewForNeedToChangeSeparator:NO];
        }
        
        if ([_tableView.mj_header isRefreshing]) {
            [_tableView.mj_header endRefreshing];
        }
        [_tableView reloadData];
    } withFailure:^(ResponseResult *errorResult) {
        NSLog(@"圈子主页error = %@", errorResult);
        if (self.dataSource.count<=0) {
            [_tableView showBackgroundView:@"暂无数据" type:BackgroundTypeEmpty];
        }
        if ([_tableView.mj_header isRefreshing]) {
            
            [_tableView.mj_header endRefreshing];
        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}

#pragma mark--UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSArray *tempArr = self.dataSource[section];
    return tempArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *tempArr = self.dataSource[indexPath.section];
    WMCricleMainCell *cricleMainCell=(WMCricleMainCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    if (!cricleMainCell) {
        cricleMainCell = [[[NSBundle mainBundle]loadNibNamed:@"WMCricleMainCell" owner:self options:Nil] lastObject];
    }
    [cricleMainCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    WMCricleGroupModel *cricleGroupModel = tempArr[indexPath.row];
    cricleMainCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [cricleMainCell setupViewWithModel:cricleGroupModel];
    if ([cricleGroupModel.groupType intValue] == 5) {
        cricleMainCell.accessoryType = UITableViewCellAccessoryNone;
    } else{
        cricleMainCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cricleMainCell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *tempArr = self.dataSource[indexPath.section];
    WMCricleGroupModel *circleGroupModel=tempArr[indexPath.row];

    WMCricleType cricleType;
    cricleType=[circleGroupModel.groupType intValue];
    
    switch (cricleType) {
        case PatientReportedCricleType:{ //暂时表示患者报到
            WMPatientReportedViewController *patientReportedVC=[[WMPatientReportedViewController alloc]init];
            patientReportedVC.titleStr=circleGroupModel.groupName;
            patientReportedVC.backTitle = @"返回";
            patientReportedVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:patientReportedVC animated:YES];
        }
            
            break;
        case DoctorCricleType:{ //暂时表示所有患者
                WMAllPatientViewController *patientReportedVC=[[WMAllPatientViewController alloc]init];
            patientReportedVC.titleStr=circleGroupModel.groupName;
            patientReportedVC.backTitle = @"返回";
            patientReportedVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:patientReportedVC animated:YES];
        }
            
            break;
        case VIPPatientCricleType:{ //暂时表示VIP患者
            
            WMVIPPatientViewController *patientReportedVC=[[WMVIPPatientViewController alloc]init];
            patientReportedVC.titleStr=circleGroupModel.groupName;
            patientReportedVC.backTitle = @"返回";
            patientReportedVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:patientReportedVC animated:YES];
             
        }
            
            break;
            
        case VIPFriendCricleType:{ //暂时表示VIP患者
        }
            
            break;
            
        case GroupType:{ //群聊
            //群聊跳转
            [[WMGroupRCDataManager shareManager]getGroupInfoWithGroupId:circleGroupModel.groupId completion:^(RCDGroupInfo *groupInfo) {
                RCIMGroupViewController *_conversationVC = [[RCIMGroupViewController alloc]init];
                _conversationVC.conversationType = ConversationType_GROUP;
                _conversationVC.targetId = circleGroupModel.groupId;
                _conversationVC.groupName = circleGroupModel.groupName;
                _conversationVC.backName=@"微脉";
                _conversationVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:_conversationVC animated:YES];
            }];
        }
            
            break;
            
        case TagGroupType:{
            //标签分组
            WMTagPatientViewController *tagPatientVC = [[WMTagPatientViewController alloc] init];
            tagPatientVC.cricleGroupModel = circleGroupModel;
            tagPatientVC.backTitle = @"返回";
            tagPatientVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:tagPatientVC animated:YES];
        }
            break;
            
        default: { //默认升级提醒
            
            [PopUpUtil confirmWithTitle:NSLocalizedString(@"kText_warm_prompt", nil) message:NSLocalizedString(@"kText_message_version_upgrade", nil) toViewController:nil buttonTitles:@[NSLocalizedString(@"kText_temporarily_not_update", nil),NSLocalizedString(@"kText_upgrade_immediately", nil)] completionBlock:^(NSUInteger buttonIndex) {
                if (buttonIndex==1) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:APPSTORE_WMDOCTOR_URL]];
                }

            }];
        }
        break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.dataSource.count == 2) {
        return 44;
    }
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, 56, 20)];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = [UIColor colorWithHexString:@"999999"];
    NSArray *tempArr = self.dataSource[section];
    if (tempArr == _cricleHomePageModel.patiens){
        titleLabel.text = @"    默认分组";
        return titleLabel;
    } else if (tempArr == _cricleHomePageModel.tagGroups){
        titleLabel.text = @"    标签分组";
        return titleLabel;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
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
