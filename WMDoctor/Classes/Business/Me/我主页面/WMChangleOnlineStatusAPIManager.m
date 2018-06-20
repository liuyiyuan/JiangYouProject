//
//  WMChangleOnlineStatusAPIManager.m
//  WMDoctor
//
//  Created by JacksonMichael on 2016/12/29.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import "WMChangleOnlineStatusAPIManager.h"

@implementation WMChangleOnlineStatusAPIManager

-(NSString *)methodName
{
    return @"/me/status";
}

- (HTTPMethodType)requestType
{
    return Method_PUT;
    
}

@end
