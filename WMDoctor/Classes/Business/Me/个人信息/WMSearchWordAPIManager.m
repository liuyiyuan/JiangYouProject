//
//  WMSearchWordAPIManager.m
//  WMDoctor
//
//  Created by JacksonMichael on 2017/4/12.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMSearchWordAPIManager.h"
#import "WMSchoolModel.h"

@implementation WMSearchWordAPIManager
-(NSString *)methodName
{
    return @"/me/account/search_school";
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
