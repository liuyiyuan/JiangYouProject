//
//  WMPatientsInfoModel.m
//  WMDoctor
//
//  Created by 茭白 on 2017/1/4.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMPatientsInfoModel.h"

@implementation WMPatientsInfoModel
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"xingming":@"xingming",
                                                                  @"xingbie":@"xingbie",
                                                                  @"url":@"url"
                                                                  }];
}

@end
