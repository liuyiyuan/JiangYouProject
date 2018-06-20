//
//  WMSaveAllInfoAPIManager.m
//  WMDoctor
//
//  Created by JacksonMichael on 2017/5/23.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMSaveAllInfoAPIManager.h"

@implementation WMSaveAllInfoAPIManager
-(NSString *)methodName
{
    return @"/me/account/content";
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
