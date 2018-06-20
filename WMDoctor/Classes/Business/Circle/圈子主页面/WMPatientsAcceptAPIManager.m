//
//  WMPatientsAcceptAPIManager.m
//  WMDoctor
//
//  Created by 茭白 on 2017/2/22.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMPatientsAcceptAPIManager.h"

@implementation WMPatientsAcceptAPIManager
-(NSString *)methodName
{
    return URL_GET_CIRCLES_GROUPS_PATIENTS_ACCEPT;
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
