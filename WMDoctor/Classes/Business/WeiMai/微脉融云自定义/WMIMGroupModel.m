//
//  WMIMGroupModel.m
//  WMDoctor
//
//  Created by xugq on 2017/8/8.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMIMGroupModel.h"

@implementation WMIMGroupModel

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"groupName":@"groupName",
                                                                  @"groupPicture":@"groupPicture",
                                                                  }];
}

@end
