//
//  WMShareData.m
//  WMDoctor
//
//  Created by choice-ios1 on 17/1/13.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMShareData.h"

@implementation WMShareData

+ (WMShareData *)shareInstance
{
    static WMShareData * instace = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instace = [[WMShareData alloc] init];
    });
    return instace;
}

@end
