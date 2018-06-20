//
//  WMPatientsHealthModel.m
//  WMDoctor
//
//  Created by 茭白 on 2017/1/5.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMPatientsHealthModel.h"

@implementation WMPatientsHealthDetailModel
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"jiuzhensj":@"jiuzhensj",
                                                                  @"keshimc":@"keshimc",
                                                                  @"yiyuanmc":@"yiyuanmc",
                                                                  @"zhenduanmc":@"zhenduanmc",
                                                                  @"jiuzhenmxlb":@"jiuzhenmxlb"
                                                                  }];
}



@end

@implementation WMPatientsHealthModel

@end
