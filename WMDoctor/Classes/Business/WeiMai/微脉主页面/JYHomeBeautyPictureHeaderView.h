//
//  JYHomeBeautyPictureHeaderView.h
//  WMDoctor
//
//  Created by zhenYan on 2018/8/7.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JYPictureHotDelegate <NSObject>

- (void)clickHotViewIndex:(NSIndexPath *)indexPath;

@end

@interface JYHomeBeautyPictureHeaderView : UIView

@property (nonatomic, strong) UIImageView *oldPicture;//老照片

@property (nonatomic, strong) UIImageView *bigBeautyJy;//大美江油

@property (nonatomic, strong) UIImageView *BTW;//随手拍

@property (nonatomic, strong) UILabel *hotLabel;//热门推荐

@property (nonatomic, strong) UICollectionView *collection;

@property (nonatomic, weak  ) id<JYPictureHotDelegate> delegate;

@end
