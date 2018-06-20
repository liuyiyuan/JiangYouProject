//
//  WMQuestionDetailModel.m
//  WMDoctor
//
//  Created by JacksonMichael on 2017/11/24.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMQuestionDetailModel.h"

@implementation WMQuestionDetailInfoModel
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"answerContent":@"answerContent",
                                                                  @"content":@"content",
                                                                  @"departmentName":@"departmentName",
                                                                  @"doctorImage":@"doctorImage",
                                                                  @"doctorName":@"doctorName",
                                                                  @"organizationName":@"organizationName",
                                                                  @"price":@"price",
                                                                  @"pritureIndexs":@"pritureIndexs",
                                                                  @"questionId":@"questionId",
                                                                  @"remainingTime":@"remainingTime",
                                                                  @"state":@"state",
                                                                  @"title":@"title",
                                                                  @"freezeTime":@"freezeTime"
                                                                  }];
}
@end

@implementation WMQuestionDetailModel
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"doctorQuestionDetailVo":@"doctorQuestionDetailVo"
                                                                  }];
}
@end
