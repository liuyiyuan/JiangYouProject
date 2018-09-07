//
//  WMRCUserInfoEntitys+CoreDataClass.m
//  
//
//  Created by xugq on 2018/5/28.
//
//

#import "WMRCUserInfoEntitys+CoreDataClass.h"
#import "NSString+Additions.h"
#import "NSArray+Additions.h"


@implementation WMRCUserInfoEntitys

- (void)setAttributeWithDictionary:(NSDictionary*)dic
{
    
    self.userPortraitUrl = dic[@"userPortraitUrl"];
    self.userSex = dic[@"userSex"];
    self.userName = dic[@"userName"];
    self.userId = dic[@"userId"];
    self.selfId = dic[@"selfId"];
    self.userType = dic[@"userType"];
    self.userVip = dic[@"userVip"];
    self.userTagNames = dic[@"userTagNames"];
}

/**
 *获取数据
 **/


+ (void)savePatientEntity:(RCUserInfo*)userInfo
{
    //传入参数应为dictionary或者 RCUserInfo
    
    
    
    
}
//待测试
+ (void)deletePatientEntity:(NSString*)patientId
{
    /*
     NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId = %@ and patientId = %@",[RCIM sharedRCIM].currentUserInfo.userId,patientId];
     PatientEntity * patientEntity = [PatientEntity MR_findFirstWithPredicate:predicate];
     NSManagedObjectContext *context = [patientEntity managedObjectContext];
     [patientEntity MR_deleteEntityInContext:context];
     [context MR_saveToPersistentStoreAndWait];
     */
}

@end

