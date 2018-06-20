//
//  WMMedicalCircleViewController.m
//  WMDoctor
//
//  Created by xugq on 2018/5/18.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "WMMedicalCircleViewController.h"
#import "WMCricleMainCell.h"
#import "WMCricleGroupModel.h"
#import "WMMedicalCircleAPIManager.h"
#import "RCIMGroupViewController.h"
#import "WMGroupRCDataManager.h"
#import "WMMyServiceSetViewController.h"

@interface WMMedicalCircleViewController ()<UITableViewDataSource, UITableViewDelegate>{
    UITableView  *_tableView;
    WMMedicalCircleModel *_cricleHomePageModel;
}

@end

@implementation WMMedicalCircleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
    [self navRightBtn];
    if ([self.openService integerValue] == 1) {
        //已开通
        [self loadData];
    } else{
        [_tableView showListEmptyView:@"queshengye" title:@"暂无群聊" buttonTitle:@"查看医聊圈操作指南" completion:^(UIButton *button) {
            WMBaseWKWebController * webVC = [[WMBaseWKWebController alloc]init];
            webVC.urlString = H5_URL_DOCTORFINGERPOST;
            webVC.backTitle = @"";
            webVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:webVC animated:YES];
        }];
    }
    
}

- (void)navRightBtn{
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 70, 30);
    if ([self.openService integerValue] == 1) {
        [rightBtn setTitle:@"服务设置" forState:UIControlStateNormal];
    } else{
        [rightBtn setTitle:@"开启服务" forState:UIControlStateNormal];
    }
    LoginModel *loginModel = [WMLoginCache getMemoryLoginModel];
    if (loginModel.userType) {
        rightBtn.hidden = YES;
    }
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(navRightBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
}


//服务设置
- (void)navRightBtnClick{
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
    WMMyServiceSetViewController * doctorVC = [storyboard instantiateViewControllerWithIdentifier:@"WMMyServiceSetViewController"];
    doctorVC.hidesBottomBarWhenPushed = YES;
    doctorVC.backTitle = @"";
    doctorVC.inquiryType = @"4";
    [self.navigationController pushViewController:doctorVC animated:YES];
}

-(void)setupView{
    self.title = @"医聊圈";
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, kScreen_height - SafeAreaTopHeight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    _tableView.separatorColor = [UIColor colorWithHexString:@"E8E8E8"];
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _cricleHomePageModel.groups.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WMCricleMainCell *cricleMainCell = (WMCricleMainCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (!cricleMainCell) {
        cricleMainCell = [[[NSBundle mainBundle]loadNibNamed:@"WMCricleMainCell" owner:self options:Nil] lastObject];
    }
    [cricleMainCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    WMCricleGroupModel *cricleGroupModel = _cricleHomePageModel.groups[indexPath.row];
    cricleMainCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [cricleMainCell medicalCircleVCSetupValueWithModel:cricleGroupModel];
    cricleMainCell.accessoryType = UITableViewCellAccessoryNone;//UITableViewCellAccessoryDisclosureIndicator;
    return cricleMainCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WMCricleGroupModel *circleGroupModel = _cricleHomePageModel.groups[indexPath.row];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (void)loadData{
    WMMedicalCircleAPIManager *medicalCircleAPIManager = [[WMMedicalCircleAPIManager alloc] init];
    [medicalCircleAPIManager loadDataWithParams:nil withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"医聊圈：%@", responseObject);
        _cricleHomePageModel = (WMMedicalCircleModel *)responseObject;
        [_tableView reloadData];
    } withFailure:^(ResponseResult *errorResult) {
        NSLog(@"error : %@", errorResult);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
