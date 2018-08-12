//
//  JYPanicBuyCell.m
//  WMDoctor
//
//  Created by xugq on 2018/8/3.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYPanicBuyCell.h"

@implementation JYPanicBuyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = [UIColor whiteColor];
}

- (void)setValueWithPanicBuyGoodsModel:(JYPanicBuyGoodsModel *)panicBuyGoods{
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:panicBuyGoods.imageUrl]];
    self.goodsName.text = panicBuyGoods.name;
    self.goodsInfo.text = panicBuyGoods.pdesc;
    self.goodsActiveTime.text = panicBuyGoods.finTime;
    self.goodsCouponPrice.text = panicBuyGoods.oriPrice;
    self.goodsPrice.text = panicBuyGoods.price;
}

- (void)setValueWithGroupBuyGoodsModel:(JYGroupBuyOneGoodsModel *)groupBuyGoods{
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:groupBuyGoods.imageUrl]];
    self.goodsName.text = groupBuyGoods.name;
    self.goodsInfo.text = groupBuyGoods.pdesc;
    self.goodsActiveTime.text = groupBuyGoods.finTime;
    self.goodsCouponPrice.text = groupBuyGoods.oriPrice;
    self.goodsPrice.text = groupBuyGoods.price;
}

@end
