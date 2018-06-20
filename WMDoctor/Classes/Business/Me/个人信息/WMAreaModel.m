//
//  WMAreaModel.m
//  WMDoctor
//
//  Created by JacksonMichael on 2017/3/23.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMAreaModel.h"

@implementation WMAreaModel
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"areaId":@"areaId",
                                                                  @"areaName":@"areaName"
                                                                  }];
}
@end

@implementation WMAreasModel
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"areas":@"areas"
                                                                  }];
}
@end
