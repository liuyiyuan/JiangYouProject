//
//  WMRCUserInfoEntitys+CoreDataClass.h
//  
//
//  Created by xugq on 2018/5/28.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface WMRCUserInfoEntitys : NSManagedObject
//fetch
+ (RCUserInfo*)getPatientEntity:(NSString*)patientId;

//add & edit  具体业务可能需要根据RCUserInfo数据来提供
+ (void)savePatientEntity:(RCUserInfo*)userInfo;

+(void)deletePatientEntity:(NSString*)patientId;
@end

NS_ASSUME_NONNULL_END

#import "WMRCUserInfoEntitys+CoreDataProperties.h"
