//
//  WMGetServicePriceAPIManager.m
//  WMDoctor
//
//  Created by JacksonMichael on 2017/4/19.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMGetServicePriceAPIManager.h"
#import "WMServicePriceModel.h"

@implementation WMGetServicePriceAPIManager
-(NSString *)methodName
{
    return @"/me/service_prices";
}

- (HTTPMethodType)requestType
{
    return Method_GET;
}

- (LoadingEffertType)loadingEffertType
{
    return LoadingEffertTypeNone;
}

-(Class)classType{
    
    return [WMServicePriceModel class];
}
@end
