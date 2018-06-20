//
//  WMMyMicroBeanAPIManager.m
//  WMDoctor
//
//  Created by xugq on 2017/11/27.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMMyMicroBeanAPIManager.h"

@implementation WMMyMicroBeanAPIManager

-(NSString *)methodName
{
    return @"/score/conversions";
}

- (HTTPMethodType)requestType
{
    return Method_GET;
}

- (LoadingEffertType)loadingEffertType
{
    return LoadingEffertTypeDefault;
}

@end
