//
//  WMCardInfoModel.m
//  WMDoctor
//
//  Created by JacksonMichael on 2016/12/30.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import "WMCardInfoModel.h"

@implementation WMCardInfoModel
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"doctorName":@"doctorName",
                                                                  @"keshiName":@"keshiName",
                                                                  @"organization":@"organization",
                                                                  @"photo":@"photo",
                                                                  @"sex":@"sex",
                                                                  @"qrcode":@"qrcode",
                                                                  @"title":@"title",
                                                                  @"workerId":@"workerId"
                                                                  }];
}
@end

@implementation WMCardInfoBaseModel
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"cardInfo":@"cardInfo"
                                                                  }];
}
@end
