//
//  WMCricleVIPPatientAPIManager.m
//  WMDoctor
//
//  Created by 茭白 on 2017/4/13.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMCricleVIPPatientAPIManager.h"

@implementation WMCricleVIPPatientAPIManager
-(NSString *)methodName
{
    return URL_GET_CIRCLES_VIP_PATIENTS;
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
