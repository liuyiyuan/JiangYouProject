//
//  WMQuestionModel.m
//  WMDoctor
//
//  Created by xugq on 2017/11/21.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMQuestionModel.h"

@implementation WMQuestionModel
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"askTime":@"askTime",
                                                                  @"content":@"content",
                                                                  @"price":@"price",
                                                                  @"questionId":@"questionId",
                                                                  @"state":@"state",
                                                                  }];
}
@end

