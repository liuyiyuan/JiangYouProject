//
//  WMVersionUpgradeAPIManager.m
//  WMDoctor
//
//  Created by choice-ios1 on 17/1/13.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMVersionUpgradeAPIManager.h"
#import "WMUpgradecheckModel.h"

@implementation WMVersionUpgradeAPIManager

-(NSString *)methodName
{
    return @"/users/upgrade_check";
}

- (HTTPMethodType)requestType
{
    return Method_GET;
    
}

- (BOOL)isHideErrorTip{
    return YES;
}

-(Class)classType{
    
    return [WMUpgradecheckModel class];
}

- (LoadingEffertType)loadingEffertType{
    return LoadingEffertTypeNone;
}

@end
