//
//  WMCoreDataUtil.m
//  WMDoctor
//
//  Created by choice-ios1 on 17/1/4.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMCoreDataUtil.h"
#import "WMLoginCache.h"

@implementation WMCoreDataUtil

+ (NSString*)getCurrentUserId
{
    LoginModel * loginModel = [WMLoginCache getMemoryLoginModel];
    NSParameterAssert(loginModel);
    
    return [NSString stringWithFormat:@"%@",loginModel.userId];
}

@end
