//
//  UIImage+Generate.h
//  Micropulse
//
//  Created by zhangchaojie on 16/5/6.
//  Copyright © 2016年 ENJOYOR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Generate)

/**
 * 根据图片名字 获取不加渲染的原始图片
 * 某些图片会被tabbar/navgationBar等组件渲染，失去了本身的颜色，这个方法是获取图片的原始状态
 
 @param imageName 图片名字
 @return 当前图片的真实图片
 */
+ (UIImage *)getRenderingImageWithName:(NSString*)imageName;
/*
 获取压缩图片，防止内存溢出，尺寸限制300＊300
 */
+ (UIImage *)imageWithImage:(UIImage*)image;

//根据颜色生成一个image对象在指定的区域范围
+ (UIImage *) imageWithColor:(UIColor *)color size:(CGSize)size;
@end
