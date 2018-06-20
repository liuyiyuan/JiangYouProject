//
//  WMDoctorIndexViewController.m
//  WMDoctor
//
//  Created by JacksonMichael on 2018/1/29.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "WMDoctorIndexViewController.h"

#import "SDCycleScrollView.h"
#import "WMIndexDataAPIManager.h"
#import "WMIndexDataModel.h"
#import "WMDynamicModuleView.h"
#import "WMQuestionsAPIManager.h"
#import "WMQuestionDetailViewController.h"
#import "WMIndexQuestionsCell.h"
#import "WMQuestionStateAPIManager.h"
#import "WMQuestionsViewController.h"
#import "WMSixFunctionView.h"
#import "WMPatientReportedViewController.h"
#import "WMAllPatientViewController.h"
#import "WMcounselingVC.h"
#import "WMDocChatCircleVC.h"
#import "WMGetStatusAPIManager.h"
#import "WMMyNameCardViewController.h"
#import "WMStatusModel.h"
#import "WMMyNameStatusCardViewController.h"
#import "WMCricleMainViewController.h"
#import "WMMessageNewDetailViewController.h"
#import "WMCertificationStatusAPIManager.h"
#import "WMCertificationViewController.h"
#import "WMOutLinkWebViewController.h"
#import "WMMyMicroBeanViewController.h"
#import "WMDaySignAPIManager.h" //签到
#import "WMTabBarController.h"
#import "WMDoctorCertificationResultView.h"
#import "WMNewGuideViewController.h"
#import "WMNavgationController.h"
#import "AppConfig.h"

#import "WMTagGroupViewController.h"
#import "WMMedicalCircleViewController.h"

@interface WMDoctorIndexViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,WMDynamicModuleViewDelegate,WMSixFunctionViewDelegate, WMDoctorCerResultViewDelegate>
{
    NSInteger _pageNo;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic, strong) SDCycleScrollView *cycleScrollView;        //轮播
@property(nonatomic, strong) WMSixFunctionView *sixModeulView;
@property(nonatomic, strong) WMDynamicModuleView *dynamicModulView;
@property(nonatomic, strong) UIView *bottomLastView;

@property (nonatomic, strong) NSMutableArray *bannerArray;
@property (nonatomic, strong) NSMutableArray *sixArray;
@property (nonatomic, strong) NSMutableArray *yingyongArray;
@property(nonatomic, strong)NSMutableArray *dataSource;     //一问一答数据源
@property (nonatomic, strong) LoginModel *loginModel;

@end

@implementation WMDoctorIndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self setupUI];
    //[self loadIndexData];
    [self setTabUnread];
    [self CertificationResultView];
    self.title = @"工作台";
    // Do any additional setup after loading the view.
    
    //注册刷新通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initUI) name:@"InfoNotification" object:nil];
    //每日签到
    [self DaySign];
    
    
//    UIBarButtonItem * rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"测试" style:UIBarButtonItemStyleDone target:self action:@selector(gotest)];
//    self.navigationItem.rightBarButtonItem = rightBtn;
    
    
}


- (void)gotest{
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Circle" bundle:nil];
    WMTagGroupViewController * questionDetailViewController = (WMTagGroupViewController *)[storyboard instantiateViewControllerWithIdentifier:@"WMTagGroupViewController"];
//    WMTagGroupViewController * testVC = [WMTagGroupViewController new];
    [self.navigationController pushViewController:questionDetailViewController animated:YES];
}

- (void)setupUI{
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    self.tableView.estimatedRowHeight = 0;
//    self.tableView.estimatedSectionHeaderHeight = 42;
//    self.tableView.estimatedSectionFooterHeight = 12;
//    self.tableView.frame = CGRectMake(0, kSTATUSNAVHEIGHT, kScreen_width, kScreen_height - kSTATUSNAVHEIGHT);
    //刷新
    _tableView.mj_header = [MJWeiMaiHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshData)];
    [_tableView.mj_header beginRefreshing];
    __weak typeof(self) weakSelf = self;
    MJWeiMaiFooter *footer = [MJWeiMaiFooter footerWithRefreshingBlock:^{
        [weakSelf loadQuestionsData];
    }];
    _tableView.mj_footer = footer;
    
    self.bottomLastView = [self bottomView];
}


- (void)initUI{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.tableView.tableFooterView = nil;
        self.tableView.tableHeaderView = [self makeTableViewHeader];
//        MJWeiMaiFooter *footer = [MJWeiMaiFooter footerWithRefreshingBlock:^{
//            [weakSelf loadQuestionsData];
//        }];
//        _tableView.mj_footer = footer;
        //[self.tableView reloadData];
    });
    
    
}

- (void)initData{
    self.loginModel = [WMLoginCache getMemoryLoginModel];
    self.bannerArray = [NSMutableArray array];
    self.sixArray = [NSMutableArray array];
    self.yingyongArray = [NSMutableArray array];
    _pageNo = 1;
    self.dataSource = [NSMutableArray new];
    
}

- (UIView *)makeTableViewHeader{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectZero];
    headerView.backgroundColor = [UIColor colorWithHexString:@"f3f5f9"];
    
    CGFloat headerHeight = 0.01;
    
    if (self.bannerArray.count > 0) {
        
        NSMutableArray *imageUrlArr = [NSMutableArray array];
        
        for (NSInteger i = 0; i<self.bannerArray.count; i++) {
            WMIndexBanners *activityModel = self.bannerArray[i];
            [imageUrlArr addObject:strOrEmpty(activityModel.img)];
//            [titleArr addObject:[NSString stringWithFormat:@"banner_home_a%02ld",i+1]];
        }
        
        
        self.cycleScrollView.imageURLStringsGroup = imageUrlArr;
//        self.cycleScrollView.titlesGroup = [NSArray arrayWithArray:titleArr];
        self.cycleScrollView.frame = CGRectMake(0, headerHeight, kScreen_width,kScreen_width*110.0/375.0);
        self.cycleScrollView.delegate = self;
        [headerView addSubview:self.cycleScrollView];
        
        headerHeight += kScreen_width*110.0/375.0;
    }
    
    //six
    if (self.sixArray.count > 0) {
        
        self.sixModeulView.frame = CGRectMake(0, headerHeight, kScreen_width, 184);
        [self.sixModeulView sixViewMakeViewWithArray:self.sixArray];
        
        [headerView addSubview:self.sixModeulView];
        headerHeight += 184 +10;
    }
    
    //动态
    if (_yingyongArray.count > 0) {
        [self.dynamicModulView moduleViewMakeViewWithArray:_yingyongArray];
        self.dynamicModulView.frame = CGRectMake(0, headerHeight, kScreen_width,  self.dynamicModulView.viewHeight);
        [headerView addSubview:self.dynamicModulView];
        
        headerHeight += (CGFloat)self.dynamicModulView.viewHeight;
    }
    
    headerView.frame = CGRectMake(0, 0, kScreen_width,headerHeight);
    
    return headerView;
}


- (void)headerRefreshData{
    NSLog(@"headerRefreshData= thread=%d",[[NSThread currentThread] isMainThread]);
    
    _pageNo = 1;
    //[self initData];
    [self loadQuestionsData];
    [self loadIndexData];

}


- (void)loadIndexData{
    
    WMIndexDataAPIManager * apiManager = [WMIndexDataAPIManager new];
    [apiManager loadDataWithParams:nil withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"response:%@",responseObject);
        WMIndexDataModel * indexModel = (WMIndexDataModel *)responseObject;

        self.bannerArray = [indexModel.banners mutableCopy];

        self.sixArray = [indexModel.functionEntries mutableCopy];

        [self.yingyongArray removeAllObjects];
        for (int i = 0; i<indexModel.gridEntries.count; i++) {
            WMGridEntries * theModel = indexModel.gridEntries[i];
            HomeAppModel * appModel = [HomeAppModel new];
            appModel.name = theModel.name;
            appModel.image = theModel.icon;
            appModel.skipType = theModel.linkType;
            appModel.skipId = theModel.code;
            appModel.displayArea = theModel.iconPosition;
            appModel.isEnable = theModel.openFlag;
            appModel.isHot = theModel.hot;
            appModel.skipParameters = theModel.linkParam;
            [self.yingyongArray addObject:appModel];
        }
        
        NSLog(@"indexModel:%@",indexModel);
        [self initUI];
        
    } withFailure:^(ResponseResult *errorResult) {
        
    }];
    
}


- (void)loadQuestionsData{
    WMQuestionsAPIManager *questionsAPIManager = [[WMQuestionsAPIManager alloc] init];
    NSDictionary *param = @{
                            @"pageNum" : [NSString stringWithFormat:@"%ld", (long)_pageNo],
                            @"pageSize" : @"10"
                            };
    [questionsAPIManager loadDataWithParams:param withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"一问医答数据 = %@", responseObject);
        if (_pageNo == 1) {
            [self.dataSource removeAllObjects];
        }
        _pageNo ++;
        NSLog(@"pageNo : %ld", (long)_pageNo);
        
        NSArray *list = [responseObject objectForKey:@"doctorAnswerVos"];
        for (NSDictionary *dic in list) {
            WMQuestionModel *question = [[WMQuestionModel alloc] initWithDictionary:dic error:nil];
            [self.dataSource addObject:question];
        }
        
        self.tableView.tableFooterView = nil;
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if ([list count] < 10) {
//            self.tableView.mj_footer = nil;
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
//            self.tableView.tableFooterView = self.bottomLastView;
        }
        if ([self.dataSource count] == 0) {
//            [self.tableView showListEmptyView:@"noQuestions" title:@"暂无提问"];
        }
        
        
    } withFailure:^(ResponseResult *errorResult) {
        NSLog(@"一问医答error = %@", errorResult);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"666的总数：%ld",self.dataSource.count);
    return self.dataSource.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WMQuestionModel *question = [self.dataSource objectAtIndex:indexPath.row];
    WMIndexQuestionsCell * cell = [tableView dequeueReusableCellWithIdentifier:@"WMIndexQuestionsCell" forIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.answer.tag = indexPath.row;
    [cell.answer addTarget:self action:@selector(answerBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell setValueWithIndexQuestion:question];
    return cell;
    
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WMQuestionModel *question = [self.dataSource objectAtIndex:indexPath.row];
    NSLog(@"question : %@", question);
    WMQuestionStateAPIManager *questionStateAPIManager = [[WMQuestionStateAPIManager alloc] init];
    NSDictionary *param = @{
                            @"questionId" : question.questionId
                            };
    [questionStateAPIManager loadDataWithParams:param withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        
        if (responseObject != nil) {
            question.state = [responseObject objectForKey:@"state"];
        }
        if ([question.state intValue] == 2) {
            UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Circle" bundle:nil];
            WMQuestionDetailViewController * questionDetailViewController = (WMQuestionDetailViewController *)[storyboard instantiateViewControllerWithIdentifier:@"WMQuestionDetailViewController"];
            questionDetailViewController.question = question;
            questionDetailViewController.hidesBottomBarWhenPushed = YES;
            questionDetailViewController.backTitle = @"返回";
            [self.navigationController pushViewController:questionDetailViewController animated:YES];
            //被抢答
//            [WMHUDUntil showMessage:@"该问题已被其他医生抢答" toView:self.view];
        } else if ([question.state intValue] == 4){
            //已关闭
            [WMHUDUntil showMessage:@"该问题已过有效期，无法回答" toView:self.view];
        } else if ([question.state intValue] == 5){
            //抢答中
            [WMHUDUntil showMessage:@"该提问正在被其他医生抢答" toView:self.view];
        } else{
            UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Circle" bundle:nil];
            WMQuestionDetailViewController * questionDetailViewController = (WMQuestionDetailViewController *)[storyboard instantiateViewControllerWithIdentifier:@"WMQuestionDetailViewController"];
            questionDetailViewController.question = question;
            questionDetailViewController.hidesBottomBarWhenPushed = YES;
            questionDetailViewController.backTitle = @"返回";
            [self.navigationController pushViewController:questionDetailViewController animated:YES];
        }
        WMIndexQuestionsCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell setValueWithIndexQuestion:question];
    } withFailure:^(ResponseResult *errorResult) {
        NSLog(@"问题状态error ： %@", errorResult);
    }];
}

#pragma mark - UItableViewDelegate
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return UITableViewAutomaticDimension;
//}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 157;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section{
    return 42;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WMQuestionModel *question = [self.dataSource objectAtIndex:indexPath.row];
    
    return (117+[CommonUtil heightForLabelWithText:question.content width:kScreen_width-60 font:[UIFont systemFontOfSize:16]])>157?157:117+[CommonUtil heightForLabelWithText:question.content width:kScreen_width-60 font:[UIFont systemFontOfSize:16]];
    
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_width, 42)];
    headView.backgroundColor = [UIColor colorWithHexString:@"f3f5f9"];
    UIImageView * image = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 71, 17)];
    image.image = [UIImage imageNamed:@"img_shouye_yiwenyida"];
    //更多
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(kScreen_width - 50 -5, 15, 50, 20)];
    label.text = @"更多";
    label.textColor = [UIColor colorWithHexString:@"999999"];
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentLeft;
    label.userInteractionEnabled = YES;
    
    UIImageView * imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_>>>"]];
    imageView.frame = CGRectMake(kScreen_width-15-12, 19, 12, 12);
    
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goMore:)];
    [tapGesture setNumberOfTapsRequired:1];
    [label addGestureRecognizer:tapGesture];
    
    [headView addSubview:imageView];
    [headView addSubview:label];
    [headView addSubview:image];
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 42;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc]init];
//    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_width, 12)];
//    UIImageView * imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_bottom_tishi"]];
//    imageView.frame = CGRectMake(0, 0, 224, 12);
//    imageView.center = CGPointMake(kScreen_width/2, 30/2);
//    [view addSubview:imageView];
//    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00001f;
}

#pragma mark - cycleScrollView

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    //轮播活动跳转
//    HomeActivityModel *activityModel = _activityArray[index];
//    [WMJumpControl showBannerDetailWithModel:activityModel withViewController:self];
    
    WMIndexBanners *activityModel = self.bannerArray[index];
    
    WMOutLinkWebViewController * outLinkVC = [[WMOutLinkWebViewController alloc]init];
    
    
    outLinkVC.urlString = activityModel.url;
//    [WMHUDUntil showMessageToWindow: outLinkVC.urlString];
    outLinkVC.hidesBottomBarWhenPushed = YES;
    outLinkVC.webTitle = activityModel.subject;
    [self.navigationController pushViewController:outLinkVC animated:YES];
    return;
    
}


- (SDCycleScrollView *)cycleScrollView{
    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero delegate:self placeholderImage:[UIImage imageNamed:@"img_default"]];
        
        _cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
        _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        _cycleScrollView.autoScrollTimeInterval = 5;
        _cycleScrollView.titleLabelTextColor = [UIColor clearColor];
        _cycleScrollView.titleLabelBackgroundColor = [UIColor clearColor];
        _cycleScrollView.currentPageDotImage = [UIImage imageNamed:@"ic_banner_point_select"];
        _cycleScrollView.pageDotImage = [UIImage imageNamed:@"ic_banner_point_unselect"];
    }
    return _cycleScrollView;
}

- (WMDynamicModuleView *)dynamicModulView{
    if (!_dynamicModulView) {
        _dynamicModulView = [[WMDynamicModuleView alloc] initWithFrame:CGRectMake(0, 0, kScreen_width, 9/16.0*kScreen_width)];
        _dynamicModulView.delegate = self;
    }
    return _dynamicModulView;
}

- (WMSixFunctionView *)sixModeulView{
    if (!_sixModeulView) {
        _sixModeulView = [[WMSixFunctionView alloc]initWithFrame:CGRectMake(0, 0, kScreen_width, 184)];
        _sixModeulView.delegate = self;
    }
    return _sixModeulView;
}

- (UIView *)bottomView{
    UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_width, 30)];
    UIImageView * imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_bottom_tishi"]];
    imageView.frame = CGRectMake(0, 0, 224, 12);
    imageView.center = CGPointMake(kScreen_width/2, 12/2);
    [bottomView addSubview:imageView];
    return bottomView;
}

- (void)clickSixEntran:(WMFunctionEntries *)model{
    
    LoginModel * loginModel = [WMLoginCache getMemoryLoginModel];
    
    if ([model.linkType isEqualToString:@"2"]) {    //链接跳转
        WMOutLinkWebViewController * outLinkVC = [[WMOutLinkWebViewController alloc]init];
        outLinkVC.urlString = model.linkParam;
        outLinkVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:outLinkVC animated:YES];
        return;
    }
    
    
    WMCertificationStatusAPIManager * api = [WMCertificationStatusAPIManager new];
    [api loadDataWithParams:@{@"code":model.code} withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSString * openFlag = [NSString stringWithFormat:@"%@",responseObject[@"openFlag"]];
        if ([openFlag isEqualToString:@"1"]) {
            
            if (loginModel.userType) {      //护士
                if ([model.code isEqualToString:@"1004"]) {     //患者报到
                    [WMHUDUntil showMessageToWindow:@"该功能仅对医生开放"];
                    return;
                }else if ([model.code isEqualToString:@"1001"]){        //一问医答
                    [WMHUDUntil showMessageToWindow:@"该功能仅对医生开放"];
//                    WMQuestionsViewController * questionVC = [[WMQuestionsViewController alloc]init];
//                    [self.navigationController pushViewController:questionVC animated:YES];
                }else if ([model.code isEqualToString:@"1002"]){        //咨询服务
                    [WMHUDUntil showMessageToWindow:@"该功能仅对医生开放"];
                    return;
                }else if ([model.code isEqualToString:@"1003"]){        //医聊圈
                    [self gotoDocChatCircleVC:responseObject[@"openService"]];
                }else if ([model.code isEqualToString:@"1005"]){        //我的患者
                    WMCricleMainViewController *cricleMainVC = [[WMCricleMainViewController alloc] init];
                    cricleMainVC.title = @"我的患者";
                    cricleMainVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:cricleMainVC animated:YES];
                }
            }else{      //医生
                if ([responseObject[@"certificationStatus"] intValue] == 0) {        //未认证
                    [PopUpUtil confirmWithTitle:@"" message:@"您还未认证，认证成功后可开通此项功能" toViewController:self buttonTitles:@[@"取消",@"认证"] completionBlock:^(NSUInteger buttonIndex) {
                        if (buttonIndex == 1) {
                            WMCertificationViewController * goVC = [WMCertificationViewController new];
                            goVC.isFirstLogin = false;
                            goVC.hidesBottomBarWhenPushed = YES;
                            [self.navigationController pushViewController:goVC animated:YES];
                        }
                    }];
                }else if([responseObject[@"certificationStatus"] intValue] == 1){        //认证中
                    [WMHUDUntil showMessageToWindow:@"您已提交认证申请，通过后即可使用，请耐心等待"];
                    return;
                }else if([responseObject[@"certificationStatus"] intValue] == 2){        //已认证
                    if ([model.code isEqualToString:@"1004"]) {     //患者报到
                        
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
                    }else if ([model.code isEqualToString:@"1001"]){    //一问医答
                        WMQuestionsViewController * questionVC = [[WMQuestionsViewController alloc]init];
                        questionVC.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:questionVC animated:YES];
                        BOOL redPoint = [[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"functionCode1001%@",loginModel.phone]];
                        if (redPoint) {
                            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:[NSString stringWithFormat:@"functionCode1001%@",loginModel.phone]];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                            [self headerRefreshData];
                        }
                    }else if ([model.code isEqualToString:@"1002"]){        //咨询服务
                        [self gotoCounselingVC:responseObject[@"openService"]];
                        BOOL redPoint = [[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"functionCode1002%@",loginModel.phone]];
                        if (redPoint) {
                            
                            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:[NSString stringWithFormat:@"functionCode1002%@",loginModel.phone]];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                            [self headerRefreshData];
                        }
                    }else if ([model.code isEqualToString:@"1003"]){        //医聊圈
                        [self gotoDocChatCircleVC:responseObject[@"openService"]];
                        
                        BOOL redPoint = [[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"functionCode1003%@",loginModel.phone]];
                        NSLog(@"this is one:%d",[[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"functionCode1003%@",loginModel.phone]]);
                        if (redPoint) {
                            redPoint = NO;
                            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:[NSString stringWithFormat:@"functionCode1003%@",loginModel.phone]];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                            NSLog(@"this is two:%d",[[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"functionCode1003%@",loginModel.phone]]);
                            [self headerRefreshData];
                        }
                        
                    }else if ([model.code isEqualToString:@"1005"]){        //我的患者
                        WMCricleMainViewController *cricleMainVC = [[WMCricleMainViewController alloc] init];
                        cricleMainVC.title = @"我的患者";
                        cricleMainVC.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:cricleMainVC animated:YES];
                    }else if ([model.code isEqualToString:@"1000"]){        //更多
                        [WMHUDUntil showMessageToWindow:@"更多功能上线中"];
                    }
                }else if([responseObject[@"certificationStatus"] intValue] == 3){        //认证未通过
                    [PopUpUtil confirmWithTitle:@"" message:@"您的认证未通过，认证成功后可开通此项功能" toViewController:self buttonTitles:@[@"取消",@"认证"] completionBlock:^(NSUInteger buttonIndex) {
                        if (buttonIndex == 1) {
                            WMCertificationViewController * goVC = [WMCertificationViewController new];
                            goVC.isFirstLogin = false;
                            goVC.hidesBottomBarWhenPushed = YES;
                            [self.navigationController pushViewController:goVC animated:YES];
                        }
                    }];
                }
            }
            
            
        }else{
            [WMHUDUntil showMessageToWindow:@"该功能暂未开放"];
        }
    } withFailure:^(ResponseResult *errorResult) {
        if (errorResult.code == 18008) {
            [PopUpUtil confirmWithTitle:@"" message:@"您的认证未通过，认证成功后可开通此项功能" toViewController:self buttonTitles:@[@"取消",@"认证"] completionBlock:^(NSUInteger buttonIndex) {
                if (buttonIndex == 1) {
                    WMCertificationViewController * goVC = [WMCertificationViewController new];
                    goVC.isFirstLogin = false;
                    goVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:goVC animated:YES];
                }
            }];
        }
    }];
    
    
    NSLog(@"WMFunctionEntries:%@",model);
    
}

/**
 跳转咨询服务
 */
- (void)gotoCounselingVC:(NSString *)openService{
    WMcounselingVC *counselingVC = [[WMcounselingVC alloc] init];
    counselingVC.hidesBottomBarWhenPushed = YES;
    counselingVC.openService = openService;
    [self.navigationController pushViewController:counselingVC animated:YES];
}


/**
 跳转医聊圈
 */
- (void)gotoDocChatCircleVC:(NSString *)openService{
    WMMedicalCircleViewController *medicalCircleVC = [[WMMedicalCircleViewController alloc] init];
    medicalCircleVC.hidesBottomBarWhenPushed = YES;
    medicalCircleVC.openService = openService;
    [self.navigationController pushViewController:medicalCircleVC animated:YES];
}

- (void)clickYingYongEntran:(HomeAppModel *)model{
    NSLog(@"HomeAppModel:%@",model);
    
    if ([model.skipType isEqualToString:@"2"]) {
        WMMessageNewDetailViewController *messageNewDetailVC=[[WMMessageNewDetailViewController alloc]init];
        messageNewDetailVC.urlString= [CommonUtil utf8WithString:model.skipParameters];
        messageNewDetailVC.hidesBottomBarWhenPushed = YES;
        messageNewDetailVC.hiddenRightBarBtn = @"1";
        [self.navigationController pushViewController:messageNewDetailVC animated:YES];
        return;
    }
    
    if ([model.skipId isEqualToString:@"2003"]) {       //我的微豆
        WMMyMicroBeanViewController *myMicroBeanViewController = [[WMMyMicroBeanViewController alloc] init];
        myMicroBeanViewController.backTitle = @"";
        myMicroBeanViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:myMicroBeanViewController animated:YES];
    }else if ([model.skipId isEqualToString:@"2002"]){     //微脉大学
        [self.tabBarController setSelectedIndex:2];
        //发送通知
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
        
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            NSNotification *notification =[NSNotification notificationWithName:@"changeToShoolNotification" object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            
        });
        
    }
    
}

//立即解答
- (void)answerBtnClickAction:(UIButton *)button{
    WMQuestionModel *question = [self.dataSource objectAtIndex:button.tag];
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Circle" bundle:nil];
    WMQuestionDetailViewController * questionDetailViewController = (WMQuestionDetailViewController *)[storyboard instantiateViewControllerWithIdentifier:@"WMQuestionDetailViewController"];
    questionDetailViewController.question = question;
    questionDetailViewController.hidesBottomBarWhenPushed = YES;
    questionDetailViewController.backTitle = @"返回";
    [self.navigationController pushViewController:questionDetailViewController animated:YES];
}

-(void)goMore:(UIGestureRecognizer *)gesture{
    
    WMCertificationStatusAPIManager * api = [WMCertificationStatusAPIManager new];
    [api loadDataWithParams:@{@"code":@"1001"} withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        if (responseObject[@"openFlag"]) {
            
            
            if ([responseObject[@"certificationStatus"] intValue] == 0) {        //未认证
                [PopUpUtil confirmWithTitle:@"" message:@"您还未认证，认证成功后可开通此项功能" toViewController:self buttonTitles:@[@"取消",@"认证"] completionBlock:^(NSUInteger buttonIndex) {
                    if (buttonIndex == 1) {
                        WMCertificationViewController * goVC = [WMCertificationViewController new];
                        goVC.isFirstLogin = false;
                        goVC.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:goVC animated:YES];
                    }
                }];
            }else if([responseObject[@"certificationStatus"] intValue] == 1){        //认证中
                [WMHUDUntil showMessageToWindow:@"您已提交认证申请，通过后即可使用，请耐心等待"];
                return;
            }else if([responseObject[@"certificationStatus"] intValue] == 2){        //已认证
                WMQuestionsViewController * questionVC = [[WMQuestionsViewController alloc]init];
                questionVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:questionVC animated:YES];
            }else if([responseObject[@"certificationStatus"] intValue] == 3){        //认证未通过
                [PopUpUtil confirmWithTitle:@"" message:@"您的认证未通过，认证成功后可开通此项功能" toViewController:self buttonTitles:@[@"取消",@"认证"] completionBlock:^(NSUInteger buttonIndex) {
                    if (buttonIndex == 1) {
                        WMCertificationViewController * goVC = [WMCertificationViewController new];
                        goVC.isFirstLogin = false;
                        goVC.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:goVC animated:YES];
                    }
                }];
            }
            
        }else{
            [WMHUDUntil showMessageToWindow:@"该功能暂未开放"];
        }
    } withFailure:^(ResponseResult *errorResult) {
        if (errorResult.code == 18008) {
            [PopUpUtil confirmWithTitle:@"" message:@"您的认证未通过，认证成功后可开通此项功能" toViewController:self buttonTitles:@[@"取消",@"认证"] completionBlock:^(NSUInteger buttonIndex) {
                if (buttonIndex == 1) {
                    WMCertificationViewController * goVC = [WMCertificationViewController new];
                    goVC.isFirstLogin = false;
                    goVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:goVC animated:YES];
                }
            }];
        }
    }];
    
    
}

- (void)setTabUnread{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        int unreadMsgCount = [[RCIMClient sharedRCIMClient] getUnreadCount:@[
                                                                             @(ConversationType_PRIVATE),
                                                                             @(ConversationType_CUSTOMERSERVICE),
                                                                             ]];
        UIWindow *window=[AppDelegate sharedAppDelegate].window;
        WMTabBarController * tabBarController = (WMTabBarController *)window.rootViewController;
        [tabBarController setTabBarNmuber:[NSString stringWithFormat:@"%d",unreadMsgCount]];
    });
}

//功能区跳转
- (void)gojump:(UIButton *)gesture{
    NSLog(@"6666------%ld",gesture.tag);
    
}

- (void)DaySign{
    
    LoginModel * loginModel = [WMLoginCache getMemoryLoginModel];
    if (loginModel.userType) {      //护士不签到
        return;
    }
    
    //判断今日是否签过到
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDate * date = [NSDate date];
    NSString * todayString = [[date description] substringToIndex:10];
    LoginModel * loginM = [WMLoginCache getMemoryLoginModel];
    NSString * phone = [NSString stringWithFormat:@"%@,%@",todayString,loginM.phone];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"daySign"] isEqualToString:phone]) {
        return;
    }
    
    
    WMDaySignAPIManager * apiManager = [WMDaySignAPIManager new];
    [apiManager loadDataWithParams:nil withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        
        [WMHUDUntil showSuccessWithMessage:[NSString stringWithFormat:@"签到成功，积分+%@ 积分详情去我的微积分查看",responseObject[@"score"]] toView:self.view];
        
        [defaults setObject:phone forKey:@"daySign"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSLog(@"date:%@",date);
    } withFailure:^(ResponseResult *errorResult) {
        if ([errorResult.message isEqualToString:@"您今日已签到"]) {
            [defaults setObject:phone forKey:@"daySign"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
    }];
}

-(void)CertificationResultView{
    WMGetStatusAPIManager * apiManager = [WMGetStatusAPIManager new];
    
    LoginModel * loginModel = [WMLoginCache getMemoryLoginModel];
    
    NSString *certificationSuc=[NSString stringWithFormat:@"certificationSuc%@",loginModel.phone];
    NSString *certificationFail=[NSString stringWithFormat:@"certificationFail%@",loginModel.phone];
    
    [apiManager loadDataWithParams:nil withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        WMStatusModel * statusModel = (WMStatusModel *)responseObject;
        loginModel.certStatus=statusModel.status;
        [WMLoginCache setDiskLoginModel:loginModel];
        [WMLoginCache setMemoryLoginModel:loginModel];
        if ([statusModel.popup intValue]==1) {
            if (loginModel.userType==NO) {
                
                if (![[[NSUserDefaults standardUserDefaults] objectForKey:certificationSuc]isEqualToString:@"Yes"] &&[statusModel.status isEqualToString:@"2"]) {
                    
                    [[NSUserDefaults standardUserDefaults] setObject: @"Yes"forKey:certificationSuc];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    
                    
                    WMDoctorCertificationResultView *resultView=[[WMDoctorCertificationResultView alloc] initWithText:statusModel.status withMoney:statusModel.money];
                    resultView.delegate=self;
                    [resultView show];
                }
                
                if ([statusModel.status isEqualToString:@"3"]&&![[[NSUserDefaults standardUserDefaults] objectForKey:certificationFail]isEqualToString:@"Yes"] ) {
                    
                    [[NSUserDefaults standardUserDefaults] setObject: @"Yes"forKey:certificationFail];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    WMDoctorCertificationResultView *resultView=[[WMDoctorCertificationResultView alloc] initWithText:statusModel.status withMoney:statusModel.money];
                    resultView.delegate=self;
                    [resultView show];
                    
                }
            }
        }
    } withFailure:^(ResponseResult *errorResult) {
    }];
}

#pragma mark--WMDoctorCerResultViewDelegate
- (void)newbieGuide{
    
    WMNewGuideViewController *certificationVC=[[WMNewGuideViewController alloc] init];
    WorkEnvironment _currentEnvir = [AppConfig currentEnvir];   //获取当前运行环境
    certificationVC.urlString=(_currentEnvir == 0)?H5_URL_NEWGUIDE_FORMAL:H5_URL_NEWGUIDE_TEST;
    certificationVC.hidesBottomBarWhenPushed=YES;
    
    UIWindow *window=[AppDelegate sharedAppDelegate].window;
    WMTabBarController * tabBarController = (WMTabBarController *)window.rootViewController;
    WMNavgationController * navController = (WMNavgationController*)tabBarController.viewControllers[tabBarController.selectedIndex];
    [navController showViewController:certificationVC sender:nil];
}
- (void)continueAuthentication{
    WMCertificationViewController *certificationVC=[[WMCertificationViewController alloc] init];
    certificationVC.hidesBottomBarWhenPushed=YES;
    UIWindow *window=[AppDelegate sharedAppDelegate].window;
    WMTabBarController * tabBarController = (WMTabBarController *)window.rootViewController;
    WMNavgationController * navController = (WMNavgationController*)tabBarController.viewControllers[tabBarController.selectedIndex];
    [navController showViewController:certificationVC sender:nil];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"InfoNotification" object:nil];
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
