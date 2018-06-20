//
//  WMSchoolTypeListAPIManager.m
//  WMDoctor
//
//  Created by JacksonMichael on 2017/3/23.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMSchoolTypeListAPIManager.h"
#import "WMSchoolTypeModel.h"

@implementation WMSchoolTypeListAPIManager

-(NSString *)methodName
{
    return @"/me/account/school_type";
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
    
    return [WMSchoolTypesModel class];
}

@end
