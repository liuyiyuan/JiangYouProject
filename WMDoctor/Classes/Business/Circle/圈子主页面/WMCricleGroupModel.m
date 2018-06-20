//
//  WMCricleGroupModel.m
//  WMDoctor
//
//  Created by 茭白 on 2016/12/28.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import "WMCricleGroupModel.h"

@implementation WMCricleGroupModel
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"groupName":@"groupName",
                                                                  @"groupPicture":@"groupPicture",
                                                                  @"groupType":@"groupType",
                                                                  @"number":@"number",
                                                                  @"rankVaue":@"rankVaue"
                                                                  }];
}
@end
@implementation WMCricleMainModel
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"list":@"list"}];
}

@end

@implementation WMCricleHomePageModel
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"groups" : @"groups",
                                                                  @"patiens" : @"patiens",
                                                                  @"tagGroups" : @"tagGroups"
                                                                  }];
}

@end

@implementation WMMedicalCircleModel
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"groups" : @"groups"
                                                                  }];
}

@end

