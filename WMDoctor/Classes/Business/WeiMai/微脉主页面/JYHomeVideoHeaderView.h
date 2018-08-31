//
//  JYHomeVideoHeaderView.h
//  WMDoctor
//
//  Created by zhenYan on 2018/8/8.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYBLoopScrollView.h"
@interface JYHomeVideoHeaderView : UIView

@property (nonatomic, strong) UIImageView *myStyle;//我型我秀

@property (nonatomic, strong) UILabel *myStyleLaebl;//我型我秀label

@property (nonatomic, strong) UIImageView *airPicture;//航拍

@property (nonatomic, strong) UILabel *airPictureLaebl;//航拍label

@property (nonatomic, strong) UIImageView *live;//直播

@property (nonatomic, strong) UILabel *liveLaebl;//直播label

@property (nonatomic, strong) NSArray *imageUrls;//轮播图图片地址

@property (nonatomic, strong) NSArray *tagArray;//标签数组

@property (nonatomic, strong) HYBLoopScrollView *loop;//轮播图

@end
