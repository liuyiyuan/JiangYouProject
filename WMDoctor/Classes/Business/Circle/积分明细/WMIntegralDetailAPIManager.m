//
//  WMIntegralDetailAPIManager.m
//  WMDoctor
//
//  Created by xugq on 2017/11/22.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMIntegralDetailAPIManager.h"

@implementation WMIntegralDetailAPIManager

-(NSString *)methodName
{
    return @"/score/histories";
}

- (HTTPMethodType)requestType
{
    return Method_GET;
}

- (LoadingEffertType)loadingEffertType
{
    return LoadingEffertTypeNone;
}

@end
