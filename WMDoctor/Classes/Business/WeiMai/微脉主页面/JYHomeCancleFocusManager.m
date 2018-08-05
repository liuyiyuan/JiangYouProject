//
//  JYHomeCancleFocusManager.m
//  WMDoctor
//
//  Created by zhenYan on 2018/8/5.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYHomeCancleFocusManager.h"

@implementation JYHomeCancleFocusManager
- (NSString *)methodName{
    return @"/mobile/follow/cancel";
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
