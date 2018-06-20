//
//  WMPatientsStateAPIManager.m
//  WMDoctor
//
//  Created by 茭白 on 2017/1/3.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMPatientsStateAPIManager.h"
#import "WMPatientStateModel.h"

@implementation WMPatientsStateAPIManager
-(NSString *)methodName
{
    return URL_GET_PATINENTSTYPE;
}

- (HTTPMethodType)requestType
{
    return Method_GET;
    
}
-(Class)classType{
    return [WMPatientStateModel class];
}
- (BOOL)isHideErrorTip{
    
    return NO;
}

@end
