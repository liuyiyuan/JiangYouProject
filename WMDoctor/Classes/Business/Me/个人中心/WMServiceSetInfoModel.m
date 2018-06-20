//
//  WMServiceSetInfoModel.m
//  WMDoctor
//
//  Created by JacksonMichael on 2017/12/11.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMServiceSetInfoModel.h"

@implementation WMServiceSetInfoModels

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"custom":@"custom",
                                                                  @"inquiryType":@"inquiryType",
                                                                  @"name":@"name",
                                                                  @"openService":@"openService",
                                                                  @"price":@"price",
                                                                  @"prices":@"prices",
                                                                  @"pricingPrivilege":@"pricingPrivilege",
                                                                  @"type":@"type",
                                                                  @"typeId":@"typeId",
                                                                  @"unit":@"unit",
                                                                  @"coinType":@"coinType",
                                                                  @"num":@"num"
                                                                  }];
}

@end

@implementation WMServiceSetInfoModel

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"theDescription":@"description",
                                                                  @"serviceSetting":@"serviceSetting",
                                                                  @"openStatus":@"openStatus"
                                                                  }];
}

@end
