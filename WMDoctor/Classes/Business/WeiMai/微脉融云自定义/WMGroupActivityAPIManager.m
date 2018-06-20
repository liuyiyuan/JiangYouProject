//
//  WMGroupActivityAPIManager.m
//  WMDoctor
//
//  Created by xugq on 2017/8/8.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMGroupActivityAPIManager.h"

@implementation WMGroupActivityAPIManager

- (NSString *)methodName{
    return @"/message/template_info";
}

- (HTTPMethodType)requestType{
    return Method_GET;
}

@end
