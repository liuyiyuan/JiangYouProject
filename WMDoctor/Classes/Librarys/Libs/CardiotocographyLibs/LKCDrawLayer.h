//
//  LKCDrawLayer.h
//  OctobarBaby
//
//  Created by lazy-thuai on 14-7-3.
//  Copyright (c) 2014年 luckcome. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  心率曲线绘制层，继承自view哦！！，包含在LKCMonitorView中
 */
@interface LKCDrawLayer : UIView

@property (nonatomic) CGFloat xOffset;  // 绘制起始点的偏移量
@property (strong, nonatomic) NSMutableArray *points; // 胎心率数组  存放的是LKCHeart对象

@property (assign, nonatomic) NSInteger tocoOrNot; //是否带宫缩

@end
