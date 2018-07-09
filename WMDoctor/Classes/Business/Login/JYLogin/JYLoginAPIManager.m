//
//  JYLoginAPIManager.m
//  WMDoctor
//
//  Created by xugq on 2018/7/1.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYLoginAPIManager.h"

@implementation JYLoginAPIManager

- (NSString *)methodName{
    return @"/jeecmsv9f/jyqss/test/api";
}

- (HTTPMethodType)requestType{
    return Method_GET;
}

- (LoadingEffertType)loadingEffertType{
    return LoadingEffertTypeNone;
}

@end
