//
//  WMReplyAwokeView.h
//  WMDoctor
//
//  Created by xugq on 2018/3/23.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WMReplyAwokeView : UIView

@property (nonatomic, strong)UILabel *nameLab;
@property (nonatomic, strong)UILabel *contentLab;

- (void)setValueWithModel:(RCMessageModel *)model;

@end
