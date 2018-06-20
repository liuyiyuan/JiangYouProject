//
//  WMLoginAPIManager.m
//  WMDoctor
//
//  Created by choice-ios1 on 17/1/16.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMLoginAPIManager.h"

@implementation WMLoginAPIManager

-(NSString *)methodName
{
    return @"/users/login";
}

- (HTTPMethodType)requestType
{
    return Method_POST;
    
}
-(BOOL)isHideErrorTip{
    return YES;
}
@end
