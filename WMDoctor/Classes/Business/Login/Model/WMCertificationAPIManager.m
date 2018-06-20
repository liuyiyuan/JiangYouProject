//
//  WMCertificationAPIManager.m
//  WMDoctor
//
//  Created by 茭白 on 2017/5/17.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMCertificationAPIManager.h"

@implementation WMCertificationAPIManager
-(NSString *)methodName
{
    return URL_POST_CERTIFICATION_SAVEINFORMATION;
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
