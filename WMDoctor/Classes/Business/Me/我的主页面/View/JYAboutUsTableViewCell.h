//
//  JYAboutUsTableViewCell.h
//  WMDoctor
//
//  Created by jiangqi on 2018/6/27.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYAboutUsTableViewCell : UITableViewCell
@property(nonatomic,strong)UILabel      *typeLabel;//类型

@property(nonatomic,strong)UIImageView  *arrowImageView;//箭头

@property(nonatomic,strong)UILabel *versionLabel;//版本号

@property(nonatomic,strong)UIView *lineView;//线
@end
