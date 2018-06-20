//
//  WMGetTaskListAPIManager.m
//  WMDoctor
//
//  Created by JacksonMichael on 2017/11/28.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMGetTaskListAPIManager.h"
#import "WMScoreTaskModel.h"

@implementation WMGetTaskListAPIManager
-(NSString *)methodName
{
    return @"/score/tasks";
}

- (HTTPMethodType)requestType
{
    return Method_GET;
}

- (LoadingEffertType)loadingEffertType
{
    return LoadingEffertTypeNone;
}

-(Class)classType{
    
    return [WMScoreTaskModel class];
}
@end
