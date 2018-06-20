//
//  WMDoctorServiceModel.m
//  WMDoctor
//
//  Created by JacksonMichael on 2017/4/19.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMDoctorServiceModel.h"

@implementation WMDoctorMyServiceModel
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"img":@"img",
                                                                  @"name":@"name",
                                                                  @"openService":@"openService",
                                                                  @"price":@"price",
                                                                  @"pricingPrivilege":@"pricingPrivilege",
                                                                  @"type":@"type",
                                                                  @"typeId":@"typeId",
                                                                  @"inquiryType":@"inquiryType",
                                                                  @"prices":@"prices"
                                                                  }];
}
@end

@implementation WMDoctorServiceCommentsModel
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


@implementation WMDoctorServiceModel
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"myServices":@"myServices",
                                                                  @"patientComments":@"patientComments",
                                                                  @"currentPage":@"currentPage",
                                                                  @"commentsNum":@"commentsNum",
                                                                  @"totalPage":@"totalPage"
                                                                  }];
}
@end
