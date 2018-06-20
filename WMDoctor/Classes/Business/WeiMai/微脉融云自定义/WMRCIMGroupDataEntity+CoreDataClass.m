//
//  WMRCIMGroupDataEntity+CoreDataClass.m
//  WMDoctor
//
//  Created by xugq on 2017/8/4.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMRCIMGroupDataEntity+CoreDataClass.h"

@implementation WMRCIMGroupDataEntity

- (void)setAttributeWithDictionary:(NSDictionary*)dic
{
    
    self.groupId = dic[@"groupId"];
    self.groupName = dic[@"groupName"];
    self.number = dic[@"number"];
    self.portraitUri = dic[@"portraitUri"];
    self.portraitUri = dic[@"userId"];
    
    
}

/**
 *  以userId为主键 插入一个数据  增
 */
+(void)saveRCGroupInfo:(RCDGroupInfo *)groupInfo{
    NSManagedObjectContext * context = [NSManagedObjectContext MR_defaultContext];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"groupId = %@ and userId=%@",groupInfo.groupId,[RCIM sharedRCIM].currentUserInfo.userId];
    NSArray * dataEntitys = [WMRCIMGroupDataEntity MR_findAllWithPredicate:predicate];
    
    if (dataEntitys.count>0) {
        WMRCIMGroupDataEntity * dataEntity=dataEntitys[0];
        dataEntity.groupId = groupInfo.groupId;
        dataEntity.groupName=groupInfo.groupName;
        dataEntity.portraitUri=groupInfo.portraitUri;
        dataEntity.userId= [RCIM sharedRCIM].currentUserInfo.userId;
        
    }
    else{
        
        WMRCIMGroupDataEntity * dataEntity = [WMRCIMGroupDataEntity MR_createEntityInContext:context];
        dataEntity.groupId = groupInfo.groupId;
        dataEntity.groupName=groupInfo.groupName;
        dataEntity.portraitUri=groupInfo.portraitUri;
        dataEntity.userId= [RCIM sharedRCIM].currentUserInfo.userId;
        
    }
    
    [context MR_saveToPersistentStoreAndWait];
    
}
/**
 *  以userId为键 查询一个数据    查
 */
+(RCDGroupInfo *)selectRCGroupInfo:(NSPredicate *)predicate{
    NSParameterAssert(predicate);
    WMRCIMGroupDataEntity * dataEntity = [WMRCIMGroupDataEntity MR_findFirstWithPredicate:predicate];
    if (stringIsEmpty(dataEntity.groupId)) {
        return  nil;
    }
    RCDGroupInfo *groupInfo=[[RCDGroupInfo alloc]init];
    groupInfo.groupId =dataEntity.groupId;
    groupInfo.groupName=dataEntity.groupName;
    groupInfo.portraitUri = dataEntity.portraitUri;
    NSLog(@"取数据 data = %@", groupInfo);
    return groupInfo;
    
}
/**
 *  以userId为键 删除一个数据    删
 */
+(void )deleteRCGroupInfo:(NSString *)userId{
    
}

/**
 *  以userId为键 跟新一个数据    改
 */
+(void )changeRCGroupInfo:(WMRCIMGroupDataEntity *)dataEntity{
    
}

@end
