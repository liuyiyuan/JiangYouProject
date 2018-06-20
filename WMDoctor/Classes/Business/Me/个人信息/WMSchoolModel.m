//
//  WMSchoolModel.m
//  WMDoctor
//
//  Created by JacksonMichael on 2017/3/23.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMSchoolModel.h"

@implementation WMSchoolModel

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"schoolId":@"schoolId",
                                                                  @"schoolName":@"schoolName"
                                                                  }];
}

@end

@implementation WMSchoolsModel

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"schools":@"schools"
                                                                  }];
}

@end
