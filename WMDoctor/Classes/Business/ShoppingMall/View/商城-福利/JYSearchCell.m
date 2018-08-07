//
//  JYSearchCell.m
//  WMDoctor
//
//  Created by xugq on 2018/8/6.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYSearchCell.h"

@implementation JYSearchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.welfareSearchBar setBackgroundImage:[UIImage new]];
    self.welfareSearchBar.layer.masksToBounds = YES;
    self.welfareSearchBar.layer.cornerRadius = 2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
