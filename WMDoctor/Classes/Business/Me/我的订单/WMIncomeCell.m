//
//  WMIncomeCell.m
//  WMDoctor
//
//  Created by xugq on 2017/10/19.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMIncomeCell.h"

@implementation WMIncomeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (instancetype)init{
    [self setupView];
    return self;
}

- (void)setupView{
    self.numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 10, 10)];
    self.numberLabel.font = [UIFont systemFontOfSize:14];
    self.numberLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.numberLabel.text = @"1.";
    [self addSubview:self.numberLabel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
