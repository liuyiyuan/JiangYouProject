//
//  WMLoginCheckAPIManager.m
//  WMDoctor
//
//  Created by choice-ios1 on 16/12/28.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import "WMLoginCheckAPIManager.h"

@implementation WMLoginCheckAPIManager

- (NSString *)methodName
{
    return @"/users/login_check";
}

- (HTTPMethodType)requestType
{
    return Method_GET;
}

- (LoadingEffertType)loadingEffertType{
    return LoadingEffertTypeNone;
}

@end
