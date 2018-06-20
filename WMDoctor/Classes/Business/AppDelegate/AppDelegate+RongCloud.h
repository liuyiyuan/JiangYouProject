//
//  AppDelegate+RongCloud.h
//  WMDoctor
//
//  Created by 茭白 on 2016/12/20.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginModel.h"

@interface AppDelegate (RongCloud)<RCIMReceiveMessageDelegate,RCIMConnectionStatusDelegate,UIAlertViewDelegate>
/**
 *  登录连接融云服务器
 *  参数 loginModel 登录信息
 *  参数 residentModel 注册信息
 */

-(void)setupRongCloudMessageWithLoginModel:(LoginModel *)loginModel;
-(void)getPushMessage:(UIApplication *)application;
-(void)rongCloudIMMessageJump:(NSDictionary *)userInfo;
@end
