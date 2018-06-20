//
//  WMTokenModel.m
//  WMDoctor
//
//  Created by JacksonMichael on 2017/1/12.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMTokenModel.h"

@implementation WMTokenModel
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"weimaipayToken":@"weimaipayToken",
                                                                  @"expiredDateTime":@"expiredDateTime"
                                                                  }];
}
@end
