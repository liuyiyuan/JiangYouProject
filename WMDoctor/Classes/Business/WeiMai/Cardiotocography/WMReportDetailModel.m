//
//  WMReportDetailModel.m
//  WMDoctor
//
//  Created by JacksonMichael on 2017/7/6.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMReportDetailModel.h"

@implementation WMReportDetailModel
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"detailsResult":@"detailsResult"
                                                                  }];
}
@end

@implementation WMReportDetailModelResult
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"data":@"data",
                                                                  @"errmsg":@"errmsg"
                                                                  }];
}

@end

@implementation WMReportDetailModelData
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"begindate":@"begindate",
                                                                  @"desc":@"desc",
                                                                  @"enquire":@"enquire",
                                                                  @"fhrpath":@"fhrpath",
                                                                  @"isshow":@"isshow",
                                                                  @"mid":@"mid",
                                                                  @"pname":@"pname",
                                                                  @"puid":@"puid",
                                                                  @"sc":@"sc",
                                                                  @"score":@"score",
                                                                  @"sort":@"sort",
                                                                  @"timelong":@"timelong",
                                                                  @"uid":@"uid",
                                                                  @"uploaddate":@"uploaddate",
                                                                  @"wavpath":@"wavpath",
                                                                  @"medicalhistory":@"medicalhistory"
                                                                  }];
}
@end

@implementation WMReportDetailModelDesc
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"advice":@"advice",
                                                                  @"doctor":@"doctor",
                                                                  @"date":@"date"
                                                                  }];
}

@end

@implementation WMReportDetailModelSc
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"sc4":@"sc4",
                                                                  @"scorer":@"scorer"
                                                                  }];
}

@end
