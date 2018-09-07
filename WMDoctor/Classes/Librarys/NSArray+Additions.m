//
//  NSArray+Additions.m
//  WMDoctor
//
//  Created by xugq on 2018/5/28.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "NSArray+Additions.h"

@implementation NSArray (Additions)

//拼接数组中元素以字符串形式返回
- (NSString *)appendObjToString{
    if (self.count > 0) {
        NSString *resultStr = @"";
        for (NSString *str in self) {
            resultStr = [resultStr stringByAppendingString:str];
            resultStr = [resultStr stringByAppendingString:@","];
        }
        if (resultStr.length > 0) {
            resultStr = [resultStr substringToIndex:[resultStr length] - 1];
            return resultStr;
        }
        return @"";
    }
    return @"";
}

+ (NSMutableArray *)getTagNames:(NSMutableArray *)tags{
    NSMutableArray *tagNames = [NSMutableArray new];
   
    return tagNames;
}


@end
