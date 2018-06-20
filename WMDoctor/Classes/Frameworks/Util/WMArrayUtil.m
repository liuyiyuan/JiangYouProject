//
//  WMArrayUtil.m
//  WMDoctor
//
//  Created by xugq on 2017/8/9.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMArrayUtil.h"

@implementation WMArrayUtil

/**
 判断两个数组是否有交集
 
 @param oneArray 第一个数组
 @param anotherArray 第二个数组
 @return 有返回yes 无返回no
 */
+ (BOOL)contentAnyObjectWithOneArray:(NSArray *)oneArray andAnotherArray:(NSArray *)anotherArray{
    NSMutableSet *set1 = [NSMutableSet setWithArray:oneArray];
    NSMutableSet *set2 = [NSMutableSet setWithArray:anotherArray];
    [set1 intersectSet:set2];
    if (set1.count > 0) {
        return YES;
    } else{
        return NO;
    }
}

@end
