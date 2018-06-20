//
//  WMIntegralDetailCell.m
//  WMDoctor
//
//  Created by xugq on 2017/11/22.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMIntegralDetailCell.h"

@implementation WMIntegralDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setValueWithIntegral:(WMIntegralModel *)integral{
    self.title.text = integral.scoreName;
    self.time.text = integral.scoreDate;
    self.point.text = [NSString stringWithFormat:@"%@%@", integral.scoreType, integral.score];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
