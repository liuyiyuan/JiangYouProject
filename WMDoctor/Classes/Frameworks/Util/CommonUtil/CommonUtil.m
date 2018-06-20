//
//  CommonUtil.m
//  WMDoctor
//
//  Created by 茭白 on 2016/12/21.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import "CommonUtil.h"

@implementation CommonUtil

+ (CGFloat)heightForLabelWithText:(NSString *)content width:(CGFloat)width font:(UIFont *)font{
    NSDictionary * attributes =  @{NSFontAttributeName:font,
                                   NSForegroundColorAttributeName:[UIColor blackColor]};//字体
    CGFloat height = [content boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attributes context:nil].size.height;
    if (height==0) {
        return font.lineHeight;
    }else{
        return height;
    }
}
+ (CGFloat)widthForLabelWithText:(NSString *)content height:(CGFloat)height font:(UIFont *)font{
    NSDictionary * attributes =  @{NSFontAttributeName:font,
                                   NSForegroundColorAttributeName:[UIColor blackColor]};//字体
    CGFloat width = [content boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attributes context:nil].size.width;
    if (height==0) {
        return font.lineHeight;
    }else{
        return width;
    }
    
}
+ (NSString*)utf8WithString:(NSString *)string
{
    return [string stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

+ (CAGradientLayer *)backgroundColorInNavigation:(UIView *)naviBar{
    CAGradientLayer * gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, -20, kScreen_width, 64);
    gradientLayer.startPoint = CGPointMake(0, 0.5);
    gradientLayer.endPoint = CGPointMake(1, 0.5);
    gradientLayer.zPosition = -1;
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"#02ccff"].CGColor,
                             (__bridge id)[UIColor colorWithHexString:@"1ba0ff"].CGColor];
    
    gradientLayer.locations = @[@(0.0f), @(1.0f)];
    return gradientLayer;
}

+ (CAGradientLayer *)backgroundColorInView:(UIView *)view andStartColorStr:(NSString *)startColor andEndColorStr:(NSString *)endColor{
    CAGradientLayer * gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = view.bounds;
    gradientLayer.startPoint = CGPointMake(0, 0.5);
    gradientLayer.endPoint = CGPointMake(1, 0.5);
    gradientLayer.zPosition = -1;
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:startColor].CGColor,
                             (__bridge id)[UIColor colorWithHexString:endColor].CGColor];
    
    gradientLayer.locations = @[@(0.0f), @(1.0f)];
    return gradientLayer;
}

@end
/*
 字符串是否没有内容
 */
inline BOOL stringIsEmpty(NSString* str){
    BOOL ret=NO;
    if(str==nil||[str isKindOfClass:[NSNull class]]){
        ret=YES;
    }else{
        NSString * temp=[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if([temp length]<1){
            ret=YES;
        }
    }
    return ret;
}

inline NSString * strOrEmpty(NSString* str){
    if ([str isKindOfClass:[NSNull class]]) {
        return @"";
    }
    return (str==nil?@"":str);
}


