//
//  RCDGroupInfo.m
//  Micropulse
//
//  Created by 茭白 on 2016/11/11.
//  Copyright © 2016年 iChoice. All rights reserved.
//

#import "RCDGroupInfo.h"

@implementation RCDGroupInfo
#define KEY_RCDGROUP_INFO_NUMBER @"number"

- (instancetype)initWithCoder:(NSCoder *)decoder {
    if (self = [super initWithCoder:decoder]) {
        if (decoder == nil) {
            return self;
        }
        //
        self.number = [decoder decodeObjectForKey:KEY_RCDGROUP_INFO_NUMBER];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [super encodeWithCoder:encoder];
    [encoder encodeObject:self.number forKey:KEY_RCDGROUP_INFO_NUMBER];
}

@end
