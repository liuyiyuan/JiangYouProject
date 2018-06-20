//
//  LKCDrawLayer.m
//  OctobarBaby
//
//  Created by lazy-thuai on 14-7-3.
//  Copyright (c) 2014年 luckcome. All rights reserved.
//

#import "LKCDrawLayer.h"
#import "LKCHeart.h"
#import "LKCStyleKit.h"

@interface LKCDrawLayer  ()

@property (strong, nonatomic) UIColor *strokeColor;
@property (strong, nonatomic) UIColor *fhrColor;

@property (strong, nonatomic) UIImageView * fhrImg;
@property (strong , nonatomic)  UIImageView * tocoImg;

@end

#define UserDefaults                        [NSUserDefaults standardUserDefaults]
#define RGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]


@implementation LKCDrawLayer

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.strokeColor = [UIColor blackColor];
        self.fhrColor =RGBA(255, 128, 186, 1);
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.strokeColor = [UIColor blackColor];
    self.fhrColor =RGBA(255, 128, 186, 1);
}


// 覆盖drawRect方法，你可以在此自定义绘画和动画，注意里面的函数都是基于c的，不是oc哦
//将所有的数据全部画在view上，这个view会很大，注意不是可见的那么一点点哦
- (void)drawRect:(CGRect)rect
{
    
    CGFloat ratio = 1;
    if ([[UserDefaults objectForKey:@"zoomScale"] isEqualToString:@"4"]) {
        ratio = 1;
    } else if([[UserDefaults objectForKey:@"zoomScale"] isEqualToString:@"2"]) {
        ratio = 2;
    }else if ([[UserDefaults objectForKey:@"zoomScale"] isEqualToString:@"1"]) {
        ratio = 4;
    }
    
    //     NSLog(@"7777777  %ld",(long)self.tocoOrNot);
    //    NSInteger tmpTocoOrNot = self.tocoOrNot;
    NSInteger tmpTocoOrNot = 1;
    CGFloat height = CGRectGetHeight(rect);
    
    NSInteger count = [_points count]/2;
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(ctx, 1);//指定线宽
//    CGContextSetStrokeColorWithColor(ctx, self.strokeColor.CGColor);
    CGContextSetRGBStrokeColor(ctx,0,0,0,1);
    CGFloat x = 0;//150,实时监护时曲线的最右边，右边的一大段都没有曲线绘制
    static CGFloat fhr1_y_old = 0,toco_y_old = 50;
    
    CGFloat tempY = 0;//之前的y值
    CGFloat detal = 0;//两个点的y轴差值
    
    int FMcount = 0;

    for (int i=0; i<count; i++) {
        CGFloat fhr1_y;
        LKCHeart *heart = _points[i*2];
        if(tmpTocoOrNot){//带宫缩
           
            //            fhr1_y = (height * 0.62  )* (210 - heart.rate ) / (210 - 50);
            fhr1_y = (height * 0.615)* (210 - heart.rate) / (210 - 50 ) + 10;
        }else{
            fhr1_y = (height * 0.70 + 49)* (210 - heart.rate ) / (210 );
        }
        
        CGFloat toco_y = (height * 0.70 +4)+height * 0.265 * (100 - heart.tocoValue+6) / (100 + 10);
        x = self.xOffset + i/ratio;
        //画胎心率
        detal =fhr1_y - tempY;
        tempY = fhr1_y;
        
        if (i == 0) {
            CGContextMoveToPoint(ctx, x, fhr1_y);//将端点移到该点，但是不会绘制的，是开始下次绘制的哦
        }else{
            CGContextMoveToPoint(ctx, x-1, fhr1_y_old);
        }
        if((heart.rate < 50)&&(heart.rate)){
            heart.rate = 50;
        }
        //  if(heart.rate > 50){
        if(heart.rate >= 50){
            if (fabs(detal) > 20) {
                CGContextStrokePath(ctx);
                CGContextMoveToPoint(ctx, x, fhr1_y);
            } else {
                CGContextAddLineToPoint(ctx, x, fhr1_y);
            }
        }
        fhr1_y_old = fhr1_y;
        //画宫缩
        if(tmpTocoOrNot){//带宫缩
            if (i == 0) {
                CGContextMoveToPoint(ctx, x, toco_y);
            }else{
                CGContextMoveToPoint(ctx, x-1, toco_y_old);
            }
            CGContextAddLineToPoint(ctx, x, toco_y);
            toco_y_old = toco_y;
            //CGContextMoveToPoint(ctx, x, fhr1_y);
        }
        //  根据胎动类型绘制不同的胎动标记
        NSInteger move = heart.move;
        NSInteger toco = heart.tocoReset;
        if(i > 0 && _points.count > 0)
        {
            LKCHeart *heart_before = _points[i*2 - 1];
            move |=  heart_before.move;
            toco |=  heart_before.tocoReset;
        }
        if (move & HeartMoveTypeAuto) {
//             探头产生的胎动数据
            CGContextStrokePath(ctx);
            [LKCStyleKit drawAuto_fetalWithFrame:CGRectMake(x, 22, 8, 18)];
            CGContextSetStrokeColorWithColor(ctx, self.strokeColor.CGColor);
            CGContextMoveToPoint(ctx,x, fhr1_y);
        } else if (move & HeartMoveTypeManual) {
            FMcount ++ ;
            // 手动添加的胎动数据
            CGContextStrokePath(ctx);
            [LKCStyleKit drawManual_fetalWithFrame:CGRectMake(x, 10, 3, 10)];
            CGContextSetRGBStrokeColor(ctx,0,0,0,1);
            CGContextSetLineWidth(ctx, 1);//指定线宽
        }
        if (toco == 1 ) {//宫缩复位
            CGContextStrokePath(ctx);
            [LKCStyleKit drawTocoResetWithFrame:CGRectMake(x +4, 35, 5, 8)];
            
            CGContextSetRGBStrokeColor(ctx,0,0,0,1);
            CGContextSetLineWidth(ctx, 1);//指定线宽
            CGContextMoveToPoint(ctx,x, fhr1_y);
            
          
            
        }
    }
    [UserDefaults setObject:[NSString stringWithFormat:@"%d",FMcount] forKey:@"FMcount"];
    
    [[NSNotificationCenter defaultCenter ] postNotificationName:@"totalFmCount" object:nil userInfo:@{@"totalFmCount" : [UserDefaults objectForKey:@"FMcount"]}];
    
    CGContextStrokePath(ctx);// 使用之前设置的线宽，颜色等对直线进行涂色并使其可见
 
}

@end
