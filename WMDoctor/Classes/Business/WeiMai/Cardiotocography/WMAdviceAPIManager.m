//
//  WMAdviceAPIManager.m
//  WMDoctor
//
//  Created by JacksonMichael on 2017/7/11.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMAdviceAPIManager.h"

@implementation WMAdviceAPIManager
-(NSString *)methodName
{
    return URL_GET_TANXIN_PUTADVICE;
}

- (HTTPMethodType)requestType
{
    return Method_PUT;
    
}

@end
