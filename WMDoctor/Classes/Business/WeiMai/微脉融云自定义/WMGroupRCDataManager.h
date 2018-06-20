//
//  WMGroupRCDataManager.h
//  Micropulse
//
//  Created by 茭白 on 2016/11/10.
//  Copyright © 2016年 iChoice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RongIMKit/RongIMKit.h>
#import "RCDGroupInfo.h"

@interface WMGroupRCDataManager : NSObject<RCIMGroupInfoDataSource,RCIMGroupUserInfoDataSource, RCIMGroupMemberDataSource>
+(WMGroupRCDataManager *) shareManager;
- (void)getGroupInfoWithGroupId:(NSString *)groupId
                     completion:(void (^)(RCDGroupInfo *groupInfo))completion;
#pragma mark--RCIMGroupMemberDataSource
- (void)getAllMembersOfGroup:(NSString *)groupId
                      result:(void (^)(NSArray<NSString *> *userIdList))resultBlock;
@end
