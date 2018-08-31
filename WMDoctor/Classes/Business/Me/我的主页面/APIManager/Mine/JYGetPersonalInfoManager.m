//
//  JYGetPersonalInfoManager.m
//  WMDoctor
//
//  Created by zhenYan on 2018/8/31.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYGetPersonalInfoManager.h"

@implementation JYGetPersonalInfoManager

- (NSString *)methodName{
    return @"/per/getPersonalInfo.jspx";
}

- (HTTPMethodType)requestType{
    return Method_GET;
}

- (LoadingEffertType)loadingEffertType{
    return LoadingEffertTypeNone;
}

- (HTTPPortType)portType{
    return Port_Jeecmsv;
}

@end
