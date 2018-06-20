//
//  WMRCIMGroupDataEntity+CoreDataProperties.m
//  WMDoctor
//
//  Created by xugq on 2017/8/4.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMRCIMGroupDataEntity+CoreDataProperties.h"

@implementation WMRCIMGroupDataEntity (CoreDataProperties)

+ (NSFetchRequest<WMRCIMGroupDataEntity *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"WMRCIMGroupDataEntity"];
}

@dynamic groupId;
@dynamic groupName;
@dynamic number;
@dynamic portraitUri;
@dynamic userId;

@end
