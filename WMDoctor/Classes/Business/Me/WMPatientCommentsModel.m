//
//  WMPatientCommentsModel.m
//  WMDoctor
//
//  Created by JacksonMichael on 2017/5/16.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMPatientCommentsModel.h"

@implementation WMPatientCommentsNewModel
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"commentsNum":@"commentsNum",
                                                                  @"currentPage":@"currentPage",
                                                                  @"patientComments":@"patientComments",
                                                                  @"totalPage":@"totalPage"
                                                                  }];
}
@end


@implementation WMPatientCommentModel

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"commentContent":@"commentContent",
                                                                  @"commentDate":@"commentDate",
                                                                  @"commentTag":@"commentTag",
                                                                  @"star":@"star",
                                                                  @"phone":@"phone"
                                                                  }];
}

@end
