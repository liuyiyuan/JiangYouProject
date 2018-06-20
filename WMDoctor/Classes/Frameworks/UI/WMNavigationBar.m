//
//  WMNavigationBar.m
//  Micropulse
//
//  Created by zhangchaojie on 16/6/8.
//  Copyright © 2016年 ENJOYOR. All rights reserved.
//

#import "WMNavigationBar.h"

@implementation WMNavigationBar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    for (UIView *view in self.subviews) {
        view.exclusiveTouch = YES;
    }
}
@end
