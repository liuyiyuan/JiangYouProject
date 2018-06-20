//
//  WMIndexDataAPIManager.m
//  WMDoctor
//
//  Created by JacksonMichael on 2018/1/30.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "WMIndexDataAPIManager.h"
#import "WMIndexDataModel.h"

@implementation WMIndexDataAPIManager
-(NSString *)methodName
{
    return @"/workbench/index";
}

- (HTTPMethodType)requestType
{
    return Method_GET;
    
}
- (BOOL)isHideErrorTip{
    
    return NO;
}
- (LoadingEffertType)loadingEffertType
{
    return LoadingEffertTypeNone;
}

-(Class)classType{
    
    return [WMIndexDataModel class];
}
@end
