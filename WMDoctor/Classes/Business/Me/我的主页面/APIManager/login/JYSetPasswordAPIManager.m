//
//  JYSetPasswordAPIManager.m
//  WMDoctor
//
//  Created by xugq on 2018/7/24.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYSetPasswordAPIManager.h"

@implementation JYSetPasswordAPIManager

- (NSString *)methodName{
    return @"/jeecmsv9f/jyqss/mobile/user/setPassword";
}

- (HTTPMethodType)requestType{
    return Method_POST;
}

- (LoadingEffertType)loadingEffertType{
    return LoadingEffertTypeNone;
}


@end
