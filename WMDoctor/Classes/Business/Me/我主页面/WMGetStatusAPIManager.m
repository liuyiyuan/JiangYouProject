//
//  WMGetStatusAPIManager.m
//  WMDoctor
//
//  Created by JacksonMichael on 2017/5/19.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMGetStatusAPIManager.h"
#import "WMStatusModel.h"

@implementation WMGetStatusAPIManager
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
    return LoadingEffertTypeNone;
}

-(Class)classType{
    
    return [WMStatusModel class];
}
@end
