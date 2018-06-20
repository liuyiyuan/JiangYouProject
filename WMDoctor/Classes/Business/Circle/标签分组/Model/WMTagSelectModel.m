//
//  WMTagSelectModel.m
//  WMDoctor
//
//  Created by JacksonMichael on 2018/5/23.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "WMTagSelectModel.h"

@implementation WMTagModel

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"flag":@"flag",
                                                                  @"tagId":@"tagId",
                                                                  @"tagName":@"tagName"
                                                                  }];
}

@end

@implementation WMAllTagModel
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"flag":@"flag",
                                                                  @"tagId":@"tagId",
                                                                  @"tagName":@"tagName",
                                                                  @"isSelect":@"isSelect"
                                                                  }];
}
@end

@implementation WMTagSelectModel

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"allTags":@"allTags",
                                                                  @"patientTags":@"patientTags"
                                                                  }];
}

@end

@implementation WMTagModelCustom

@end
