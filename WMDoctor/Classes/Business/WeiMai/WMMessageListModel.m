//
//  WMMessageListModel.m
//  WMDoctor
//
//  Created by 茭白 on 2016/12/29.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import "WMMessageListModel.h"


@implementation WMMessageListDetailModel
+(JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc]initWithModelToJSONDictionary:@{
                                    @"messageDate":@"messageDate",
                                    @"messageImg":@"messageImg",
                                     @"messageSummary":@"messageSummary",
                                     @"messageTitle":@"messageTitle",
                                     @"miniVersion":@"miniVersion",
                                     @"skipTag":@"skipTag",
                                     @"messageUrl":@"messageUrl"
                                                                 } ];
}
@end

@implementation WMMessageListModel
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"messageList":@"messageList",
                                                                  @"totalPage":@"totalPage",
                                                                  @"currentPage":@"currentPage"
                                                                  }];
}

@end
