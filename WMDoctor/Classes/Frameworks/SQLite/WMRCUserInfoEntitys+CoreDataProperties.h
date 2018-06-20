//
//  WMRCUserInfoEntitys+CoreDataProperties.h
//  
//
//  Created by xugq on 2018/5/28.
//
//

#import "WMRCUserInfoEntitys+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface WMRCUserInfoEntitys (CoreDataProperties)

+ (NSFetchRequest<WMRCUserInfoEntitys *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *selfId;
@property (nullable, nonatomic, copy) NSString *userId;
@property (nullable, nonatomic, copy) NSString *userName;
@property (nullable, nonatomic, copy) NSString *userPortraitUrl;
@property (nullable, nonatomic, copy) NSString *userSex;
@property (nullable, nonatomic, copy) NSString *userType;
@property (nullable, nonatomic, copy) NSString *userVip;
@property (nullable, nonatomic, copy) NSString *userTagNames;

@end

NS_ASSUME_NONNULL_END
