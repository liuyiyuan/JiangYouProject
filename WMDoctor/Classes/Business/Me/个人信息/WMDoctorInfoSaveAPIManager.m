//
//  WMDoctorInfoSaveAPIManager.m
//  WMDoctor
//
//  Created by JacksonMichael on 2017/3/27.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMDoctorInfoSaveAPIManager.h"

@implementation WMDoctorInfoSaveAPIManager
-(NSString *)methodName
{
    return @"/me/account/save";
}

- (HTTPMethodType)requestType
{
    return Method_PUT;
    
}
- (LoadingEffertType)loadingEffertType
{
    return LoadingEffertTypeDefault;
}
@end
