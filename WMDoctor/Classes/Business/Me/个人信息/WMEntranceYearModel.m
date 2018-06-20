//
//  WMEntranceYearModel.m
//  WMDoctor
//
//  Created by JacksonMichael on 2017/3/23.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMEntranceYearModel.h"

@implementation WMEntranceYearModel
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"entranceYears":@"entranceYears"
                                                                  }];
}
@end
