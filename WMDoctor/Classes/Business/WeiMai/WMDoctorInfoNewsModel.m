//
//  WMNewsInfomationModel.m
//  WMDoctor
//
//  Created by xugq on 2018/5/29.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "WMDoctorInfoNewsModel.h"

@implementation WMNewsInfomationModel

+(JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc]initWithModelToJSONDictionary:@{
                                                                 @"content":@"content",
                                                                 @"image":@"image",
                                                                 @"introduction":@"introduction",
                                                                 @"newsId":@"newsId",
                                                                 @"shareLink":@"shareLink",
                                                                 @"title":@"title",
                                                                 @"type":@"type"
                                                                 } ];
}


@end

@implementation WMDoctorInfoNewsModel
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"doctorNewsDetailVo":@"doctorNewsDetailVo"
                                                                  }];
}

@end

