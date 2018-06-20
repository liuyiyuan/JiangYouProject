//
//  UIImage+Generate.m
//  Micropulse
//
//  Created by zhangchaojie on 16/5/6.
//  Copyright © 2016年 ENJOYOR. All rights reserved.
//

#import "UIImage+Generate.h"

@implementation UIImage (Generate)

+ (UIImage *)getRenderingImageWithName:(NSString*)imageName{
    
    UIImage * image = [UIImage imageNamed:imageName];
    
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

//对图片尺寸进行压缩--
+ (UIImage *)imageWithImage:(UIImage*)image{
    CGSize oldSize = CGSizeZero;
    if (image.size.width>300) {
        oldSize = CGSizeMake(300, 300*image.size.height/image.size.width);
    }else{
        oldSize = image.size;
    }
    // Create a graphics image context
    UIGraphicsBeginImageContext(oldSize);
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,oldSize.width,oldSize.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    // End the context
    UIGraphicsEndImageContext();
    // Return the new image.
    return newImage;
}
+ (UIImage *) imageWithColor:(UIColor *)color size:(CGSize)size
{
    //Create a context of the appropriate size
    UIGraphicsBeginImageContextWithOptions(size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    //Build a rect of appropriate size at origin 0,0
    CGRect fillRect = CGRectMake(0, 0, size.width, size.height);
    
    //Set the fill color
    CGContextSetFillColorWithColor(currentContext, color.CGColor);
    
    //Fill the color
    CGContextFillRect(currentContext, fillRect);
    
    //Snap the picture and close the context
    UIImage *colorImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return colorImage;
}
@end
