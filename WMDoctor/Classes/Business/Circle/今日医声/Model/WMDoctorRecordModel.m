//
//  WMDoctorRecordModel.m
//  WMDoctor
//
//  Created by JacksonMichael on 2017/10/11.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMDoctorRecordModel.h"

@implementation WMDoctorRecordModel
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"groupId":@"groupId",
                                                                  @"timeLength":@"timeLength",
                                                                  @"title":@"title",
                                                                  @"suffix":@"suffix"
                                                                  }];
}
@end
