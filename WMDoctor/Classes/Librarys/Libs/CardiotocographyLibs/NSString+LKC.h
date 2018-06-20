//
//  NSString+LKC.h
//  OctobarBaby
//
//  Created by lazy-thuai on 14-6-5.
//  Copyright (c) 2014年 luckcome. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (LKC)

+ (NSString *)formatSecondsToString:(NSTimeInterval)seconds;
+ (NSString *)formatSecondsToStringWithformat:(NSString *)formatStr timeSeconds:(NSTimeInterval)seconds;


@end
