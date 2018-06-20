//
//  WMArrayUtil.h
//  WMDoctor
//
//  Created by xugq on 2017/8/9.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WMArrayUtil : NSObject

/**
 判断两个数组是否有交集

 @param oneArray 第一个数组
 @param anotherArray 第二个数组
 @return 有返回yes 无返回no
 */
+ (BOOL)contentAnyObjectWithOneArray:(NSArray *)oneArray andAnotherArray:(NSArray *)anotherArray;


/**
 取两个数组的并集

 @param oneArray <#oneArray description#>
 @param anotherArray <#anotherArray description#>
 @return <#return value description#>
 */
+ (NSMutableSet *)getUnionFromTwoArray:(NSArray *)oneArray andAnotherArray:(NSArray *)anotherArray;

@end
