//
//  WMTotalPatientsAPIManagere.m
//  WMDoctor
//
//  Created by 茭白 on 2017/2/27.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMTotalPatientsAPIManagere.h"

@implementation WMTotalPatientsAPIManagere
-(NSString *)methodName
{
    return URL_GET_CIRCLES_NEW_TOTALPATIENTS;
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
