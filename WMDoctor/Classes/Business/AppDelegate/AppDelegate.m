//
//  AppDelegate.m
//  WMDoctor
//
//  Created by choice-ios1 on 16/12/13.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+Business.h"
#import "WMGuidePageViewController.h"
#import <UMMobClick/MobClick.h>
#import "AppConfig.h"
#import "WMMockHttpUtil.h"
#import "WMDevice.h"
#import <UMSocialCore/UMSocialCore.h>
#import "AppDelegate+RongCloud.h"
#import <MagicalRecord/MagicalRecord+ShorthandMethods.h>
#import <AFNetworkReachabilityManager.h>
#import "AppDelegate+RongCloud.h"
#import <Bugly/Bugly.h>
#import "AppDelegate+GeTui.h"
#import "Growing.h"
#import <MWApi.h>
#import "WMUserAgentUtil.h"



#define UMENG_APPKEY        @"563b130be0f55ab47e0021ea"
#define BUGLY_APPID        @"842cdc8615"

//个推正式环境
#define kGtAppId           @"baMU3LXkuJ6rtjXO9up0kA"
#define kGtAppKey          @"hOpFcy4Ckh8KRYk4Lavmc"
#define kGtAppSecret       @"VIZbjpGxzp717Q80lumqQ2"
//个推非正式环境
#define kGtAppIdTest           @"IiIdwN3OdBAQamNBk0y715"
#define kGtAppKeyTest          @"BGPMujmTfW5onw2ZMpYtz9"
#define kGtAppSecretTest       @"SYi7hJ4oeC86VhKadN7by6"
#define GROWINGIOID         @"ae38ef915ad0d9cc"

static NSString * const kLaunchStoreName = @"wmdoctor.sqlite";
static NSString * const kNetworkTestURL = @"https://www.baidu.com";




@interface AppDelegate ()<selectDelegate,BuglyDelegate,UIApplicationDelegate>{
    BOOL _isLaunchByPushInfo;
}

@property (nonatomic,strong)AFNetworkReachabilityManager *manager;

- (void)loadMainView;


- (void)loadLoginView;

@end

@implementation AppDelegate


#pragma -mark public API

+ (AppDelegate *)sharedAppDelegate{
    
    AppDelegate * delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return delegate;
}
#pragma -mark custom API

- (void)loadMainView
{
    if (self.window.rootViewController != nil) {
        self.window.rootViewController = nil;
    }
    UITabBarController * tabBarController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"WMTabBarController"];
    self.window.rootViewController = tabBarController;
}

- (void)loadLoginView
{
    if (self.window.rootViewController != nil) {
        self.window.rootViewController = nil;
    }
    UINavigationController * loginNavController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginNavgationController"];

    self.window.rootViewController = loginNavController;
}


/**
 加载引导页
 */
- (void)loadGuide
{
    NSString *launchVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"launchVersion"];
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    if (launchVersion==nil || ![launchVersion isEqualToString:appVersion]) {//版本为空或者版本不一致
    
//        WMGuidePageViewController * guideView = [[WMGuidePageViewController alloc] init];
//        UIViewController * view = self.window.rootViewController;
//        [view presentViewController:guideView animated:YES completion:nil];
        
        NSArray *images = @[@"bg_yindao1", @"bg_yindao2", @"bg_yindao3"];
        UIViewController * viewVC = self.window.rootViewController;
        WMGuidePageViewController * guideVC = [[WMGuidePageViewController alloc]init];
        guideVC.images = images;
        guideVC.delegate = self;
        [viewVC presentViewController:guideVC animated:NO completion:nil];
        [[NSUserDefaults standardUserDefaults] setObject:appVersion forKey:@"launchVersion"];
        
        //升级版本之后，清除缓存 2018年05月31日19:48:23
        [self cleanWebViewCache];
    }
}

- (void)guideDoneClick:(WMGuidePageViewController *)selfVC
{
    NSLog(@"gogogo");
    selfVC.navigationController.navigationBarHidden = NO;
    [UIApplication sharedApplication].statusBarHidden = NO;
    [selfVC dismissViewControllerAnimated:NO completion:^{

    }];
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"yindaoEnd"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"yindaoEnd" object:nil];
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        //启动登陆接口调用
        [self loadBusinessNetwork];
    });
    //清空badge标志
    application.applicationIconBadgeNumber = 0;
    NSDictionary *remoteNotificationUserInfo = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
    NSLog(@"remoteNotificationUserInfo==%@",remoteNotificationUserInfo);
    //注册通知
    [self registerRemoteNotification];
    [[RCIM sharedRCIM] initWithAppKey:RONGCLOUNDAPP_KEY];
    [self initializeDiskData];
    
//    [self initializeNotification];
    [self loadMainView];
    
    [self initializeCoreData];
    
    //第三方注册
    [self prepareThirdLibraryRegister];
    
    // 启动GrowingIO
    [Growing startWithAccountId:GROWINGIOID];
    // 其他配置
    // 开启Growing调试日志 可以开启日志
    // [Growing setEnableLog:YES];
    
    //[WMUserAgentUtil loadUserAgentWithPayToken:@""];
    
    //个推
    [self GtPushWithOptions:launchOptions];
    
    NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);
   
    return YES;
}
- (void)initializeDiskData
{
    NSLog(@"--=%@",NSHomeDirectory());
    
    LoginModel * model = [WMLoginCache getDiskLoginModel];
    if (model) {
        [WMLoginCache setMemoryLoginModel:model];
    }
    //设置缓存容量
    NSURLCache * urlCache = [[NSURLCache alloc] initWithMemoryCapacity:40*1024*1024
                                                          diskCapacity:100*1024*1024
                                                              diskPath:nil];
    [NSURLCache setSharedURLCache:urlCache];
     
}
- (void)initializeCoreData
{
    [MagicalRecord enableShorthandMethods];
    //数据库配置
    //[MagicalRecord setupCoreDataStackWithStoreNamed:kLaunchStoreName];
    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:kLaunchStoreName];
    [MagicalRecord setLoggingLevel:MagicalRecordLoggingLevelWarn];
    //Debug模式下才能开启
    //[MagicalRecord setShouldDeleteStoreOnModelMismatch:YES];
}
- (void)initializeNotification
{
    //登陆相关通知注册
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(kLoginInSuccessAction:)
                                                 name:kLoginInSuccessNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(kLoginOutSuccessAction:)
                                                 name:kLoginOutSuccessNotification
                                               object:nil];
    self.manager = [AFNetworkReachabilityManager managerForDomain:kNetworkTestURL];
    [self.manager startMonitoring];
//    __weak typeof(self) weakself = self;
    [self.manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status==AFNetworkReachabilityStatusReachableViaWWAN||status==AFNetworkReachabilityStatusReachableViaWiFi) {
            //刷新需要刷新的页面和接口（启动页，版本升级）
        }
        NSLog(@"AFReachability.status=%zd",status);
        //[weakself syncLoadUpgradeCheck:nil];
    }];
    
}
- (void)kLoginInSuccessAction:(NSNotification*)note

{
    LoginModel * loginModel = [WMLoginCache getMemoryLoginModel];
    [self setupRongCloudMessageWithLoginModel:loginModel];
    [self loadMainView];
    [self loadGuide];
    [WMUserAgentUtil loadUserAgentWithPayToken:@""];    //初始化UserAgent
    [Bugly setUserIdentifier:[NSString stringWithFormat:@"User: %@", loginModel.phone]];


}
- (void)kLoginOutSuccessAction:(NSNotification*)note
{
    LoginModel * model = [WMLoginCache getDiskLoginModel];
    model.loginFlag = @"0"; //登陆标识，1表示已登陆过，0表示已注销
    [WMLoginCache setDiskLoginModel:model];
    //移除内存中账号数据
    [WMLoginCache removeMemoryModel];
    
    //清除金融token
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"jrtoken"];
    [defaults removeObjectForKey:@"jrtokentime"];
    [defaults synchronize];
    
    //TO DO>>>
    //如果后续内存中有账号有关的数据，也需要在注销时一并清除
    
    [self loadLoginView];
    //断开融云连接
    [[RCIM sharedRCIM]logout];
    [self loadGuide];
    
    [Bugly setUserIdentifier:[NSString stringWithFormat:@"User: 未登录"]];
    
    //web缓存问题，登出清除缓存，解决相关h5页面后台信息是第一个号的。
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];


}
- (void)loginUnVaildWithAlert:(BOOL)show
{
    if (show) {
        [PopUpUtil confirmWithTitle:@"温馨提示" message:@"您的账户在别处登录" toViewController:nil buttonTitles:@[@"重新登录"] completionBlock:^(NSUInteger buttonIndex) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kLoginOutSuccessNotification object:nil userInfo:nil];
        }];

    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:kLoginOutSuccessNotification object:nil userInfo:nil];
    }
    
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    
     [self getPushMessage:application];
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [self applicationWillEnterForegroundBusiness];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}
#pragma mark--
/** 注册 APNs */
- (void)registerRemoteNotification {
    
    //推送处理1
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0 // Xcode 8编译会调用
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError *_Nullable error) {
            if (!error) {
                NSLog(@"request authorization succeeded!");
            }
        }];
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
#else // Xcode 7编译会调用
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
#endif
    } else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    } else {
        //适配iOS7的通知  由于不再适配故删除一下代码
    }
}
/// 注册失败调用
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"远程通知注册失败：%@",error);
    [GeTuiSdk registerDeviceToken:@""];
}
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    if ([notification.userInfo objectForKey:@"rc"]){
        [self rongCloudIMMessageJump:notification.userInfo];
    }
}
/** APP已经接收到“远程”通知(推送) - 透传推送消息 (----message----) */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    // 处理APNs代码，通过userInfo可以取到推送的信息（包括内容，角标，自定义参数等）。如果需要弹窗等其他操作，则需要自行编码。
    NSLog(@"\n>>>[Receive RemoteNotification - Background Fetch]:%@\n\n",userInfo);
    
    //自我感觉应该先判断是融云的信息 不是就不调用 省时间哈哈哈
    if ([userInfo objectForKey:@"rc"]){
        //延时 知道为什么要延时吗--因为此时loginModel为空
        
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));
        
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            
            [self rongCloudIMMessageJump:userInfo];
        });
    }
    
    if ([[UIApplication sharedApplication] applicationState] ==UIApplicationStateInactive) {
        if (!userInfo[@"Content"]) {
            return;
        }
        _isLaunchByPushInfo = YES;
        NSData *data = [userInfo[@"Content"] dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *pushInfo = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
    }
    completionHandler(UIBackgroundFetchResultNewData);

}
#pragma mark--ios10 远程推送
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler
{
    //应用在前台收到通知
    NSLog(@"========%@", notification);
    //[UIApplication registerForRemoteNotifications]; //and UserNotifications Framework's -[UNUserNotificationCenter requestAuthorizationWithOptions:completionHandler:]")
    
    // 根据APP需要，判断是否要提示用户Badge、Sound、Alert
    //completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
    
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler
{ //点击通知进入应用
    
    NSLog(@"response:%@", response);
    NSLog(@"notification=%@",response.notification);
    UNNotification *notification=(UNNotification *)response.notification;
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        if ([notification.request.content.userInfo objectForKey:@"rc"]){
            //融云消息接受
            [self rongCloudIMMessageJump:notification.request.content.userInfo];
        }
    });

    
    
    NSLog(@"notification.request.content.userInfo=%@",notification.request.content.userInfo);
    
    if (!notification.request.content.userInfo[@"Content"]) {
        return;
    }
    NSLog(@"content = %@", notification.request.content.userInfo[@"Content"]);
    [GeTuiSdk handleRemoteNotification:response.notification.request.content.userInfo];
    _isLaunchByPushInfo = YES;
    NSData *data = [notification.request.content.userInfo[@"Content"] dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *pushInfo = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//    [self goListByPushInfo:pushInfo state:1];
//    [PopUpUtil alertWithMessage:[pushInfo objectForKey:@"TITLE"] toViewController:nil withCompletionHandler:^{
//        
//    }];
}

/** SDK收到透传消息回调 (---消息内容---) 7月21日替换老版本个推 11月22删除代码*/

- (void)GeTuiSdkDidReceivePayloadData:(NSData *)payloadData andTaskId:(NSString *)taskId andMsgId:(NSString *)msgId andOffLine:(BOOL)offLine fromGtAppId:(NSString *)appId {
    NSLog(@"payloadData = %@", payloadData);
    NSDictionary *pushInfo = [NSJSONSerialization JSONObjectWithData:payloadData options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"pushInfo = %@", pushInfo);
    if (offLine && _isLaunchByPushInfo) {
        if (payloadData) {
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));
            
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                NSDictionary *pushInfo = [NSJSONSerialization JSONObjectWithData:payloadData options:NSJSONReadingMutableContainers error:nil];
                if (pushInfo) {
                    [self goListByPushInfo:pushInfo state:2];
                }
                
            });
        }
    }
    
    
    
    _isLaunchByPushInfo = NO;
    /**
     *汇报个推自定义事件
     *actionId：用户自定义的actionid，int类型，取值90001-90999。
     *taskId：下发任务的任务ID。
     *msgId： 下发任务的消息ID。
     *返回值：BOOL，YES表示该命令已经提交，NO表示该命令未提交成功。注：该结果不代表服务器收到该条命令
     **/
    [GeTuiSdk sendFeedbackMessage:90001 andTaskId:taskId andMsgId:msgId];
    
}

#pragma -mark 注册第三方库
- (void)prepareThirdLibraryRegister
{
    
    
    NSString * channelid = ([AppConfig currentEnvir]==0)?nil:@"Dev";
    UMConfigInstance.appKey = UMENG_APPKEY;
    UMConfigInstance.channelId = channelid;
    UMConfigInstance.ePolicy = BATCH;
    [MobClick startWithConfigure:UMConfigInstance];
    
    [MobClick setAppVersion:[[WMDevice currentDevice] appVersion]];
    
    //友盟社会化分享注册
    [[UMSocialManager defaultManager] setUmSocialAppkey:UMENG_APPKEY];
    
    //设置分享到QQ互联的appKey和appSecret
    // U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:QQ_APPID  appSecret:nil redirectURL:@"https://doctor.myweimai.com"];
    
    
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:WX_APPID appSecret:WX_AppSecret redirectURL:@"https://doctor.myweimai.com/"];
    
    
    
//    //设置新浪的appKey和appSecret       //暂不用新浪微博，沉香表示不解
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"1434019602"  appSecret:@"34dfd3f9baee059223046ab0d7c25150" redirectURL:@"https://doctor.myweimai.com/"];
    
    //钉钉的appKey
//    [[UMSocialManager defaultManager] setPlaform: UMSocialPlatformType_DingDing appKey:@"dingoalmlnohc0wggfedpk" appSecret:nil redirectURL:nil];
    
    //正式库并且release模式开启
    
    
    BuglyConfig * config = [[BuglyConfig alloc] init];
    config.reportLogLevel = BuglyLogLevelWarn;
    config.blockMonitorEnable = YES;
    config.blockMonitorTimeout = 2.5;
    config.version = [[WMDevice currentDevice] appVersion];
    config.delegate = self;
    //config.debugMode = YES;
    //config.channel = @"Debug";

    // Set the customizd tag thats config in your APP registerd on the  bugly.qq.com
    // [Bugly setTag:1799];
    
    //[Bugly setUserValue:[NSProcessInfo processInfo].processName forKey:@"Process"];
    
#if DEBUG
    
    //[MobClick setCrashReportEnabled:NO];
    [MobClick setLogEnabled:YES];
    [[UMSocialManager defaultManager] openLog:YES];
    
    [WMMockHttpUtil configMockHttpResponse];
    
#elif PRERELEASE
    
    [MobClick setLogEnabled:NO];
    //关闭mock
    [WMMockHttpUtil setMockEnabled:NO];
    
#else
    
    //[MobClick setCrashReportEnabled:YES];
    [MobClick setLogEnabled:NO];
    //关闭mock
    [WMMockHttpUtil setMockEnabled:NO];
    
    [Bugly startWithAppId:BUGLY_APPID
        developmentDevice:YES
                   config:config];
    
#endif
}
// 设置一个C函数，用来接收崩溃信息
void UncaughtExceptionHandler(NSException *exception){
    // 可以通过exception对象获取一些崩溃信息，我们就是通过这些崩溃信息来进行解析的，例如下面的symbols数组就是我们的崩溃堆栈。
    NSArray *symbols = [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name = [exception name];
    NSLog(@"注意！注意！瞬间爆炸:%@,爆炸原因：%@,爆炸名字：%@",symbols,reason,name);
}
//#define __IPHONE_10_0    100000
#if __IPHONE_OS_VERSION_MAX_ALLOWED > 100000
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    
    result = [Growing handleUrl:url];    // 请务必确保该函数被调用

    if (!result) {
        // 其他如支付等SDK的回调
        [MWApi routeMLink:url];

    }
    return result;
}


#endif

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    [MWApi routeMLink:url];

    
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    result = [Growing handleUrl:url];    // 请务必确保该函数被调用
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}
//魔窗API
- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler
{
    //如果使用了Universal link ，此方法必写
    return [MWApi continueUserActivity:userActivity];
}
- (void)registerMlink{
    
    [MWApi registerMLinkDefaultHandler:^(NSURL * _Nonnull url, NSDictionary * _Nullable params) {
        
    }];
    
    [MWApi registerMLinkHandlerWithKey:@"gobuy" handler:^(NSURL * _Nonnull url, NSDictionary * _Nullable params) {
        //具体跳转业务 （暂时没有个这个需求）
        //MPTabBarController * tabBarController = (MPTabBarController *)self.window.rootViewController;
        //MPNavigationController * navController = (MPNavigationController*)tabBarController.viewControllers[tabBarController.selectedIndex];
        
    }];
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    result = [Growing handleUrl:url];    // 请务必确保该函数被调用
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}
/**
 * 推送处理2
 */
//注册用户通知设置
- (void)application:(UIApplication *)application
didRegisterUserNotificationSettings:
(UIUserNotificationSettings *)notificationSettings {
    // register to receive notifications
    [application registerForRemoteNotifications];
}

/**
 * 推送处理3
 */
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSString *myToken = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    myToken = [myToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    [GeTuiSdk registerDeviceToken:myToken];    /// 向个推服务器注册deviceToken
    [[RCIMClient sharedRCIMClient] setDeviceToken:myToken];///向融云服务器注册deviceToken
    
    NSLog(@"远程通知注册成功委托\n>>>[DeviceToken Success]:%@\n\n",myToken);

}


#pragma mark ------------------- 个推相关设置 ---------------------
-(void)GtPushWithOptions:(NSDictionary *)launchOptions{
    // 通过个推平台分配的appId、 appKey 、appSecret 启动SDK，注：该方法需要在主线程中调用
    
    if (ISRELEASE) {
        NSLog(@"122222 = %@",kGtAppId);
        [GeTuiSdk startSdkWithAppId:kGtAppId appKey:kGtAppKey appSecret:kGtAppSecret delegate:self];
    }else {
        NSLog(@"122222 = %@",kGtAppIdTest);
        [GeTuiSdk startSdkWithAppId:kGtAppIdTest appKey:kGtAppKeyTest appSecret:kGtAppSecretTest delegate:self];
    }
    
    NSLog(@"122222 = %@",kGtAppId);
    
    // 注册APNS
    [self registerRemoteNotification];
    
    //[self registerUserNotification];
    
    // 处理远程通知启动APP
    [self receiveNotificationByLaunchingOptions:launchOptions];
}

/** 自定义：APP被“推送”启动时处理推送消息处理（APP 未启动--》启动）*/
- (void)receiveNotificationByLaunchingOptions:(NSDictionary *)launchOptions {
    if (!launchOptions)
        return;
    
    /*
     通过“远程推送”启动APP
     UIApplicationLaunchOptionsRemoteNotificationKey 远程推送Key
     */
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        NSLog(@"通过“远程推送”启动APP\n>>>[Launching RemoteNotification]:%@", userInfo);
    }
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    
    [MagicalRecord cleanUp];
    
//    //清除cookies
//    NSHTTPCookie *cookie;
//    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//    for (cookie in [storage cookies]){
//        [storage deleteCookie:cookie];
//    }
//    //清除UIWebView的缓存
//    [[NSURLCache sharedURLCache] removeAllCachedResponses];

    //清除所有cache文件
    NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask,YES) objectAtIndex:0];
    
    NSString *cacheFolderPath = [libraryPath stringByAppendingString:@"/Caches"];
    NSLog(@"%@", cacheFolderPath);
    NSError *errors;
    
    [[NSFileManager defaultManager] removeItemAtPath:cacheFolderPath error:&errors];
}
//清除wkwebview的缓存
- (void)cleanWebViewCache {
    if ([[[UIDevice currentDevice] systemVersion] intValue] >8) {
        NSArray * types =@[WKWebsiteDataTypeMemoryCache,WKWebsiteDataTypeDiskCache,WKWebsiteDataTypeOfflineWebApplicationCache]; // 9.0之后才有的
        NSSet *websiteDataTypes = [NSSet setWithArray:types];
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
            
        }];
    }
}
#pragma -mark BuglyDelegate

- (NSString * BLY_NULLABLE)attachmentForException:(NSException * BLY_NULLABLE)exception
{
    NSString * bugMessage = [NSString stringWithFormat:@"(%@:%d) %s %@",[[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, __PRETTY_FUNCTION__,exception];
    return bugMessage;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma -mark 个推相关

/**
 Background Fetch 接口回调处理
 */
- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    /// Background Fetch 恢复SDK 运行
    [GeTuiSdk resume];
    completionHandler(UIBackgroundFetchResultNewData);
}

/** SDK启动成功返回cid */
- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId {
    //个推SDK已注册，返回clientId
    NSLog(@"\n>>>[GeTuiSdk RegisterClient]:%@\n\n", clientId);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:clientId forKey:@"clientId"];
}

/** SDK遇到错误回调 */
- (void)GeTuiSdkDidOccurError:(NSError *)error {
    //个推错误报告，集成步骤发生的任何错误都在这里通知，如果集成后，无法正常收到消息，查看这里的通知。
    NSLog(@"\n>>>[GexinSdk error]:%@\n\n", [error localizedDescription]);
}

/** SDK收到sendMessage消息回调 */
- (void)GeTuiSdkDidSendMessage:(NSString *)messageId result:(int)result{
    // [4-EXT]:发送上行消息结果反馈
    NSString *msg = [NSString stringWithFormat:@"sendmessage=%@,result=%d", messageId, result];
    NSLog(@"\n>>>[GexinSdk DidSendMessage]:%@\n\n", msg);
}

//屏幕旋转方法
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    if (_allowRotation == 1) {
        return UIInterfaceOrientationMaskLandscapeLeft;
    }
    else
    {
        return (UIInterfaceOrientationMaskPortrait);
    }
}


@end
