//
//  JYPersonalInformationHeaderView.h
//  WMDoctor
//
//  Created by jiangqi on 2018/6/27.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYPersonalInformationHeaderView : UIView

@property(nonatomic,strong)UIView *backView;//头像按钮背景灰色

@property(nonatomic,strong)UIButton *imageButton;//头像按钮

@property(nonatomic,strong)UILabel *changeLabel;//修改头像

@property(nonatomic,strong)UIView *lineView;

@end
