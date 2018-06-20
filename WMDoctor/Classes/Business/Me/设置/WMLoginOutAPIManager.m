//
//  WMLoginOutAPIManager.m
//  WMDoctor
//  退出登录接口
//  Created by JacksonMichael on 2017/1/3.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMLoginOutAPIManager.h"

@implementation WMLoginOutAPIManager

-(NSString *)methodName
{
    return @"/users/logout";
}

- (HTTPMethodType)requestType
{
    return Method_GET;
    
}

@end
