//
//  WMCertificationStatusAPIManager.m
//  WMDoctor
//
//  Created by JacksonMichael on 2018/2/9.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "WMCertificationStatusAPIManager.h"

@implementation WMCertificationStatusAPIManager
-(NSString *)methodName
{
    return @"/workbench/certification_status";
}

- (HTTPMethodType)requestType
{
    return Method_GET;
    
}

- (LoadingEffertType)loadingEffertType{
    return LoadingEffertTypeNone;
}



@end
