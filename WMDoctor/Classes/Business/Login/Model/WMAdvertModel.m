//
//  WMAdvertModel.m
//  WMDoctor
//
//  Created by JacksonMichael on 2016/12/29.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import "WMAdvertModel.h"

@implementation WMAdvertModel
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"ads":@"ads"
                                                                  }];
}
@end
