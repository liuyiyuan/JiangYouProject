//
//  JYMeViewController.m
//  WMDoctor
//
//  Created by jiangqi on 2018/6/25.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYMeViewController.h"
#import "JYMeHeaderView.h"
#import "JYMeTableViewCell.h"
#import "JYMyWalletViewController.h"//我的钱包
#import "JYAboutUsViewController.h"//关于我们
#import "JYPersonalInformationViewController.h"//个人资料
#import "JYPersonEditInformationViewController.h"//个人信息编辑页
#import "JYLoginViewController.h"//登录页
#import "JYMineAPIManager.h"
#import "JYGetPersonalInfoManager.h"
@interface JYMeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *meTableView;

@property(nonatomic,strong)JYMeHeaderView *headerView;

@property (nonatomic, strong) NSDictionary *userDcit;

@end

@implementation JYMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的";
    self.userDcit = [[NSUserDefaults standardUserDefaults]objectForKey:@"JYLoginUserInfo"];
    [self configUI];
    [self loadMineData];
}

-(void)configUI{
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.meTableView];
}

- (void)registerNoti{
    //登陆相关通知注册
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(kLoginInSuccessAction:)
                                                 name:kLoginInSuccessNotification
                                               object:nil];
}

#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JYMeTableViewCell *cell = [[JYMeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"JYMeTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    switch (indexPath.row) {
        case 0:
            cell.iconImageView.image = [UIImage imageNamed:@"my_wallet"];
            cell.typeLabel.text = @"我的钱包";
            break;
        case 1:
        {
            cell.iconImageView.image = [UIImage imageNamed:@"my_shop_center"];
            cell.typeLabel.text = @"商户中心";
        }
            break;
        case 2:
            cell.iconImageView.image = [UIImage imageNamed:@"my_push"];
            cell.typeLabel.text = @"订阅中心";
            break;
        case 3:
            cell.iconImageView.image = [UIImage imageNamed:@"my_answer_online"];
            cell.typeLabel.text = @"在线客服";
            break;
        case 4:
            cell.iconImageView.image = [UIImage imageNamed:@"my_about_us"];
            cell.typeLabel.text = @"关于我们";
            break;
        case 5:
            cell.iconImageView.image = [UIImage imageNamed:@"my_log_out"];
            cell.typeLabel.text = @"退出登录";
            break;
        default:
            break;
    }
    UIView *backView = [[UIView alloc]initWithFrame:cell.frame];
    backView.backgroundColor = [UIColor colorWithHexString:@"#E4E5E6"];
    cell.selectedBackgroundView = backView;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return pixelValue(100);
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0://我的钱包
        {
            JYMyWalletViewController *Wallet = [JYMyWalletViewController new];
            Wallet.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:Wallet animated:YES];
        }
            break;
         
        case 3://客服
        {
            [self advisoryOnline];
        }
            break;
            
        case 4://关于我们
        {
            JYAboutUsViewController *aboutUs = [JYAboutUsViewController new];
            aboutUs.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:aboutUs animated:YES];
        }
            break;
    
        case 5://退出登录
        {

            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"JYLoginUserInfo"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            if ([UIApplication sharedApplication].delegate.window.rootViewController != nil) {
                [UIApplication sharedApplication].delegate.window.rootViewController = nil;
            }
            UINavigationController * loginNavController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginNavgationController"];
            
            [UIApplication sharedApplication].delegate.window.rootViewController = loginNavController;
            
        }
            
            break;
 
            
        case 2://首次登录
        {
//            JYLoginViewController *aboutUs = [JYLoginViewController new];
//            aboutUs.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:aboutUs animated:YES];
        }
            
            break;
        default:
            break;
    }
}


#pragma mark - 获取标签
-(void)GetPersonalInfo{
    JYGetPersonalInfoManager *getPersonalInfo = [[JYGetPersonalInfoManager alloc] init];
    [getPersonalInfo loadDataWithParams:@{@"userId":@18} withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        
        
//        for (NSDictionary *dic in [responseObject allObjects]) {
//            [self.tagArrays addObject:dic];
//        }
        
        
        
    } withFailure:^(ResponseResult *errorResult) {
        NSLog(@"login error : %@", errorResult);
        
    }];
}


-(JYMeHeaderView *)headerView{
    if(!_headerView){
        _headerView = [[JYMeHeaderView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 120)];
        [_headerView.arrowButton addTarget:self action:@selector(click_arrowButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _headerView;
}
-(UITableView *)meTableView{
    if(!_meTableView){
        _meTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headerView.frame), UI_SCREEN_WIDTH, pixelValue(600))];
        _meTableView.delegate = self;
        _meTableView.dataSource = self;
        _meTableView.backgroundColor = [UIColor whiteColor];
        _meTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _meTableView.showsVerticalScrollIndicator = NO;
        _meTableView.scrollEnabled = NO;
    }
    return _meTableView;
}

#pragma mark - 跳转个人资料
-(void)click_arrowButton{
                JYPersonEditInformationViewController *aboutUs = [JYPersonEditInformationViewController new];
                aboutUs.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:aboutUs animated:YES];
    
//    JYPersonalInformationViewController *personalInformation = [JYPersonalInformationViewController new];
//    personalInformation.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:personalInformation animated:YES];
}


#pragma mark - 在线咨询
-(void)advisoryOnline{
    
    ZCChatController *chat = [ZCChatController new];
    if ([chat respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        chat.edgesForExtendedLayout = UIRectEdgeNone;
    }
    // 启动
    ZCLibInitInfo *initInfo = [ZCLibInitInfo new];
    initInfo.avatarUrl = @"avatar_loading";
    // 企业编号 必填
    initInfo.appKey = @"af7f8ef937cc49de8eb9a603ea5a9bf4";
    // 用户id，用于标识用户，建议填写 (注意：userId不要写死，否则获取的历史记录相同)
//    initInfo.userId = self.userDcit[@"userId"];

    initInfo.userId = @"18";
    //配置UI
    ZCKitInfo *uiInfo = [ZCKitInfo new];
    uiInfo.customBannerColor = [UIColor colorWithHexString:@"#50B8FB"];
    uiInfo.topViewTextColor = [UIColor whiteColor];
    
    // 是否显示转人工按钮
    uiInfo.isShowTansfer = YES;
    
    //设置启动参数
    [[ZCLibClient getZCLibClient] setLibInitInfo:initInfo];
    // 智齿SDK初始化启动事例，
    // 必须在之前调用[[ZCLibClient getZCLibClient] initSobotSDK:@"your appkey"];
    
    [ZCSobot startZCChatVC:uiInfo
                      with:self.navigationController
                  loaction:CGRectMake(0, 0, 200, 200)
                    target:nil
                 pageBlock:^(ZCChatController *object,ZCPageBlockType type){
                     // 点击返回
                     if(type==ZCPageBlockGoBack){
                         NSLog(@"点击了返回按钮");
                         [ZCLibClient closeAndoutZCServer:YES];
                     }
                     // 页面UI初始化完成，可以获取UIView，自定义UI
                     if(type == ZCPageBlockLoadFinish){
                         
                     }
                 } messageLinkClick:nil];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSIndexPath *selected = [self.meTableView indexPathForSelectedRow];
    if(selected) [self.meTableView deselectRowAtIndexPath:selected animated:NO];
    
    [self GetPersonalInfo];
}

- (void)kLoginInSuccessAction:(NSNotification*)note{
    [self loadMineData];
}

- (void)loadMineData{
    JYMineAPIManager *mineAPIManager = [[JYMineAPIManager alloc] init];
    [mineAPIManager loadDataWithParams:@{} withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"mine request response data : %@", responseObject);
    } withFailure:^(ResponseResult *errorResult) {
        NSLog(@"mine request error : %@", errorResult);
    }];
}



- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
