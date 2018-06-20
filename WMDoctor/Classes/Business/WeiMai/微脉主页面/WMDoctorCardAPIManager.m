//
//  WMDoctorCardAPIManager.m
//  WMDoctor
//
//  Created by 茭白 on 2017/3/23.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMDoctorCardAPIManager.h"

@implementation WMDoctorCardAPIManager
-(NSString *)methodName
{
    return URL_GET_PATIENTS_DOCTOR_DOCTORCARDS;
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
