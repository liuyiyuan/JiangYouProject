//
//  WMPersonalInfoModel.m
//  WMDoctor
//
//  Created by JacksonMichael on 2016/12/29.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import "WMPersonalInfoModel.h"

@implementation WMDoctorDetailModel
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"doctorName":@"doctorName",
                                                                  @"keshiName":@"keshiName",
                                                                  @"organization":@"organization",
                                                                  @"photo":@"photo",
                                                                  @"sex":@"sex",
                                                                  @"star":@"star",
                                                                  @"title":@"title"
                                                                  }];
}
@end

@implementation WMPatientCommentsModel
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"commentContent":@"commentContent",
                                                                  @"commentDate":@"commentDate",
                                                                  @"commentTag":@"commentTag",
                                                                  @"phone":@"phone",
                                                                  @"star":@"star"
                                                                  }];
}

@end


@implementation WMPersonalInfoModel
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"commentsNum":@"commentsNum",
                                                                  @"currentPage":@"currentPage",
                                                                  @"totalPage":@"totalPage",
                                                                  @"doctorInfo":@"doctorInfo",
                                                                  @"patientComments":@"patientComments",
                                                                  @"price":@"price",
                                                                  @"pricingPrivilege":@"pricingPrivilege",
                                                                  @"coinType":@"coinType",
                                                                  @"maidouRatio":@"maidouRatio"
                                                                  }];
}
@end

