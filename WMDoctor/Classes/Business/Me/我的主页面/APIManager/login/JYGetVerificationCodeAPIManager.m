//
//  JYGetVerificationCodeAPIManager.m
//  WMDoctor
//
//  Created by xugq on 2018/7/24.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYGetVerificationCodeAPIManager.h"

@implementation JYGetVerificationCodeAPIManager

- (NSString *)methodName{
    return @"/mobile/user/getValidCode";
}

- (HTTPMethodType)requestType{
    return Method_POST;
}

- (LoadingEffertType)loadingEffertType{
    return LoadingEffertTypeNone;
}

- (HTTPPortType)portType{
    return Port_Jyqss;
}

@end
