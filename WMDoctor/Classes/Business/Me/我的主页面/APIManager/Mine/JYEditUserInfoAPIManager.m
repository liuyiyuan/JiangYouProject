//
//  JYEditUserInfoAPIManager.m
//  WMDoctor
//
//  Created by xugq on 2018/7/29.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYEditUserInfoAPIManager.h"

@implementation JYEditUserInfoAPIManager

- (NSString *)methodName{
    return @"/jeecmsv9f/jyqss/mobile/user/editUserInfo";
}

- (HTTPMethodType)requestType{
    return Method_POST;
}

- (LoadingEffertType)loadingEffertType{
    return LoadingEffertTypeNone;
}

@end
