//
//  WMAreaAPIManager.m
//  WMDoctor
//
//  Created by JacksonMichael on 2017/3/23.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMAreaAPIManager.h"
#import "WMAreaModel.h"

@implementation WMAreaAPIManager
-(NSString *)methodName
{
    return @"/me/account/areas";
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
