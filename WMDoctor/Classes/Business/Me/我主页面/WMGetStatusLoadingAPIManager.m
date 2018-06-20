//
//  WMGetStatusLoadingAPIManager.m
//  WMDoctor
//
//  Created by JacksonMichael on 2017/5/25.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMGetStatusLoadingAPIManager.h"
#import "WMStatusModel.h"

@implementation WMGetStatusLoadingAPIManager
-(NSString *)methodName
{
    return @"/certification/status";
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
    
    return [WMStatusModel class];
}
@end
