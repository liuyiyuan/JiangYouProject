//
//  JYHomePictureTableViewCell.h
//  WMDoctor
//
//  Created by jiangqi on 2018/8/7.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYHomePictureTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;//标题

@property (nonatomic, strong) UIImageView *myImageView;//图片

@property (nonatomic, strong) UIButton *likeButton;//赞

@property (nonatomic, strong) UIButton *unLikeButton;//diss

@property (nonatomic, strong) UIButton *commentsButton;//评论

@property (nonatomic, strong) UIButton *starButton;//星星

@property (nonatomic, strong) UIButton *shareButton;//分享按钮

@end
