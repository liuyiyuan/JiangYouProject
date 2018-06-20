//
//  WMScoreTaskModel.m
//  WMDoctor
//
//  Created by JacksonMichael on 2017/11/28.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMScoreTaskModel.h"

@implementation WMScoreTaskDetailModel
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"buttonText":@"buttonText",
                                                                  @"finishNum":@"finishNum",
                                                                  @"score":@"score",
                                                                  @"status":@"status",
                                                                  @"taskCode":@"taskCode",
                                                                  @"taskDesc":@"taskDesc",
                                                                  @"taskName":@"taskName"
                                                                  }];
}
@end

@implementation WMScoreTaskListModel
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"taskRuleList":@"taskRuleList",
                                                                  @"taskTypeId":@"taskTypeId",
                                                                  @"taskTypeName":@"taskTypeName"
                                                                  }];
}
@end

@implementation WMScoreTaskModel
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"tasks":@"tasks"
                                                                  }];
}
@end
