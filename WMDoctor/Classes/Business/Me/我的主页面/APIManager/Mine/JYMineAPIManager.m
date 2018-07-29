//
//  JYMineAPIManager.m
//  WMDoctor
//
//  Created by xugq on 2018/7/29.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYMineAPIManager.h"

@implementation JYMineAPIManager

- (NSString *)methodName{
    return @"/mobile/user/showUserInfoUti";
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
