//
//  WMVillagesAPIManager.m
//  WMDoctor
//
//  Created by JacksonMichael on 2017/3/27.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMVillagesAPIManager.h"
#import "WMAreaModel.h"

@implementation WMVillagesAPIManager
-(NSString *)methodName
{
    return @"/me/account/villages";
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
