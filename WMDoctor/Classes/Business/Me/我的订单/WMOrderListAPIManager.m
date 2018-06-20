//
//  WMOrderListAPIManager.m
//  WMDoctor
//
//  Created by JacksonMichael on 2017/1/3.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMOrderListAPIManager.h"
#import "WMOrderListModel.h"

@implementation WMOrderListAPIManager

-(NSString *)methodName
{
    return @"/me/order";
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
    
    return [WMOrderListMainModel class];
}


@end
