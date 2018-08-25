//
//  JYCircleHeaderView.h
//  WMDoctor
//
//  Created by zhenYan on 2018/8/25.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYBLoopScrollView.h"
@protocol CircleHeaderViewDelegate <NSObject>

- (void)clickHotViewIndex:(NSIndexPath *)indexPath;

@end

@interface JYCircleHeaderView : UIView



@property (nonatomic, strong) HYBLoopScrollView *loopView;

@property (nonatomic, strong) UILabel *hotLabel;//热门推荐

@property (nonatomic, strong) UILabel *arrowLabel;//箭头

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, weak  ) id<CircleHeaderViewDelegate> delegate;

@end
