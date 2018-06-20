//
//  WMGetPersonalInfoManager.m
//  WMDoctor
//
//  Created by JacksonMichael on 2016/12/29.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import "WMGetPersonalInfoManager.h"
#import "WMPersonalInfoModel.h"

@implementation WMGetPersonalInfoManager

-(NSString *)methodName
{
    return @"/me/portal";
}

- (HTTPMethodType)requestType
{
    return Method_GET;
    
}

-(Class)classType{
    
    return [WMPersonalInfoModel class];
}


@end
