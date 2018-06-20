//
//  WMDoctorCardModel.m
//  WMDoctor
//
//  Created by 茭白 on 2017/3/23.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMDoctorCardModel.h"

@implementation WMDoctorCardModel

+ (JSONKeyMapper *)keyMapper
{
        return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"officeName":@"officeName",
                                                                      @"doctorCards":@"doctorCards"
                                                                      }];
}

@end
@implementation WMDoctorCardDetailModel
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"doctorName":@"doctorName",
                                                                  @"officeId":@"officeId",
                                                                  @"employCode":@"employCode",

                                                                  @"orgId":@"orgId",
                                                                  @"orgName":@"orgName",
                                                                  @"photo":@"photo",
                                                                  @"title":@"title",
                                                                  @"userCode":@"userCode"
                                                                  }];
}


@end

