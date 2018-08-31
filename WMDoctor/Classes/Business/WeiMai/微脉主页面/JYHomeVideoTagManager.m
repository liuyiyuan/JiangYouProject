//
//  JYHomeVideoTagManager.m
//  WMDoctor
//
//  Created by jiangqi on 2018/8/31.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYHomeVideoTagManager.h"

@implementation JYHomeVideoTagManager

- (NSString *)methodName{
    return @"/mobile/video/title";
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
