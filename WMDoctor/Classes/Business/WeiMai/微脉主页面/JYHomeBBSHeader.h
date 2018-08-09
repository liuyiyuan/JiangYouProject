//
//  JYHomeBBSHeader.h
//  WMDoctor
//
//  Created by zhenYan on 2018/8/9.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JYBBSHotDelegate <NSObject>

- (void)clickHotViewIndex:(NSIndexPath *)indexPath;

@end

@interface JYHomeBBSHeader : UIView

@property (nonatomic, strong) UILabel *hotLabel;//热门

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIImageView *taskImageView;//每日任务图

@property (nonatomic, strong) UIImageView *shopImageView;//金币商城图

@property (nonatomic, strong) UIImageView *focusImageView;//关注列表

@property (nonatomic, strong) UILabel *recommendedLabel;//精选推荐



@property (nonatomic, weak  ) id<JYBBSHotDelegate> delegate;

@end
