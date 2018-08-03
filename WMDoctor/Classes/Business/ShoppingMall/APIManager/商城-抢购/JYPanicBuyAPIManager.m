//
//  JYPanicBuyAPIManager.m
//  WMDoctor
//
//  Created by xugq on 2018/8/3.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYPanicBuyAPIManager.h"

@implementation JYPanicBuyAPIManager

- (NSString *)methodName{
    return @"pro/getRushList.jspx";
}

- (HTTPMethodType)requestType{
    return Method_POST;
}

- (LoadingEffertType)loadingEffertType{
    return LoadingEffertTypeDefault;
}

- (HTTPPortType)portType{
    return Port_Jeecmsv;
}

@end
