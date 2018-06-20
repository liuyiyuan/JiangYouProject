//
//  WMRCIMGroupDataEntity+CoreDataClass.h
//  WMDoctor
//
//  Created by xugq on 2017/8/4.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "RCDGroupInfo.h"


NS_ASSUME_NONNULL_BEGIN

@interface WMRCIMGroupDataEntity : NSManagedObject

/**
 *  以userId为主键 插入一个数据  增
 */
+(void)saveRCGroupInfo:(RCDGroupInfo *)groupInfo;
/**
 *  以userId为键 查询一个数据    查
 */
+(RCDGroupInfo *)selectRCGroupInfo:(NSPredicate *)predicate;
/**
 *  以userId为键 删除一个数据    删
 */
+(void )deleteRCGroupInfo:(NSString *)userId;

/**
 *  以userId为键 跟新一个数据    改
 */
+(void )changeRCGroupInfo:(WMRCIMGroupDataEntity *)dataEntity;

@end

NS_ASSUME_NONNULL_END

#import "WMRCIMGroupDataEntity+CoreDataProperties.h"
