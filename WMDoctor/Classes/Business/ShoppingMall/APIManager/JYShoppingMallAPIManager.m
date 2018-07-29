//
//  JYShoppingMallAPIManager.m
//  WMDoctor
//
//  Created by xugq on 2018/7/29.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYShoppingMallAPIManager.h"

@implementation JYShoppingMallAPIManager

- (NSString *)methodName{
    return @"/shop/eventselection.jspx";
}

- (HTTPMethodType)requestType{
    return Method_POST;
}

- (LoadingEffertType)loadingEffertType{
    return LoadingEffertTypeNone;
}

- (HTTPPortType)portType{
    return Port_Jeecmsv;
}

@end
