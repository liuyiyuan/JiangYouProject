//
//  WMMyMicroBeanFooterView.m
//  WMDoctor
//
//  Created by xugq on 2017/11/28.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMMyMicroBeanFooterView.h"

@implementation WMMyMicroBeanFooterView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView{
    UIView *awokeBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_width, 47)];
    awokeBottomView.backgroundColor = [UIColor whiteColor];
    [self addSubview:awokeBottomView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_width, 1)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"F4F4F4"];
    [awokeBottomView addSubview:lineView];
    
    UILabel *awokeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, kScreen_width - 30, 47)];
    awokeLabel.textColor = [UIColor colorWithHexString:@"BEBEBE"];
    awokeLabel.font = [UIFont systemFontOfSize:12];
    awokeLabel.text = @"即将推出单节课程兑换，敬请期待！";
    [awokeBottomView addSubview:awokeLabel];
    
    UIView *adviceBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, awokeBottomView.bottom, kScreen_width, 94)];
    adviceBottomView.backgroundColor = [UIColor colorWithHexString:@"F5F5F9"];
    [self addSubview:adviceBottomView];
    
    UILabel *adviceLabel = [[UILabel alloc] initWithFrame:CGRectMake(49, 0, kScreen_width - 98, 94)];
    adviceLabel.textColor = [UIColor colorWithHexString:@"999999"];
    adviceLabel.font = [UIFont systemFontOfSize:12];
    adviceLabel.numberOfLines = 0;
    adviceLabel.textAlignment = NSTextAlignmentCenter;
    adviceLabel.text = @"如果您对积分商城有更好的建议，欢迎通过小脉助手联系我们，让我们做的更好〜";
    [adviceBottomView addSubview:adviceLabel];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
