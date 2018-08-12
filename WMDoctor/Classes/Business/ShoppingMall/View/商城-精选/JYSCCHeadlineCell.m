//
//  JYSCCHeadlineCell.m
//  WMDoctor
//
//  Created by xugq on 2018/8/2.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYSCCHeadlineCell.h"

@implementation JYSCCHeadlineCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setValueWithJYSCCHeadlineModel:(JYSCCHeadlineModel *)headlineModel{
    self.title.text = headlineModel.imageinfo;
    [self.headlineImageView sd_setImageWithURL:[NSURL URLWithString:headlineModel.imageurl]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
