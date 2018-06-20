//
//  WMFollowUpAPIManager.m
//  WMDoctor
//
//  Created by 茭白 on 2017/2/27.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMFollowUpAPIManager.h"

@implementation WMFollowUpAPIManager
-(NSString *)methodName
{
    return URL_POST_FLUP_SAVEORDER;
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
