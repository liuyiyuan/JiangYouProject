//
//  JYHomeVideoTableViewCell.h
//  WMDoctor
//
//  Created by zhenYan on 2018/8/8.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYHomeVideoTableViewCell : UITableViewCell

@property (nonatomic, strong) UIView *backView;

@property (nonatomic, strong) UIImageView *backImageView;//背景图

@property (nonatomic, strong) UILabel *contentLabel;//内容

@property (nonatomic, strong) UIButton *fromButton;//来源

@property (nonatomic, strong) UIButton *commentsButton;//评论按钮

@property (nonatomic, strong) UIButton *starButton;//星按钮

@property (nonatomic, strong) UIButton *shareButton;//分享按钮

@property (nonatomic, strong) UIButton *deletedButton;//删除按钮

@property (nonatomic, strong) UIButton *playButton;//播放按钮
@end
