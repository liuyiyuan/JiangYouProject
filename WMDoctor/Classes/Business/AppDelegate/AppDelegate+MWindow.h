//
//  AppDelegate+MWindow.h
//  Micropulse
//
//  Created by 茭白 on 2016/11/21.
//  Copyright © 2016年 iChoice. All rights reserved.
//

#import "AppDelegate.h"
@interface AppDelegate (MWindow)



/**
 *
 * 注册魔窗 和跳转事件
 *
 **/
-(void)registerMoWindow;
/**
 *
 * 注册魔窗 和跳转事件
 *
 **/
-(void)jumpTargetPagesWithMLinkWithParams:(NSDictionary *)combinationParams;


@end
