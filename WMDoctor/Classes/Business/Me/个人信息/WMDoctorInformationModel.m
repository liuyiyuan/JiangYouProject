//
//  WMDoctorInfoModel.m
//  WMDoctor
//
//  Created by JacksonMichael on 2017/3/23.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMDoctorInformationModel.h"

@implementation WMDoctorInformationModel

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"area":@"area",
                                                                  @"officeName":@"officeName",
                                                                  @"skill":@"skill",
                                                                  @"intro":@"intro",
                                                                  @"name":@"name",
                                                                  @"photo":@"photo",
                                                                  @"hospitalName":@"hospitalName",
                                                                  @"certificationStatus":@"certificationStatus",
                                                                  @"title":@"title",
                                                                  @"schoolName":@"schoolName",
                                                                  @"hospitalCode":@"hospitalCode"
                                                                  }];
}

@end
