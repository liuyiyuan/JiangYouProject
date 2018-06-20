
//
//  WMStreetsAPIManger.m
//  WMDoctor
//
//  Created by JacksonMichael on 2017/3/27.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMStreetsAPIManger.h"
#import "WMAreaModel.h"

@implementation WMStreetsAPIManger
-(NSString *)methodName
{
    return @"/me/account/streets";
}

- (HTTPMethodType)requestType
{
    return Method_GET;
    
}
- (LoadingEffertType)loadingEffertType
{
    return LoadingEffertTypeDefault;
}
-(Class)classType{
    
    return [WMAreasModel class];
}
@end
