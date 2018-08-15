//
//  JYStoreEvaluatesAPIManager.m
//  WMDoctor
//
//  Created by xugq on 2018/8/15.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYStoreEvaluatesAPIManager.h"

@implementation JYStoreEvaluatesAPIManager

- (NSString *)methodName{
    return @"/mer/getEvaluations.jspx";
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
