//
//  AppDelegate+RongCloud.m
//  WMDoctor
//
//  Created by 茭白 on 2016/12/20.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import "AppDelegate+RongCloud.h"
#import "WMRCDataManager.h"
#import "WMRCInquiryMessage.h"
#import "AppConfig.h"
#import "WMCacheModel.h"
#import <PINCache.h>
#import "WMTabBarController.h"
#import "WMNavgationController.h"
#import "WMSystemMessageViewController.h"
#import "WMRCBusinessCardMessage.h"
#import "WMJSONUtil.h"
#import "WMGroupRCDataManager.h"
#import "WMRCGroupNewsMessage.h"
#import "WMTabBarController.h"
#import "WMReplyMessage.h"


@implementation AppDelegate (RongCloud)
- (void)setupRongCloudMessageWithLoginModel:(LoginModel *)loginModel{
    //注册融云
    [[RCIM sharedRCIM] initWithAppKey:RONGCLOUNDAPP_KEY];
    NSLog(@"这里是在APP的生命周期里连接融云的次数");
    [RCIM sharedRCIM].globalNavigationBarTintColor = [UIColor blackColor];
    [RCIM sharedRCIM].globalMessagePortraitSize = CGSizeMake(46, 46);
    [RCIM sharedRCIM].globalMessageAvatarStyle = RC_USER_AVATAR_CYCLE;
    [RCIM sharedRCIM].globalConversationAvatarStyle=RC_USER_AVATAR_CYCLE;
    //[RCIM sharedRCIM].enableMessageAttachUserInfo=YES;
    //设置接收消息代理
    [RCIM sharedRCIM].receiveMessageDelegate=self;
    //[RCIM sharedRCIM].userInfoDataSource=self;
    [RCIM sharedRCIM].userInfoDataSource = [WMRCDataManager shareManager];
    [RCIM sharedRCIM].groupInfoDataSource = [WMGroupRCDataManager shareManager];
    
    // 注册自定义消息的方法
    // 这里注册初次问诊的消息
    [[RCIM sharedRCIM] registerMessageType:[WMRCInquiryMessage class]];
    [[RCIM sharedRCIM] registerMessageType:[WMRCBusinessCardMessage class]];
    [[RCIM sharedRCIM] registerMessageType:[WMRCGroupNewsMessage class]];
    [[RCIM sharedRCIM] registerMessageType:[WMReplyMessage class]];
    
    //设置IMKit连接状态的监听器
    [RCIM sharedRCIM].connectionStatusDelegate=self;
    //从服务端获取token 然后建立与服务器的连接
    [[RCIM sharedRCIM] connectWithToken:loginModel.rongToken success:^(NSString *userId) {
        //缓存头像
        
        NSString * userID= userId;
        NSString *userNickName=loginModel.name;
        NSString * userPortraitUri = loginModel.avatar;
        RCUserInfo *_currentUserInfo =[[RCUserInfo alloc] initWithUserId:userID name:userNickName portrait:userPortraitUri];
        NSLog(@"%@",_currentUserInfo.userId);
        //头像跟新后，在融云的服务器跟新头像
        [RCIM sharedRCIM].currentUserInfo=_currentUserInfo;
        [[RCIM sharedRCIM]
         refreshUserInfoCache:_currentUserInfo
         withUserId:userId];
        [[NSNotificationCenter defaultCenter] postNotificationName:kRongCloudLoginInSuccessNotification object:nil];
        NSLog(@"[RCIM sharedRCIM].currentUserInfo=%@",[RCIM sharedRCIM].currentUserInfo.userId);
        NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
        dispatch_async(dispatch_get_main_queue(), ^{
            int unreadMsgCount = [[RCIMClient sharedRCIMClient] getUnreadCount:@[
                                                                                 @(ConversationType_PRIVATE),
                                                                                 @(ConversationType_CUSTOMERSERVICE),
                                                                                 ]];
            if ([self.window.rootViewController isKindOfClass:[WMTabBarController class]]) {
                UIWindow *window=[AppDelegate sharedAppDelegate].window;
                WMTabBarController * tabBarController = (WMTabBarController *)window.rootViewController;
                [tabBarController setTabBarNmuber:[NSString stringWithFormat:@"%d",unreadMsgCount]];
            } else{
                //广告页和登录页
                NSString *unreadMsgCountStr = [NSString stringWithFormat:@"%d", unreadMsgCount];
                [[NSUserDefaults standardUserDefaults] setObject:unreadMsgCountStr forKey:@"SetUnreadMsgCount"];
            }
        });
    } error:^(RCConnectErrorCode status) {
        NSLog(@"登陆的错误码为:%ld", (long)status);
    } tokenIncorrect:^{
        //token过期或者不正确。
        //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
        //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
        NSLog(@"token错误");
    }];
}
#pragma mark--RCIMReceiveMessageDelegate
- (void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left{
    
    //首先判断这个消息是不是 医生端的命令消息
    if ([message.objectName isEqualToString:@"RC:CmdMsg"]) {
        //获取发送者的ID
        NSString *senderUserId=message.senderUserId;
        //获取消息体
        RCMessageContent *content=message.content;
        RCCommandMessage *message=(RCCommandMessage *)content;
        
        NSString *data=  message.data;
        NSDictionary *dic=  [WMJSONUtil JSONObjectWithString:message.data failureHander:nil];
        if ([[dic objectForKey:@"type_flag"]isEqualToString:@"10002"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kRongCloudAuthenticationMessageNotification object:nil];
        }
        if ([[dic objectForKey:@"type_flag"]isEqualToString:@"10001"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kRongCloudAuthenticationMessageNotification object:nil];
        }
        //消息来了 如果在聊天页面时候就发出通知 停止聊天
        [[NSNotificationCenter defaultCenter] postNotificationName:kRongCloudFinishConversationNotification object:nil];
        
    } else {
        LoginModel * loginModel = [WMLoginCache getMemoryLoginModel];
        
        if (message.conversationType == ConversationType_PRIVATE && [message.targetId isEqualToString:@"system000004"]) {
            //一问医答
            
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[NSString stringWithFormat:@"functionCode1001%@",loginModel.phone]];
            [[NSUserDefaults standardUserDefaults] synchronize];
            NSNotification *notification =[NSNotification notificationWithName:@"InfoNotification" object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        } else if (message.conversationType == ConversationType_PRIVATE){
            //咨询服务
            
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[NSString stringWithFormat:@"functionCode1002%@",loginModel.phone]];
            [[NSUserDefaults standardUserDefaults] synchronize];
            NSNotification *notification =[NSNotification notificationWithName:@"InfoNotification" object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        } else if (message.conversationType == ConversationType_GROUP){
            //群聊
            //医疗圈红点设置
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[NSString stringWithFormat:@"functionCode1003%@",loginModel.phone]];
            [[NSUserDefaults standardUserDefaults] synchronize];
            NSNotification *notification =[NSNotification notificationWithName:@"InfoNotification" object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        }
        int unreadMsgCount = [[RCIMClient sharedRCIMClient] getUnreadCount:@[
                                                                             @(ConversationType_PRIVATE),
                                                                             @(ConversationType_CUSTOMERSERVICE),
                                                                             ]];
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.window.rootViewController isKindOfClass:[WMTabBarController class]]) {
                UIWindow *window=[AppDelegate sharedAppDelegate].window;
                WMTabBarController * tabBarController = (WMTabBarController *)window.rootViewController;
                [tabBarController setTabBarNmuber:[NSString stringWithFormat:@"%d",unreadMsgCount]];
            } else{
                //广告页和登录页
                NSString *unreadMsgCountStr = [NSString stringWithFormat:@"%d", unreadMsgCount];
                [[NSUserDefaults standardUserDefaults] setObject:unreadMsgCountStr forKey:@"SetUnreadMsgCount"];
            }
        });
    }
}

#pragma mark--RCIMConnectionStatusDelegate
- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status{
    //这里最好加上强交互，不让用户点击，在注销期间
    if (status==ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self loginUnVaildWithAlert:YES];
        });
    }
}

#pragma mark--获取推送信息
- (void)getPushMessage:(UIApplication *)application{
    LoginModel * loginModel = [WMLoginCache getMemoryLoginModel];
    if ([loginModel.loginFlag intValue]==0) {
        application.applicationIconBadgeNumber = 0;
        return;
        
    }
    int unreadMsgCount = [[RCIMClient sharedRCIMClient] getUnreadCount:@[
                                                                         @(ConversationType_PRIVATE),
                                                                         @(ConversationType_CUSTOMERSERVICE),
                                                                         ]];
    application.applicationIconBadgeNumber = unreadMsgCount;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (unreadMsgCount) {
            if ([self.window.rootViewController isKindOfClass:[WMTabBarController class]]) {
                UIWindow *window=[AppDelegate sharedAppDelegate].window;
                WMTabBarController * tabBarController = (WMTabBarController *)window.rootViewController;
                [tabBarController setTabBarNmuber:[NSString stringWithFormat:@"%d",unreadMsgCount]];
            } else{
                //广告页和登录页
                NSString *unreadMsgCountStr = [NSString stringWithFormat:@"%d", unreadMsgCount];
                [[NSUserDefaults standardUserDefaults] setObject:unreadMsgCountStr forKey:@"SetUnreadMsgCount"];
            }
        }
    });
}

- (void)registerRCKitDispatchMessageNotification{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didReceiveMessageNotification:) name:RCKitDispatchMessageNotification object:nil];
}

- (void)didReceiveMessageNotification:(NSNotification *)notification{
    
    RCMessage *message = notification.object;
    if (message.messageDirection == MessageDirection_RECEIVE) {
        [UIApplication sharedApplication].applicationIconBadgeNumber =
        [UIApplication sharedApplication].applicationIconBadgeNumber + 1;
    }
}

- (void)getunreadMessageCount:(UIApplication *)application{
    int unreadMsgCount = [[RCIMClient sharedRCIMClient] getUnreadCount:@[
                                                                         @(ConversationType_PRIVATE),
                                                                         @(ConversationType_DISCUSSION),
                                                                         @(ConversationType_APPSERVICE),
                                                                         @(ConversationType_PUBLICSERVICE),
                                                                         @(ConversationType_CUSTOMERSERVICE),
                                                                         @(ConversationType_GROUP)
                                                                         ]];
    application.applicationIconBadgeNumber = unreadMsgCount;
}

- (void)rongCloudIMMessageJump:(NSDictionary *)userInfo{
    if ([userInfo objectForKey:@"rc"]) {
        
        LoginModel * loginModel = [WMLoginCache getMemoryLoginModel];
        if (stringIsEmpty(loginModel.phone)) {
            return;
        }
        
        NSString *tIdString=[[userInfo objectForKey:@"rc"] objectForKey:@"fId"];
        /*
         cType 会话类型。PR 指单聊、 DS 指讨论组、 GRP 指群组、 CS 指客服、SYS 指系统会话、 MC 指应用内公众服务、 MP 指跨应用公众服务。
         */
        //获取消息的来源 我们现在有三种 1：单聊 2：系统消息 3：小脉助手
        NSString *cTypeString=[[userInfo objectForKey:@"rc"] objectForKey:@"cType"];
        if ([self.window.rootViewController isKindOfClass:[WMTabBarController class]]){
            
            WMTabBarController * tabBarController = (WMTabBarController *)self.window.rootViewController;
            WMNavgationController * navController = (WMNavgationController*)tabBarController.viewControllers[tabBarController.selectedIndex];
            if ([cTypeString isEqualToString:@"PR"]) {
                //胎心监护
                if ([tIdString isEqualToString:@"system000003"]) {
                    
                }
                
                //一问医答
                if ([tIdString isEqualToString:@"system000004"]) {
                    
                    
                }
                
                //单聊
                [[WMRCDataManager shareManager] getUserInfoWithUserId:tIdString completion:^(RCUserInfo *userInfo) {
                    
                    //咨询服务
                   
                    
                }];
            } else if ([cTypeString isEqualToString:@"CS"]){
                
            } else if ([cTypeString isEqualToString:@"SYS"]){
                //系统消息  跳转到列表
                //系统消息
               
            } else if ([cTypeString isEqualToString:@"GRP"]){
                //医疗圈红点设置
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"functionCode1003"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                NSNotification *notification =[NSNotification notificationWithName:@"InfoNotification" object:nil userInfo:nil];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
                
            }
        } else{
            //广告页和登录页，还有可能是选择城市的页面
            [[NSUserDefaults standardUserDefaults] setObject:userInfo forKey:@"RongCloudPush"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
}
@end
