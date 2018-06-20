//
//  WMGroupActivityModel.m
//  WMDoctor
//
//  Created by xugq on 2017/8/9.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMGroupActivityModel.h"

@implementation WMGroupActivityModel

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"commentNum":@"commentNum",
                                                                  @"desc":@"desc",
                                                                  @"img":@"img",
                                                                  @"liushuihao":@"liushuihao",
                                                                  @"shareImgUrl":@"shareImgUrl",
                                                                  @"title":@"title",
                                                                  @"type":@"type",
                                                                  @"url":@"url"
                                                                  }];
}

@end

