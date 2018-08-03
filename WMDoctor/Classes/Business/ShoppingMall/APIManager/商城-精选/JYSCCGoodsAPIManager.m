//
//  JYSCCGoodsAPIManager.m
//  WMDoctor
//
//  Created by xugq on 2018/8/2.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYSCCGoodsAPIManager.h"

@implementation JYSCCGoodsAPIManager

- (NSString *)methodName{
    return @"/shop/merchantAndProductList.jspx";
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
