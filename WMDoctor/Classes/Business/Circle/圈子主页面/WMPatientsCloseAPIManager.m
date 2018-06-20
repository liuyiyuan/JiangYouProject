//
//  WMPatientsCloseAPIManager.m
//  WMDoctor
//
//  Created by 茭白 on 2017/1/5.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMPatientsCloseAPIManager.h"

@implementation WMPatientsCloseAPIManager
-(NSString *)methodName
{
    return URL_GET_PATINENTSCLOSE;
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
