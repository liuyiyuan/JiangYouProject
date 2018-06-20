//
//  WMPatientsInfoAPIManager.m
//  WMDoctor
//
//  Created by 茭白 on 2017/1/4.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMPatientsInfoAPIManager.h"
#import "WMPatientsInfoModel.h"
@implementation WMPatientsInfoAPIManager
-(NSString *)methodName
{
    return URL_GET_PATINENTSINFO;
}

- (HTTPMethodType)requestType
{
    return Method_GET;
    
}
-(Class)classType{
    
    return [WMPatientsInfoModel class];
}
- (BOOL)isHideErrorTip{
    
    return NO;
}

- (LoadingEffertType)loadingEffertType{
    return LoadingEffertTypeNone;
}


@end
