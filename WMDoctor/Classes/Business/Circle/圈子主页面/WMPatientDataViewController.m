//
//  WMPatientDataViewController.m
//  WMDoctor
//
//  Created by xugq on 2017/8/10.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMPatientDataViewController.h"
#import "WMPatientDataHeaderView.h"
#import "WMPatientDataCell.h"
#import "WMPatientDataAPIManager.h"
#import "BaseWebViewController.h"
#import "BaseWebForH5ViewController.h"
#import "WMRCUserInfoEntitys+CoreDataClass.h"
#import "NSString+Additions.h"
#import "WMTagGroupViewController.h"
#import "WMPatientRemarkViewController.h"
#import "WMRCConversationViewController.h"
#import "WMRCDataManager.h"
#import "WMPatientTagViewController.h"

@interface WMPatientDataViewController ()<UITableViewDataSource, UITableViewDelegate>{
    UITableView  *_tableView;
    WMPatientDataModel *_patientData;
    NSMutableArray *_dataSource;
    NSInteger _pageNo;
}

@end

@implementation WMPatientDataViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_tableView) {
        [_tableView reloadData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = YES;
    [self setupView];
    [self setupData];
}

- (void)setupData{
    _dataSource = [NSMutableArray array];
    _pageNo = 1;
    [self loadPatientDataRequest];
}

-(void)setupView{
    self.title = @"患者资料";
    _tableView = [[UITableView alloc] init];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_width, kScreen_height-SafeAreaTopHeight - 47) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    _tableView.separatorColor = [UIColor colorWithHexString:@"E8E8E8"];
    _tableView.tableHeaderView = [self setupHeaderView];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WMPatientDataCell class]) bundle:nil] forCellReuseIdentifier:@"WMPatientDataCell"];
    __weak typeof(self) weakSelf = self;
    MJWeiMaiFooter *footer = [MJWeiMaiFooter footerWithRefreshingBlock:^{
        [weakSelf loadPatientDataRequest];
    }];
    _tableView.mj_footer = footer;
    [self.view addSubview:_tableView];
    
    UIButton *sendMsgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sendMsgBtn.frame = CGRectMake(0, kScreen_height - 47 - SafeAreaTopHeight, kScreen_width, 47);
    sendMsgBtn.backgroundColor = [UIColor colorWithHexString:@"18A2FF"];
    [sendMsgBtn setTitle:@"发消息" forState:UIControlStateNormal];
    sendMsgBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [sendMsgBtn setTintColor:[UIColor whiteColor]];
    [sendMsgBtn addTarget:self action:@selector(sendMsgBtnClickAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendMsgBtn];
}

- (void)sendMsgBtnClickAction{
    
    [[WMRCDataManager shareManager] getUserInfoWithUserId:_userId completion:^(RCUserInfo *userInfo) {
        
        WMRCConversationViewController *_conversationVC = [[WMRCConversationViewController alloc]init];
        _conversationVC.conversationType = ConversationType_PRIVATE;
        _conversationVC.targetId = userInfo.userId;
        _conversationVC.title=userInfo.name;
        _conversationVC.hidesBottomBarWhenPushed = YES;
        _conversationVC.backName=@"返回";
        [self.navigationController pushViewController:_conversationVC animated:YES];
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0 || section == 1) {
        return 1;
    } else{
        return _dataSource.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"defaultCellIdentifier"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        NSString *tagStr = [NSString getTagStrWithTagGroups:_patientData.tags];
        cell.textLabel.text = [self getCellContentWithString:tagStr andPlaceholder:@"通过标签给患者分组"];
        cell.textLabel.textColor = [self getTextColorWithText:tagStr andColorStr:@"18A2FF"];
        [self setLastVCModelTagsGroup];
        return cell;
    } else if (indexPath.section == 1){
        cell.textLabel.text = [self getCellContentWithString:_patientData.remark andPlaceholder:@"填写备注信息"];
        cell.textLabel.textColor = [self getTextColorWithText:_patientData.remark andColorStr:@"333333"];
        return cell;
    }
    WMPatientHealthModel *health = _dataSource[indexPath.row];
    WMPatientDataCell * patientDataCell = [tableView dequeueReusableCellWithIdentifier:@"WMPatientDataCell" forIndexPath:indexPath];
    patientDataCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [patientDataCell setValueWithPatientHealthModel:health];
    return patientDataCell;
}

- (void)setLastVCModelTagsGroup{
    if (self.patientReportedModel) {
        self.patientReportedModel.tagGroups = _patientData.tags;
    }
    if (self.totalPatientModel) {
        self.totalPatientModel.tagGroups = _patientData.tags;
    }
    if (self.vipPatientModel) {
        self.vipPatientModel.tagGroups = _patientData.tags;
    }
    if (self.tagPatientModel) {
        self.tagPatientModel.tagGroups = _patientData.tags;
    }
}

- (UIColor *)getTextColorWithText:(NSString *)text andColorStr:(NSString *)colorStr{
    if (stringIsEmpty(text)) {
        return [UIColor colorWithHexString:@"CCCCCC"];
    } else{
        return [UIColor colorWithHexString:colorStr];
    }
}

- (NSString *)getCellContentWithString:(NSString *)content andPlaceholder:(NSString *)placeholder{
    if (stringIsEmpty(content)) {
        return placeholder;
    } else{
        return content;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 || indexPath.section == 1) {
        return 44;
    }
    return 164;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 43;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_dataSource.count > 0) {
        return 3;
    }
    return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *sectionHeaderView = [[UIView alloc] init];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, 43)];
    if (section == 0) {
        titleLabel.text = @"标签";
    } else if (section == 1){
        titleLabel.text = @"备注";
    } else if (section == 2){
        titleLabel.text = @"病历资料";
    }
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = [UIColor colorWithHexString:@"999999"];
    [sectionHeaderView addSubview:titleLabel];
    return sectionHeaderView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
        WMPatientTagViewController *patientTagViewController = [[WMPatientTagViewController alloc] init];
        patientTagViewController.patientData = _patientData;
        patientTagViewController.weimaihao = self.userId;
        [self.navigationController pushViewController:patientTagViewController animated:YES];
    } else if (indexPath.section == 1){
        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Circle" bundle:nil];
        WMPatientRemarkViewController * remarkViewController = (WMPatientRemarkViewController *)[storyboard instantiateViewControllerWithIdentifier:@"WMPatientRemarkViewController"];
        remarkViewController.weimaihao = self.userId;
        remarkViewController.backTitle = @"取消";
        remarkViewController.patientData = _patientData;
        remarkViewController.textView.text = _patientData.remark;
        remarkViewController.remark = _patientData.remark;
        [self.navigationController pushViewController:remarkViewController animated:YES];
    } else{
        WMPatientHealthModel *health = _dataSource[indexPath.row];
        BaseWebForH5ViewController * webVC = [[BaseWebForH5ViewController alloc] init];
        webVC.urlString = [health.jiuzhenmxlb stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        //前往用户协议界面
        [self.navigationController pushViewController:webVC animated:YES];
    }
}

- (UIView *)setupHeaderView{
    WMPatientDataHeaderView *headerView = [[WMPatientDataHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreen_width, 90)];
    if (_patientData != nil) {
        [headerView.headerImageView sd_setImageWithURL:[NSURL URLWithString:_patientData.url] placeholderImage:[UIImage imageNamed:@"doctor_man"] options:SDWebImageAllowInvalidSSLCertificates];
        headerView.name.text = _patientData.xingming;
        headerView.department.text = [NSString stringWithFormat:@"%@ %@岁", _patientData.sex, _patientData.age];
    }
    return headerView;
}

- (void)loadPatientDataRequest{
    WMPatientDataAPIManager *patientDataAPIManager = [[WMPatientDataAPIManager alloc] init];
    NSString *tempGroupId = @"";
    if (self.groupId != nil && self.groupId.length > 0) {
        tempGroupId = self.groupId;
    }
    NSDictionary *param = @{
                            @"pageNo" : [NSString stringWithFormat:@"%ld", _pageNo],
                            @"pageSize" : @"10",
                            @"weimaihao" : self.userId,
                            @"groupId" : tempGroupId
                            };
    
    [patientDataAPIManager loadDataWithParams:param withSuccess:^(NSURLSessionDataTask *task, id responseObject) {

        _patientData = [[WMPatientDataModel alloc] initWithDictionary:responseObject error:nil];
        [_dataSource addObjectsFromArray:_patientData.health];
        _tableView.tableHeaderView = [self setupHeaderView];
        [_tableView reloadData];
        if (_dataSource.count == 0) {
            [_tableView showFooterBackgroundView:@"暂无病历资料" type:BackgroundTypeNORecord];
        }
        [_tableView.mj_footer endRefreshing];
        if (_patientData.health.count < 10) {
            if (_pageNo == 1) {
                _tableView.mj_footer.hidden = YES;
            }
            [_tableView.mj_footer endRefreshingWithNoMoreData];
        }
        _pageNo ++;
    } withFailure:^(ResponseResult *errorResult) {
        [_tableView.mj_footer endRefreshing];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
