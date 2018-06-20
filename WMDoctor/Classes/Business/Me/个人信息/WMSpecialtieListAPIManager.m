//
//  WMSpecialtieListAPIManager.m
//  WMDoctor
//
//  Created by JacksonMichael on 2017/3/23.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMSpecialtieListAPIManager.h"
#import "WMSpecialtieModel.h"

@implementation WMSpecialtieListAPIManager
-(NSString *)methodName
{
    return @"/me/account/specialties";
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
    
    return [WMSpecialtiesModel class];
}
@end
