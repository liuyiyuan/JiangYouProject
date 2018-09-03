//
//  JYCompareValidCodeManager.m
//  WMDoctor
//
//  Created by jiangqi on 2018/9/3.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYCompareValidCodeManager.h"

@implementation JYCompareValidCodeManager
- (NSString *)methodName{
    return @"/mobile/user/compareValidCode";
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
