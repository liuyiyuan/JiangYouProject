//
//  NSStringHelper.m
//  WMDoctor
//
//  Created by xugq on 2017/8/9.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMStringUtil.h"

@implementation WMStringUtil

/**
 *  根据特殊字符分割字符串
 *
 *  @param formerlyStr  原来的字符串
 *  @param corpsStr 特殊字符
 *
 *  @return 返回数组
 */
+ (NSArray *)splitString:(NSString *)formerlyStr corpsStr:(NSString *)corpsStr{
    if ([formerlyStr containsString:corpsStr]) {
        NSArray *array = [formerlyStr componentsSeparatedByString:corpsStr];
        return array;
    }
    return [NSArray new];
}

@end
