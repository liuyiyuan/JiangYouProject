//
//  WMOrderlistCell.m
//  WMDoctor
//
//  Created by JacksonMichael on 2017/1/3.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMOrderlistCell.h"


@implementation WMOrderlistCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.headImageView.layer.cornerRadius = 25.f;
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setValueForCell:(WMOrderListModel *)model{
    if ([model.sex isEqualToString:@"1"]) {     //男
        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.huanzhetx] placeholderImage:[UIImage imageNamed:@"ic_head_male"]];
    }else if([model.sex isEqualToString:@"2"]){     //女
        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.huanzhetx] placeholderImage:[UIImage imageNamed:@"ic_head_female"]];
    }else{      //阴阳人
        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.huanzhetx] placeholderImage:[UIImage imageNamed:@"ic_head_wtf"]];
    }
    
    self.nameLabel.text = model.huanzhexm;
    self.itemLabel.text = [NSString stringWithFormat:@"订单项目：%@",model.orderItem];
    self.dateLabel.text = [NSString stringWithFormat:@"咨询时间：%@",model.orderDate];
    
    if ([model.orderStatus isEqualToString:@"0"]) {
        self.statusLabel.textColor = [UIColor colorWithHexString:@"18a2ff"];
        self.statusLabel.text = @"待完成";
    }else if ([model.orderStatus isEqualToString:@"2"]){
        self.statusLabel.textColor = [UIColor colorWithHexString:@"999999"];
        self.statusLabel.text = @"已关闭";
    }else if ([model.orderStatus isEqualToString:@"1"]){
        self.statusLabel.textColor = [UIColor colorWithHexString:@"999999"];
        self.statusLabel.text = @"已完成";
    }
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@",model.orderFee];
}

@end
