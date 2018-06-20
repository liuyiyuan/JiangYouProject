//
//  WMAllReportListModel.m
//  WMDoctor
//
//  Created by JacksonMichael on 2017/7/8.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMAllReportListModel.h"

@implementation WMAllReportListModel
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"allReportsResult":@"allReportsResult"
                                                                  }];
}
@end

@implementation WMAllReportListModels

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"errmsg":@"errmsg",
                                                                  @"items":@"items",
                                                                  @"pagecount":@"pagecount",
                                                                  @"records":@"records"
                                                                  }];
}
@end


@implementation WMAllReportListModelItems

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"advice":@"advice",
                                                                  @"age":@"age",
                                                                  @"bdate":@"bdate",
                                                                  @"bluenum":@"bluenum",
                                                                  @"enquire":@"enquire",
                                                                  @"fname":@"fname",
                                                                  @"mid":@"mid",
                                                                  @"page":@"page",
                                                                  @"pdate":@"pdate",
                                                                  @"pname":@"pname",
                                                                  @"ppid":@"ppid",
                                                                  @"score":@"score",
                                                                  @"tlong":@"tlong",
                                                                  @"tname":@"tname",
                                                                  @"udate":@"udate",
                                                                  @"uid":@"uid"
                                                                  }];
}

@end
