//
//  WMOrderListModel.m
//  WMDoctor
//
//  Created by JacksonMichael on 2017/1/3.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMOrderListModel.h"

@implementation WMOrderListModel
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"huanzhetx":@"huanzhetx",
                                                                  @"huanzhexm":@"huanzhexm",
                                                                  @"orderDate":@"orderDate",
                                                                  @"orderFee":@"orderFee",
                                                                  @"orderItem":@"orderItem",
                                                                  @"orderStatus":@"orderStatus",
                                                                  @"sex":@"sex"
                                                                  }];
}
@end

@implementation WMOrderListMainModel
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"totalFee":@"totalFee",
                                                                  @"currentPage":@"currentPage",
                                                                  @"totalPage":@"totalPage",
                                                                  @"orders":@"orders"
                                                                  }];
}
@end


@implementation WMIncomeModel
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"orderDesc":@"orderDesc"
                                                                  }];
}
@end
