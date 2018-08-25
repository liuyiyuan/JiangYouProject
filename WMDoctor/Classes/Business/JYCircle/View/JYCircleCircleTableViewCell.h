//
//  JYCircleCircleTableViewCell.h
//  WMDoctor
//
//  Created by zhenYan on 2018/8/25.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYCircleCircleTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *headerView;//头像

@property (nonatomic, strong) UIImageView *crownImageView;//皇冠

@property (nonatomic, strong) UILabel *nameLabel;//昵称

@property (nonatomic, strong) UILabel *countLabel;//被赞多少次

@property (nonatomic, strong) UIButton *focusButton;//关注按钮

@property (nonatomic, strong) UIImageView *firstImagView;//第一张图

@property (nonatomic, strong) UIImageView *secondImagView;//第一张图

@property (nonatomic, strong) UIImageView *thirdImagView;//第一张图

@property (nonatomic, strong) UIImageView *fourthImagView;//第一张图

@property (nonatomic, strong) UIView *lineView;//线
@end
