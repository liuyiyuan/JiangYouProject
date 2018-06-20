//
//  WMPatientStateModel.m
//  WMDoctor
//
//  Created by 茭白 on 2017/1/4.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMPatientStateModel.h"

@implementation WMPatientStateModel
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"dingdanhao":@"dingdanhao",
                                                                  @"xingming":@"xingming",
                                                                  @"xingbie":@"xingbie",
                                                                  @"huifubz":@"huifubz",
                                                                  @"chakanjkdaqbz":@"chakanjkdaqbz",
                                                                  @"url":@"url",
                                                                  @"serviceType":@"serviceType",
                                                                  @"close":@"close",
                                                                  
                                                                  @"status":@"status",
                                                                  @"vip":@"vip",
                                                                  @"tagNames":@"tagNames"
                                                                  }];
}

@end
