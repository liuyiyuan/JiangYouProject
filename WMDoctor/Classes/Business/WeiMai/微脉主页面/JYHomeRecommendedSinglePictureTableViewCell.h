//
//  JYHomeRecommendedSinglePictureTableViewCell.h
//  WMDoctor
//
//  Created by zhenYan on 2018/8/12.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYHomeRecommendedSinglePictureTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *myImageView;

@property (nonatomic, strong) UILabel *titleLabel;//标题

@property (nonatomic, strong) UILabel *fromLabel;//来源

@property (nonatomic, strong) UIButton *topButton;//指定按钮

@property (nonatomic, strong) UIButton *commentsButton;//评论

@property (nonatomic, strong) UILabel *timeLabel;//时间

@property (nonatomic, strong) UIView *lineView;//线
@end
