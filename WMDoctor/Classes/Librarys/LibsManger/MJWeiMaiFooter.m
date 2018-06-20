//
//  MJWeiMaiFooter.m
//  WMDoctor
//
//  Created by 茭白 on 2016/12/26.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import "MJWeiMaiFooter.h"

@implementation MJWeiMaiFooter

- (void)prepare
{
    [super prepare];
    //    self.mj_h = 50;
    
    self.refreshingTitleHidden = NO;
    [self setTitle:@"加载中" forState:MJRefreshStateRefreshing];
    [self setTitle:@"" forState:MJRefreshStatePulling];
    [self setTitle:@"" forState:MJRefreshStateIdle];
    self.stateLabel.font = [UIFont systemFontOfSize:12];
    self.stateLabel.textColor = [UIColor lightGrayColor];
    
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=36; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"ic_push_to_refresh_%ld",(unsigned long)i]];
        [refreshingImages addObject:image];
    }
    // 设置正在刷新状态的动画图片
    [self setImages:refreshingImages forState:MJRefreshStateRefreshing];
}

- (void)setImages:(NSArray *)images forState:(MJRefreshState)state
{
    [self setImages:images duration:images.count * 0.020 forState:state];
}

- (void)placeSubviews
{
    [super placeSubviews];
    
    self.gifView.mj_w = self.mj_w * 0.5 - 17;
    self.stateLabel.mj_w = self.mj_w + 17;
}


@end
