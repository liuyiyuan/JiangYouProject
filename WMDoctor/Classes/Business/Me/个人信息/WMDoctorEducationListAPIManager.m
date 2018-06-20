//
//  WMDoctorEducationListAPIManager.m
//  WMDoctor
//
//  Created by JacksonMichael on 2017/3/23.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMDoctorEducationListAPIManager.h"
#import "WMDoctorEducationsModel.h"

@implementation WMDoctorEducationListAPIManager

-(NSString *)methodName
{
    return @"/me/account/doctor_educations";
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
    
    return [WMDoctorEducationsModel class];
}

@end
