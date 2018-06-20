//
//  WMGroupMemberAPIManager.m
//  WMDoctor
//
//  Created by xugq on 2017/8/14.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMGroupMemberAPIManager.h"

@implementation WMGroupMemberAPIManager

- (NSString *)methodName{
    return @"/circle/group_member_information";
}

- (HTTPMethodType)requestType{
    return Method_GET;
}

@end
