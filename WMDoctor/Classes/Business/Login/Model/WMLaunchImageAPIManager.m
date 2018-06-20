//
//  WMLaunchImageAPIManager.m
//  WMDoctor
//
//  Created by JacksonMichael on 2016/12/28.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import "WMLaunchImageAPIManager.h"
#import "WMAdvertModel.h"

@implementation WMLaunchImageAPIManager

-(NSString *)methodName
{
    return @"/users/ads";
}

- (HTTPMethodType)requestType
{
    return Method_GET;
    
}

- (BOOL)isHideErrorTip{
    return YES;
}

-(Class)classType{
    
    return [WMAdvertModel class];
}

- (LoadingEffertType)loadingEffertType{
    return LoadingEffertTypeNone;
}

@end
