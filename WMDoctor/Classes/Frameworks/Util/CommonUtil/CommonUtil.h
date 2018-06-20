//
//  CommonUtil.h
//  WMDoctor
//
//  Created by 茭白 on 2016/12/21.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface CommonUtil : NSObject


/**
 *  计算文本的高度

 @param content 文本内容
 @param width 预定宽度
 @param font 字体大小
 @return 固定宽度下文本所占有的高度
 */
+ (CGFloat)heightForLabelWithText:(NSString *)content width:(CGFloat)width font:(UIFont *)font;

/**
 *  计算文本的宽度

 @param content 文本内容
 @param height 预定高度
 @param font 字体大小
 @return 固定高度下文本所占有的宽度
 */
+ (CGFloat)widthForLabelWithText:(NSString *)content height:(CGFloat)height font:(UIFont *)font;
/**
 *  UTF8
 */
+ (NSString*)utf8WithString:(NSString *)string;


/**
 返回统一的NavigationBar的渐变背景色

 @param naviBar 当前navigationBar
 @return CAGradientLayer
 */
+ (CAGradientLayer *)backgroundColorInNavigation:(UIView *)naviBar;


/**
 返回指定渐变颜色的CAGradientLayer

 @param view 将要填充的View（获取其尺寸）
 @param startColor 开始颜色
 @param endColor 结束颜色
 @return CAGradientLayer
 */
+ (CAGradientLayer *)backgroundColorInView:(UIView *)view andStartColorStr:(NSString *)startColor andEndColorStr:(NSString *)endColor;

@end
/*
 如果字符串==nil 返回 @"" 否则返回 str
 */
extern BOOL stringIsEmpty(NSString* str);
extern NSString* strOrEmpty(NSString *str);
