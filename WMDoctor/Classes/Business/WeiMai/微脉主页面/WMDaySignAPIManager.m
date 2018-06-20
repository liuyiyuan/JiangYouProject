//
//  WMDaySignAPIManager.m
//  WMDoctor
//
//  Created by JacksonMichael on 2017/11/29.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMDaySignAPIManager.h"

@implementation WMDaySignAPIManager
-(NSString *)methodName
{
    return @"/score/daily_attendance";
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
    
    return NO;
}
@end
