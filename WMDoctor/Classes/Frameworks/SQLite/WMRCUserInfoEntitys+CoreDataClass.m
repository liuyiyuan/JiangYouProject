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
+ (RCUserInfo*)getPatientEntity:(NSString*)patientId
{
    //统一定义  userId： 是自己的   patientId：是患者的
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId = %@ and selfId = %@",patientId,[RCIM sharedRCIM].currentUserInfo.userId];
    WMRCUserInfoEntitys * infoEntity = [WMRCUserInfoEntitys MR_findFirstWithPredicate:predicate];
    
    RCUserInfo *userInfo=[[RCUserInfo alloc] init];
    userInfo.userId=infoEntity.userId;
    userInfo.name=infoEntity.userName;
    userInfo.portraitUri=infoEntity.userPortraitUrl;
    userInfo.sex=infoEntity.userSex;
    userInfo.type= infoEntity.userType;
    userInfo.vip=infoEntity.userVip;
    userInfo.tagNames = [infoEntity.userTagNames splitStringToArrayWithKeyword:@","];
    
    return userInfo;
}

+ (void)savePatientEntity:(RCUserInfo*)userInfo
{
    //传入参数应为dictionary或者 RCUserInfo
    
    NSManagedObjectContext * context = [NSManagedObjectContext MR_defaultContext];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId = %@ and selfId = %@",userInfo.userId,[RCIM sharedRCIM].currentUserInfo.userId];
    NSArray *  infoEntitys = [WMRCUserInfoEntitys MR_findAllWithPredicate:predicate];
    
    if (infoEntitys.count>0) {
        WMRCUserInfoEntitys * infoEntity=infoEntitys[0];
        infoEntity.userId = userInfo.userId;
        
        infoEntity.userName = userInfo.name;
        infoEntity.userSex = userInfo.sex;
        infoEntity.selfId = [RCIM sharedRCIM].currentUserInfo.userId;
        infoEntity.userPortraitUrl=userInfo.portraitUri;
        infoEntity.userType=userInfo.type;
        infoEntity.userVip= userInfo.vip;
        infoEntity.userTagNames = [userInfo.tagNames appendObjToString];
        
    }
    else{
        
        WMRCUserInfoEntitys * infoEntity = [WMRCUserInfoEntitys MR_createEntityInContext:context];
        infoEntity.userId = userInfo.userId;
        
        infoEntity.userName = userInfo.name;
        infoEntity.userSex = userInfo.sex;
        infoEntity.selfId = [RCIM sharedRCIM].currentUserInfo.userId;
        infoEntity.userPortraitUrl=userInfo.portraitUri;
        infoEntity.userType=userInfo.type;
        infoEntity.userVip=userInfo.vip;
        infoEntity.userTagNames = [userInfo.tagNames appendObjToString];
    }
    
    [context MR_saveToPersistentStoreAndWait];
    
    
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

