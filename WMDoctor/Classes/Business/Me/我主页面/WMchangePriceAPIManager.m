//
//  WMchangePriceAPIManager.m
//  WMDoctor
//
//  Created by JacksonMichael on 2016/12/30.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import "WMchangePriceAPIManager.h"

@implementation WMchangePriceAPIManager

-(NSString *)methodName
{
    return @"/me/price";
}

- (HTTPMethodType)requestType
{
    return Method_PUT;
    
}

@end
