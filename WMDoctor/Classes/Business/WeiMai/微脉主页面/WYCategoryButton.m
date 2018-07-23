//
//  WYCategoryButton.m
//  WYNews
//
//  Created by dai.fengyi on 15/6/29.
//  Copyright (c) 2015年 childrenOurFuture. All rights reserved.
//

#import "WYCategoryButton.h"
#define kLabelSideMargin        30
#define kTopicLabelFont         15
@implementation WYCategoryButton
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor colorWithHexString:@"#044F80"] forState:UIControlStateSelected];
        self.titleLabel.font = [UIFont systemFontOfSize:kTopicLabelFont];
    }
    return self;
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
    CGSize size = [title sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:kTopicLabelFont]}];
    size.height = 36;
    size.width = size.width + kLabelSideMargin;
    self.frame = (CGRect){self.bounds.origin, size};
}

//black rgb 000000
//#define kWYRed              [UIColor colorWithRed:221.0/255 green:50.0/255 blue:55.0/255 alpha:1]
//scale表示scrollView.contentOffset.x - label.bounds.origin.x与width的百分比
- (void)setScale:(CGFloat)scale
{
    _scale = scale;
//    NSLog(@"scale is %f", _scale);
//    [self setTitleColor:[UIColor colorWithRed:(scale * (221.0 - 104.0) + 104.0)/255 green:(scale * (50.0 - 104.0) + 104.0)/255 blue:(scale * (55.0 - 104.0) + 104.0)/255 alpha:1] forState:UIControlStateNormal];
//    NSLog(@"\ncolor is %@", self.titleLabel.textColor);
//    self.titleLabel.font = [UIFont systemFontOfSize:kTopicLabelFont * (1 + 0.3 * scale)];
}
@end
