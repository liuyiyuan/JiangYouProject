//
//  WMEntranceYearListAPIManager.m
//  WMDoctor
//
//  Created by JacksonMichael on 2017/3/23.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMEntranceYearListAPIManager.h"
#import "WMEntranceYearModel.h"

@implementation WMEntranceYearListAPIManager
-(NSString *)methodName
{
    return @"/me/account/entrance_year";
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
    return [WMEntranceYearModel class];
}
@end
