//
//  WMAvatarAPIManager.m
//  WMDoctor
//  头像上传
//  Created by JacksonMichael on 2017/5/23.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMAvatarAPIManager.h"

@implementation WMAvatarAPIManager
-(NSString *)methodName
{
    return @"/me/account/avatar";
}

- (HTTPMethodType)requestType
{
    return Method_POST;
    
}
- (LoadingEffertType)loadingEffertType
{
    return LoadingEffertTypeDefault;
}

@end
