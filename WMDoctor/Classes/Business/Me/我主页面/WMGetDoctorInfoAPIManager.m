//
//  WMGetDoctorInfoAPIManager.m
//  WMDoctor
//
//  Created by JacksonMichael on 2016/12/29.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import "WMGetDoctorInfoAPIManager.h"

@implementation WMGetDoctorInfoAPIManager

-(NSString *)methodName
{
    return @"/me/index";
}

- (HTTPMethodType)requestType
{
    return Method_GET;
}

- (LoadingEffertType)loadingEffertType
{
    return LoadingEffertTypeNone;
}

@end
