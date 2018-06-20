//
//  AppDelegate+GeTui.h
//  Micropulse
//
//  Created by 茭白 on 16/7/26.
//  Copyright © 2016年 ENJOYOR. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (GeTui)


/**
 *  收到推送之后的处理
 *
 *  @param userInfo 推送传回的数据
 */
//- (void)goRemoteNotificationListWithMessage:(NSDictionary*)userInfo;


-(void)goListByPushInfo:(NSDictionary *)pushinfoDic state:(NSInteger)state;


@end
