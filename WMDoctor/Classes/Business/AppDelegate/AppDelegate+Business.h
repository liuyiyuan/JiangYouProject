//
//  AppDelegate+Business.h
//  WMDoctor
//
//  Created by JacksonMichael on 2016/12/28.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (Business)<UIAlertViewDelegate>


/**
 启动后需要调用的接口
 */
- (void)loadBusinessNetwork;

/**
 *  加载启动广告页数据
 */
- (void)loadLaunchImage;


/**
 * 异步加载升级接口（用于网络切换时候调用）

 @param handler 拿到回调数据 parameter
 */
- (void)syncLoadUpgradeCheck:(void (^)(WMUpgradecheckModel* parameter)) handler;

- (void)applicationWillEnterForegroundBusiness;

@end
