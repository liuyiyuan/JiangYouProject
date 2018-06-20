//
//  WMSchoolTypeModel.m
//  WMDoctor
//
//  Created by JacksonMichael on 2017/3/23.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMSchoolTypeModel.h"

@implementation WMSchoolTypeModel
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"gradeName":@"gradeName",
                                                                  @"schoolGrade":@"schoolGrade"
                                                                  }];
}

@end

@implementation WMSchoolTypesModel
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"schoolType":@"schoolType"
                                                                  }];
}
@end
