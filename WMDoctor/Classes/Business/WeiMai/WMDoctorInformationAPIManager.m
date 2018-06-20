//
//  WMDoctorInformationAPIManager.m
//  WMDoctor
//
//  Created by xugq on 2018/5/29.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "WMDoctorInformationAPIManager.h"

@implementation WMDoctorInformationAPIManager

-(NSString *)methodName
{
    return URL_GET_DOCTOR_NEWS_RECORD;
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
