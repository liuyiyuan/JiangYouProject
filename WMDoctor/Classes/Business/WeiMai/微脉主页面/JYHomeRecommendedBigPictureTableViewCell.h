//
//  JYHomeRecommendedBigPictureTableViewCell.h
//  WMDoctor
//
//  Created by zhenYan on 2018/8/18.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYHomeRecommendedBigPictureTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;//标题

@property (nonatomic, strong) UILabel *fromLabel;//来源

@property (nonatomic, strong) UIImageView *myImageView;//图片

@property (nonatomic, strong) UILabel *advertisingLabel;//广告

@property (nonatomic, strong) UIButton *deleteButton;//删除按钮

@property (nonatomic, strong) UIView *lineView;
@end
