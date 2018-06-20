//
//  WMServicePriceModel.m
//  WMDoctor
//
//  Created by JacksonMichael on 2017/4/19.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMServicePriceModel.h"


@implementation WMServicePriceModel
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"custom":@"custom",
                                                                  @"openService":@"openService",
                                                                  @"pricingPrivilege":@"pricingPrivilege",
                                                                  @"price":@"price",
                                                                  @"descriptionStr":@"description",
                                                                  @"type":@"type",
                                                                  @"typeId":@"typeId",
                                                                  @"prices":@"prices"
                                                                  }];
}
@end
