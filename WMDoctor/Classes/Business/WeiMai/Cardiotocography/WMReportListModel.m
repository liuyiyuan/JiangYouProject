//
//  WMReportListModel.m
//  WMDoctor
//
//  Created by JacksonMichael on 2017/7/5.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMReportListModel.h"

@implementation WMReportListModel
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"age":@"age",
                                                                  @"expectedDate":@"expectedDate",
                                                                  @"name":@"name",
                                                                  @"phone":@"phone",
//                                                                  @"reportId":@"reportId",
                                                                  @"score":@"score",
//                                                                  @"customerId":@"customerId",
                                                                  @"sendTime":@"sendTime",
                                                                  @"mid":@"mid",
                                                                  @"scoringDetails":@"scoringDetails"
                                                                  }];
}
@end


@implementation WMReportListModels

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"reportList":@"reportList"
                                                                  }];
}

@end
