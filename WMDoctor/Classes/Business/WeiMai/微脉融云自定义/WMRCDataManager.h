//
//  WMRCDataManager.h
//  WMDoctor
//
//  Created by 茭白 on 2016/12/29.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RongIMKit/RongIMKit.h>
#import "WMRCUserInfoEntitys+CoreDataClass.h"

@interface WMRCDataManager : NSObject<RCIMUserInfoDataSource>
/**
 * 单例
 */
+(WMRCDataManager *) shareManager;

- (void)getUserInfoWithUserId:(NSString *)userId
                   completion:(void (^)(RCUserInfo *userInfo))completion;
/**
 * 获取小脉助手信息
 */
-(void)getXiaoMaiHelpInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion;
/**
 * 从本地删除列表信息
 */
-(void)deletePatientInfoFromLocalWithUserId:(NSString *)userId ;
@end
