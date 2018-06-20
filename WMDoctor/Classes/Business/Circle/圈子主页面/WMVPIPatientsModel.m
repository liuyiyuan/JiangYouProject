//
//  WMVPIPatientsModel.m
//  WMDoctor
//
//  Created by 茭白 on 2017/4/13.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMVPIPatientsModel.h"

@implementation WMVPIPatientsModel
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"vipPatients":@"vipPatients"
                                                                  }];
}


@end
@implementation WMVPIPatientsDetailModel


@end
