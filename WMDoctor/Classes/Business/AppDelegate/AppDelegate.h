//
//  AppDelegate.h
//  WMDoctor
//
//  Created by choice-ios1 on 16/12/13.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <GeTuiSdk.h>     // GetuiSdk头文件应用

// iOS10 及以上需导入 UserNotifications.framework
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#endif

@interface AppDelegate : UIResponder <UIApplicationDelegate,GeTuiSdkDelegate,UNUserNotificationCenterDelegate>

@property (strong, nonatomic) UIWindow *window;

//屏幕选择选项
@property (nonatomic,assign) NSInteger allowRotation;

/**
 *  获取 AppDelegate 单例
 */
+ (AppDelegate *)sharedAppDelegate;

/**
 * 登陆失效的操作
 
 @param show 是否显示登陆失效的弹出框
 */
- (void)loginUnVaildWithAlert:(BOOL)show;


@end

