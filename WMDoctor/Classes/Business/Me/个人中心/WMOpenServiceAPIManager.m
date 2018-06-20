//
//  WMOpenServiceAPIManager.m
//  WMDoctor
//
//  Created by JacksonMichael on 2017/4/19.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMOpenServiceAPIManager.h"

@implementation WMOpenServiceAPIManager

-(NSString *)methodName
{
    return @"/me/open_service";
}

- (HTTPMethodType)requestType
{
    return Method_PUT;
    
}

- (LoadingEffertType)loadingEffertType
{
    return LoadingEffertTypeDefault;
}

@end
