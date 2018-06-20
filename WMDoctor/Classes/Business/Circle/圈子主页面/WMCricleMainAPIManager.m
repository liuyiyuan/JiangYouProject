//
//  WMCricleMainAPIManager.m
//  WMDoctor
//
//  Created by choice-ios1 on 17/1/16.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMCricleMainAPIManager.h"
#import "WMCricleGroupModel.h"


@implementation WMCricleMainAPIManager

-(NSString *)methodName
{
    return @"/circles/groups";
}

- (HTTPMethodType)requestType
{
    return Method_GET;
    
}
-(Class)classType{
    
    return [WMCricleMainModel class];
}
- (LoadingEffertType)loadingEffertType{
    
    return LoadingEffertTypeNone;
    
}
@end
