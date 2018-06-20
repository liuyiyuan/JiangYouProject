//
//  WMMyMicroBeanCell.m
//  WMDoctor
//
//  Created by xugq on 2017/11/27.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMMyMicroBeanCell.h"

@implementation WMMyMicroBeanCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.exchange.layer.borderWidth = 0.5;
    self.exchange.layer.borderColor = [UIColor colorWithHexString:@"18A2FF"].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setValueWithBeanExchangeModel:(WMBeanExchangeModel *)microBean{
    [self.itemImageView sd_setImageWithURL:[NSURL URLWithString:microBean.itemImg] placeholderImage:[UIImage imageNamed:@""] options:SDWebImageAllowInvalidSSLCertificates];
    self.hospital.text = @"专病学院";
    self.title.text = microBean.name;
    self.score.text = microBean.score;
}

@end
