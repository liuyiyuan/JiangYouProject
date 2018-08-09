//
//  JYHomeBBSTableViewCell.h
//  WMDoctor
//
//  Created by zhenYan on 2018/8/9.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYHomeBBSTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *myImageView;//图片

@property (nonatomic, strong) UILabel *titleLabel;//标题

@property (nonatomic, strong) UILabel *contentLabel;//内容

@property (nonatomic, strong) UILabel *hasAddLabel;//已关注

@property (nonatomic, strong) UIButton *addButton;//关注按钮

@property (nonatomic, strong) UIView *lineView;//线

@end
