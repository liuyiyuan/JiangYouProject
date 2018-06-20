//
//  WMGetDoctorServiceAPIManager.m
//  WMDoctor
//
//  Created by JacksonMichael on 2017/4/19.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMGetDoctorServiceAPIManager.h"
#import "WMDoctorServiceModel.h"

@implementation WMGetDoctorServiceAPIManager

-(NSString *)methodName
{
    return @"/me/doctor_services";
}

- (HTTPMethodType)requestType
{
    return Method_GET;
    
}

-(Class)classType{
    
    return [WMDoctorServiceModel class];
}


@end
