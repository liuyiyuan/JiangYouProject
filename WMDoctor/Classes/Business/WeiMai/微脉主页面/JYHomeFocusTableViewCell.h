//
//  JYHomeFocusTableViewCell.h
//  WMDoctor
//
//  Created by zhenYan on 2018/8/1.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYHomeFocusTableViewCell : UITableViewCell

@property(nonatomic,strong)UIImageView *headerImageView;//头像

@property(nonatomic,strong)UILabel *nameLabel;//名称label

@property(nonatomic,strong)UILabel *timeLabel;//时间label

@property(nonatomic,strong)UIButton *focusButton;//关注按钮

@property(nonatomic,strong)UIButton *deleteButton;//删除按钮

@property(nonatomic,strong)UILabel *contentLabel;//内容label

@property(nonatomic,strong)UIImageView *firstImageView;//第一张图

@property(nonatomic,strong)UIImageView *secondImageView;//第二张图

@property(nonatomic,strong)UIImageView *thirdImageView;//第三张图

@property(nonatomic,strong)UIButton *addressButton;//地址

@property(nonatomic,strong)UILabel *readCountLabel;//阅读数

@property(nonatomic,strong)UIButton *forwardingButton;//转发

@property(nonatomic,strong)UIButton *commentsButton;//评论

@property(nonatomic,strong)UIButton *likedButton;//赞


@end
