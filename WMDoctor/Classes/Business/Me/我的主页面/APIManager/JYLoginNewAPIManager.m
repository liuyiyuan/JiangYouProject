//
//  JYLoginNewAPIManager.m
//  WMDoctor
//
//  Created by xugq on 2018/7/24.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYLoginNewAPIManager.h"

@implementation JYLoginNewAPIManager

- (NSString *)methodName{
    return @"/jeecmsv9f/jyqss/mobile/user/loginOnByPwd";
}

- (HTTPMethodType)requestType{
    return Method_GET;
}

- (LoadingEffertType)loadingEffertType{
    return LoadingEffertTypeNone;
}


@end
