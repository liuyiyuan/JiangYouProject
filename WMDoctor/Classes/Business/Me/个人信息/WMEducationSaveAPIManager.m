//
//  WMEducationSaveAPIManager.m
//  WMDoctor
//
//  Created by JacksonMichael on 2017/3/23.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMEducationSaveAPIManager.h"

@implementation WMEducationSaveAPIManager
-(NSString *)methodName
{
    return @"/me/account/save_education";
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
