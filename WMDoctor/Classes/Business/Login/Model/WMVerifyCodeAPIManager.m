//
//  WMVerifyCodeAPIManager.m
//  WMDoctor
//
//  Created by choice-ios1 on 17/1/16.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMVerifyCodeAPIManager.h"

@implementation WMVerifyCodeAPIManager

-(NSString *)methodName
{
    return @"/users/verify_code";
}

- (HTTPMethodType)requestType
{
    return Method_GET;
    
}
@end
