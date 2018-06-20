//
//  WMIncomeAPIManager.m
//  WMDoctor
//
//  Created by xugq on 2017/10/19.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMIncomeAPIManager.h"
#import "WMOrderListModel.h"
@implementation WMIncomeAPIManager

- (NSString *)methodName{
    return @"/me/order_desc";
}

- (HTTPMethodType)requestType{
    return Method_GET;
}

- (LoadingEffertType)loadingEffertType
{
    return LoadingEffertTypeDefault;
}

@end
