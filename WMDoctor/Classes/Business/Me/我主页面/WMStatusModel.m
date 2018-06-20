//
//  WMStatusModel.m
//  WMDoctor
//
//  Created by JacksonMichael on 2017/5/19.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMStatusModel.h"

@implementation WMStatusModel
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"money":@"money",
                                                                  @"status":@"status",
                                                                  @"popup":@"popup"
                                                                  }];
}
@end
