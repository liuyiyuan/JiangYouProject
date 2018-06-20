//
//  WMGroupMessageAPIManager.m
//  WMDoctor
//
//  Created by xugq on 2017/8/4.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMGroupMessageAPIManager.h"

@implementation WMGroupMessageAPIManager

- (NSString *)methodName{
    return @"/circle/group_information";
}

- (HTTPMethodType)requestType{
    return Method_GET;
}

@end
