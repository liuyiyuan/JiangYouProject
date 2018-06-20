//
//  LKCHeart.m
//  OctobarBaby
//
//  Created by lazy-thuai on 14-7-5.
//  Copyright (c) 2014年 luckcome. All rights reserved.
//

#import "LKCHeart.h"

@implementation LKCHeart


/**
 *  自定义的对象呀支持归档，需要实NSCoding协议。
 *  NSCoding协议有两个方法，encodeWithCoder方法对对象的属性数据做编码处理
 *  initWithCoder解码归档数据来初始化对象
 *   实现NSCoding协议后，就能通过NSKeyedArchiver归档
 **/

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.rate = [aDecoder decodeIntegerForKey:@"rate"];
        self.rate2 = [aDecoder decodeIntegerForKey:@"rate2"];
        self.signal = [aDecoder decodeIntegerForKey:@"signal"];
        self.move = [aDecoder decodeIntegerForKey:@"move"];
        self.tocoValue = [aDecoder decodeIntegerForKey:@"tocoValue"];
        self.battValue = [aDecoder decodeIntegerForKey:@"battValue"];
        
        
        self.tocoReset = [aDecoder decodeIntegerForKey:@"tocoreset"];

       self.isToco = [aDecoder decodeIntegerForKey:@"isToco"];

    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:self.rate forKey:@"rate"];
    
    [aCoder encodeInteger:self.rate2 forKey:@"rate2"];
    [aCoder encodeInteger:self.signal forKey:@"signal"];
    [aCoder encodeInteger:self.move forKey:@"move"];
    [aCoder encodeInteger:self.tocoValue forKey:@"tocoValue"];
    [aCoder encodeInteger:self.battValue forKey:@"battValue"];
    [aCoder encodeInteger:self.tocoReset forKey:@"tocoreset"];

    [aCoder encodeInteger:self.isToco forKey:@"isToco"];
}

@end
