//
//  WMDoctorEducationsModel.m
//  WMDoctor
//
//  Created by JacksonMichael on 2017/3/23.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMDoctorEducationsModel.h"

@implementation WMDoctorEducationModel
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"schoolGrade":@"schoolGrade",
                                                                  @"gradeName":@"gradeName",
                                                                  @"schoolName":@"schoolName",
                                                                  @"schoolId":@"schoolId",
                                                                  @"specialtyId":@"specialtyId",
                                                                  @"entranceYear":@"entranceYear",
                                                                  @"educationId":@"educationId"
                                                                  }];
}

@end

@implementation WMDoctorEducationsModel
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"doctorEducations":@"doctorEducations"
                                                                  }];
}
@end
