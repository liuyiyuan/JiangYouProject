//
//  WMDoctorInfoModel.m
//  WMDoctor
//
//  Created by JacksonMichael on 2016/12/29.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import "WMDoctorInfoModel.h"

@implementation WMDoctorInfoModel
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"name":@"name",
                                                                  @"photo":@"photo",
                                                                  @"sex":@"sex",
                                                                  @"status":@"status",
                                                                  @"payVisible":@"payVisible",
                                                                  @"title":@"title",
                                                                  @"star":@"star",
                                                                  @"openRenmai":@"openRenmai",
                                                                  @"certificationStatus":@"certificationStatus"
                                                                  }];
}
@end
