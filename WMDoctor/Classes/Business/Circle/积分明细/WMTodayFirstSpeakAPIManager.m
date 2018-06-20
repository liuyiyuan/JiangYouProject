//
//  WMTodayFirstSpeakAPIManager.m
//  WMDoctor
//
//  Created by xugq on 2017/12/4.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMTodayFirstSpeakAPIManager.h"

@implementation WMTodayFirstSpeakAPIManager

-(NSString *)methodName
{
    return @"/score/daily_speak";
}

- (HTTPMethodType)requestType
{
    return Method_POST;
}

- (LoadingEffertType)loadingEffertType
{
    return LoadingEffertTypeNone;
}

- (BOOL)isHideErrorTip{
    return YES;
}

@end
