//
//  WMGetJobAPIManager.m
//  WMDoctor
//
//  Created by 茭白 on 2017/5/18.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMGetJobAPIManager.h"

@implementation WMGetJobAPIManager
-(NSString *)methodName
{
    return URL_GET_HOSPITAL_JOB_LEVELS;
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
