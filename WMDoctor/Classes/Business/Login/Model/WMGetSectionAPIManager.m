//
//  WMGetSectionAPIManager.m
//  WMDoctor
//
//  Created by 茭白 on 2017/5/17.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMGetSectionAPIManager.h"

@implementation WMGetSectionAPIManager
-(NSString *)methodName
{
    return URL_GET_HOSPITAL_DEPARTMENTS;
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