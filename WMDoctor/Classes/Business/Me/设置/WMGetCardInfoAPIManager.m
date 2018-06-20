//
//  WMGetCardInfoAPIManager.m
//  WMDoctor
//
//  Created by JacksonMichael on 2016/12/30.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import "WMGetCardInfoAPIManager.h"

@implementation WMGetCardInfoAPIManager

-(NSString *)methodName
{
    return @"/me/card";
}

- (HTTPMethodType)requestType
{
    return Method_GET;
    
}

@end
