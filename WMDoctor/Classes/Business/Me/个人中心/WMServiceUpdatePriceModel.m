//
//  WMServiceUpdatePriceModel.m
//  WMDoctor
//
//  Created by JacksonMichael on 2017/4/19.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMServiceUpdatePriceModel.h"

@implementation WMServiceUpdatePriceModel
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"price":@"price",
                                                                  @"custom":@"custom"
                                                                  }];
}
@end
