//
//  NSArray+Additions.h
//  WMDoctor
//
//  Created by xugq on 2018/5/28.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Additions)

//拼接数组中元素以字符串形式返回
- (NSString *)appendObjToString;

+ (NSMutableArray *)getTagNames:(NSMutableArray *)tags;

@end
