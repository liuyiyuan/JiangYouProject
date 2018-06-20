//
//  WMMessageTypeModel.m
//  WMDoctor
//
//  Created by 茭白 on 2016/12/29.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import "WMMessageTypeModel.h"

@implementation WMMessageTypeModel

@end

@implementation WMMessageDetailModel
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"messageDate":@"messageDate",
                                                                  @"name":@"name",
                                                                  @"noread":@"noread",
                                        @"summary":@"summary",
                                                                  @"type":@"type"
                                                                  }];
}

@end
