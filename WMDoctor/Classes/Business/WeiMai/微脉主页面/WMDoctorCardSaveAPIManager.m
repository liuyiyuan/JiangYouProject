//
//  WMDoctorCardSaveAPIManager.m
//  WMDoctor
//
//  Created by 茭白 on 2017/3/24.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMDoctorCardSaveAPIManager.h"

@implementation WMDoctorCardSaveAPIManager
-(NSString *)methodName
{
    return URL_PUT_PATIENTS_CORD_SEND;
}

- (HTTPMethodType)requestType
{
    return Method_PUT;
    
}
-(Class)classType{
    
    return nil;
}
- (BOOL)isHideErrorTip{
    
    return NO;
}

@end
