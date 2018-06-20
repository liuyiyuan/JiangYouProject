//
//  WMIndexDataModel.m
//  WMDoctor
//
//  Created by JacksonMichael on 2018/1/30.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "WMIndexDataModel.h"

@implementation WMIndexBanners
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"theID":@"id",
                                                                  @"img":@"img",
                                                                  @"subject":@"subject",
                                                                  @"url":@"url"
                                                                  }];
}

@end

@implementation WMFunctionEntries
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"code":@"code",
                                                                  @"hot":@"hot",
                                                                  @"icon":@"icon",
                                                                  @"linkParam":@"linkParam",
                                                                  @"linkType":@"linkType",
                                                                  @"name":@"name",
                                                                  @"openFlag":@"openFlag"
                                                                  }];
}

@end

@implementation WMGridEntries
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"code":@"code",
                                                                  @"horizontalCellNum":@"horizontalCellNum",
                                                                  @"hot":@"hot",
                                                                  @"icon":@"icon",
                                                                  @"iconPosition":@"iconPosition",
                                                                  @"linkParam":@"linkParam",
                                                                  @"linkType":@"linkType",
                                                                  @"name":@"name",
                                                                  @"openFlag":@"openFlag",
                                                                  @"verticalCellNum":@"verticalCellNum"
                                                                  }];
}

@end


@implementation WMIndexDataModel
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"banners":@"banners",
                                                                  @"functionEntries":@"functionEntries",
                                                                  @"gridEntries":@"gridEntries"
                                                                  }];
}

@end

@implementation HomeAppModel

@end
