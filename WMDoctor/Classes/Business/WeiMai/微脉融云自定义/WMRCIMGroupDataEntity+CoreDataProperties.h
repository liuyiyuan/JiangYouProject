//
//  WMRCIMGroupDataEntity+CoreDataProperties.h
//  WMDoctor
//
//  Created by xugq on 2017/8/4.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMRCIMGroupDataEntity+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface WMRCIMGroupDataEntity (CoreDataProperties)

+ (NSFetchRequest<WMRCIMGroupDataEntity *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *groupId;
@property (nullable, nonatomic, copy) NSString *groupName;
@property (nullable, nonatomic, copy) NSString *number;
@property (nullable, nonatomic, copy) NSString *portraitUri;
@property (nullable, nonatomic, copy) NSString *userId;

@end

NS_ASSUME_NONNULL_END
