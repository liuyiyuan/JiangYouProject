//
//  WMServiceUpdatePriceAPIManager.m
//  WMDoctor
//
//  Created by JacksonMichael on 2017/4/19.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMServiceUpdatePriceAPIManager.h"
#import "WMServiceUpdatePriceModel.h"

@implementation WMServiceUpdatePriceAPIManager
-(NSString *)methodName
{
    return @"/me/update_service_price";
}

- (HTTPMethodType)requestType
{
    return Method_PUT;
}

- (LoadingEffertType)loadingEffertType
{
    return LoadingEffertTypeDefault;
}

-(Class)classType{
    
    return [WMServiceUpdatePriceModel class];
}
@end
