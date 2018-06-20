//
//  WMPatientsHealthAPIManager.m
//  WMDoctor
//
//  Created by 茭白 on 2017/1/5.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMPatientsHealthAPIManager.h"
#import "WMPatientsHealthModel.h"
@implementation WMPatientsHealthAPIManager
-(NSString *)methodName
{
    return URL_GET_PATINENTHEALTH;
}

- (HTTPMethodType)requestType
{
    return Method_GET;
    
}
-(Class)classType{
    
    return [WMPatientsHealthModel class];
}
- (BOOL)isHideErrorTip{
    
    return NO;
}

@end
