//
//  WMServiceSetInfoAPImanager.m
//  WMDoctor
//
//  Created by JacksonMichael on 2017/12/11.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMServiceSetInfoAPImanager.h"
#import "WMServiceSetInfoModel.h"

@implementation WMServiceSetInfoAPImanager
-(NSString *)methodName
{
    return @"/me/doctor_services_setting";
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
    return [WMServiceSetInfoModel class];
}
@end
