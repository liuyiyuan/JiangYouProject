//
//  JYFastLoginAPIManager.m
//  WMDoctor
//
//  Created by xugq on 2018/7/28.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYFastLoginAPIManager.h"

@implementation JYFastLoginAPIManager

- (NSString *)methodName{
    return @"/mobile/user/loginOnByValidCode";
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
