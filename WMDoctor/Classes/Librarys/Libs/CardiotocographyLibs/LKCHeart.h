//
//  LKCHeart.h  心率相关
//  OctobarBaby
//
//  Created by lazy-thuai on 14-7-5.
//  Copyright (c) 2014年 luckcome. All rights reserved.
//

#import <Foundation/Foundation.h>

//typedef enum {
//    HeartMoveTypeManual = 1 << 1,      // 手动胎动
//    HeartMoveTypeAuto   = 1 << 2,      // 自动胎动
//} HeartMoveType;
typedef NS_ENUM(NSInteger, HeartMoveType) {
    HeartMoveTypeManual = 1 << 1,      // 手动胎动
    HeartMoveTypeAuto   = 1 << 2,      // 自动胎动
};

/**
 *  单个心率数据模型
 */
@interface LKCHeart : NSObject <NSCoding>

@property (assign, nonatomic) NSInteger rate;       // 心率
@property (assign, nonatomic) NSInteger rate2;       // 心率
@property (assign, nonatomic) NSInteger tocoValue;
@property (assign, nonatomic) NSInteger battValue;
@property (assign, nonatomic) NSInteger signal;     // 蓝牙信号强度
@property (assign, nonatomic) HeartMoveType move;   // 胎动

@property (assign, nonatomic) NSInteger tocoReset; // 宫缩复位

@property (assign, nonatomic) NSInteger isToco; // 是否带宫缩

@end
