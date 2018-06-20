//
//  WMDoctorInfoAPIManager.m
//  WMDoctor
//
//  Created by JacksonMichael on 2017/3/23.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMDoctorInfoAPIManager.h"
#import "WMDoctorInformationModel.h"

@implementation WMDoctorInfoAPIManager

-(NSString *)methodName
{
    return @"/me/account/info";
}

- (HTTPMethodType)requestType
{
    return Method_GET;
    
}
- (LoadingEffertType)loadingEffertType
{
    return LoadingEffertTypeDefault;
}
-(Class)classType{
    
    return [WMDoctorInformationModel class];
}

@end
