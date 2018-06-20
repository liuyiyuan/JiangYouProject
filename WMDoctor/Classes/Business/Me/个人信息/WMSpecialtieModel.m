//
//  WMSpecialtiesModel.m
//  WMDoctor
//
//  Created by JacksonMichael on 2017/3/23.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMSpecialtieModel.h"

@implementation WMSpecialtieModel

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"specialtyId":@"specialtyId",
                                                                  @"specialtyName":@"specialtyName"
                                                                  }];
}

@end

@implementation WMSpecialtiesModel

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"specialties":@"specialties"
                                                                  }];
}

@end
