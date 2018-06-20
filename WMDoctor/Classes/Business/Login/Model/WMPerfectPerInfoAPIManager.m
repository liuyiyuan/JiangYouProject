//
//  WMPerfectPerInfoAPIManager.m
//  WMDoctor
//
//  Created by 茭白 on 2017/5/18.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMPerfectPerInfoAPIManager.h"

@implementation WMPerfectPerInfoAPIManager
-(NSString *)methodName
{
    return URL_POST_USER_DOCTOR_REGISTER_SERVICE;
}

- (HTTPMethodType)requestType
{
    return Method_POST;
    
}
-(Class)classType{
    
    return nil;
}
- (BOOL)isHideErrorTip{
    
    return NO;
}

@end
