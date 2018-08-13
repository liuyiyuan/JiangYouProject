//
//  JYWelfareListCell.m
//  WMDoctor
//
//  Created by xugq on 2018/8/6.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYWelfareListCell.h"

@implementation JYWelfareListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.restaurantFoods.layer.masksToBounds = YES;
    self.restaurantFoods.layer.cornerRadius = 5;
    self.restaurantFoods.layer.borderWidth = 1;
    self.restaurantFoods.layer.borderColor = [UIColor colorWithHexString:@"#AAAAAA"].CGColor;
}

- (void)setValueWithWelfareOneGoodsModel:(JYWelfareOneGoodsModel *)welfareOneGoods{
    self.restaurantName.text = welfareOneGoods.merchantName;
    self.restaurantPopular.text = [NSString stringWithFormat:@"%@人气", welfareOneGoods.hot];
    self.restaurantDistance.text = [NSString stringWithFormat:@"距离我%@", welfareOneGoods.bgp];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
