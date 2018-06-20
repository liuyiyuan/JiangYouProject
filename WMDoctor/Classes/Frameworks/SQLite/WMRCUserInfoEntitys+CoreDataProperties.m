//
//  WMRCUserInfoEntitys+CoreDataProperties.m
//  
//
//  Created by xugq on 2018/5/28.
//
//

#import "WMRCUserInfoEntitys+CoreDataProperties.h"

@implementation WMRCUserInfoEntitys (CoreDataProperties)

+ (NSFetchRequest<WMRCUserInfoEntitys *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"WMRCUserInfoEntitys"];
}

@dynamic selfId;
@dynamic userId;
@dynamic userName;
@dynamic userPortraitUrl;
@dynamic userSex;
@dynamic userType;
@dynamic userVip;
@dynamic userTagNames;

@end
