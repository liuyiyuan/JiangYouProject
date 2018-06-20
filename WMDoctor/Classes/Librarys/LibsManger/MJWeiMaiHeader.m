//
//  MJWeiMaiHeader.m
//  WMDoctor
//
//  Created by 茭白 on 2016/12/26.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import "MJWeiMaiHeader.h"
@interface MJWeiMaiHeader ()

@end
@implementation MJWeiMaiHeader
- (void)prepare
{
    [super prepare];
    
    //    self.mj_h = 50;
    //隐藏时间
    self.lastUpdatedTimeLabel.hidden = YES;
    self.stateLabel.hidden = YES;
    
    // 设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=19; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"ic_pull_to_refresh_%ld",(unsigned long)i]];
        [idleImages addObject:image];
    }
    [self setImages:idleImages forState:MJRefreshStateIdle];
    
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 21; i<=56; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"ic_pull_to_refresh_%ld",(unsigned long)i]];
        [refreshingImages addObject:image];
    }
    // 设置正在刷新状态的动画图片
    [self setImages:refreshingImages forState:MJRefreshStateRefreshing];
}

- (void)setImages:(NSArray *)images forState:(MJRefreshState)state
{
    [self setImages:images duration:images.count * 0.02 forState:state];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
