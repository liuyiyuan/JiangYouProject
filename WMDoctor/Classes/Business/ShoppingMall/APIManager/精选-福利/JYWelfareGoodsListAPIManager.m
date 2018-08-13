//
//  JYWelfareGoodsListAPIManager.m
//  WMDoctor
//
//  Created by xugq on 2018/8/12.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYWelfareGoodsListAPIManager.h"

@implementation JYWelfareGoodsListAPIManager

- (NSString *)methodName{
    return @"/mer/getMerchantListByfl.jspx";
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
