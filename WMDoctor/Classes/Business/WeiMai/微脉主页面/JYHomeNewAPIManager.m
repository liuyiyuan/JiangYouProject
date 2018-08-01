//
//  JYHomeNewAPIManager.m
//  WMDoctor
//
//  Created by zhenYan on 2018/7/30.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYHomeNewAPIManager.h"

@implementation JYHomeNewAPIManager

- (NSString *)methodName{
    return @"/mobile/follow/list";
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
