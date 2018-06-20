//
//  WMDoctorOfficesAPIManager.m
//  WMDoctor
//
//  Created by 茭白 on 2017/3/24.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMDoctorOfficesAPIManager.h"

@implementation WMDoctorOfficesAPIManager
-(NSString *)methodName
{
    return URL_GET_PATIENTS_DOCTOR_OFFICES;
}

- (HTTPMethodType)requestType
{
    return Method_GET;
    
}
-(Class)classType{
    
    return nil;
}
- (BOOL)isHideErrorTip{
    
    return NO;
}

@end
