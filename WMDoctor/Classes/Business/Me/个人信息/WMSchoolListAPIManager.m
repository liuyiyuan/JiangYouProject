//
//  WMSchoolListAPIManager.m
//  WMDoctor
//
//  Created by JacksonMichael on 2017/3/23.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMSchoolListAPIManager.h"
#import "WMSchoolModel.h"

@implementation WMSchoolListAPIManager
-(NSString *)methodName
{
    return @"/me/account/schools";
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
    
    return [WMSchoolsModel class];
}
@end
