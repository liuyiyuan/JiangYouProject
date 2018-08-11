//
//  JYSCCGoodsCell.m
//  WMDoctor
//
//  Created by xugq on 2018/8/2.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYSCCGoodsCell.h"

@implementation JYSCCGoodsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"F2F2F2"];
}

- (void)setValueWithGoodsModel:(JYSCCGoodsModel *)goods{
    [self.storeImageView sd_setImageWithURL:[NSURL URLWithString:goods.merchantPic]];
    self.goodsScrollView.contentSize = CGSizeMake(10 + 117 * goods.merList.count, 110);
    self.goodsScrollView.backgroundColor = [UIColor whiteColor];
    self.goodsScrollView.layer.masksToBounds = YES;
    self.goodsScrollView.layer.cornerRadius = 5;
    float view_x = 10;
    float view_y = 11;
    float view_w = 117;
    float view_h = 144;
    
    for (int i = 0; i < goods.merList.count; i ++) {
        JYSCCOneGoodModel *oneGoods = goods.merList[i];
        view_x = 10 + view_w * i;
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(view_x, view_y, view_w, view_h)];
        
        UIButton *imgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        imgBtn.frame = CGRectMake(0, 0, 105, 92);
//        [imgBtn setImage:[UIImage imageNamed:@"scc_oneGoods"] forState:UIControlStateNormal];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:oneGoods.productPic]] scale:1];
        [imgBtn setImage:image forState:UIControlStateNormal];
        imgBtn.tag = i;
        [imgBtn addTarget:self action:@selector(oneGoodsBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:imgBtn];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, imgBtn.bottom + 6, bottomView.width, 11)];
        titleLabel.text = oneGoods.productTitle;
        titleLabel.textColor = [UIColor colorWithHexString:@"#000000"];
        titleLabel.font = [UIFont systemFontOfSize:11];
        [bottomView addSubview:titleLabel];
        
        UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, titleLabel.bottom + 5, bottomView.width - 20, 6)];
        countLabel.text = oneGoods.productSpecification;
        countLabel.textColor = [UIColor colorWithHexString:@"#8B8A8A"];
        countLabel.font = [UIFont systemFontOfSize:8];
        [bottomView addSubview:countLabel];
        
        UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, countLabel.bottom + 7, bottomView.width - 20, 12)];
        priceLabel.text = [NSString stringWithFormat:@"$%@", oneGoods.productPrice];
        priceLabel.textColor = [UIColor colorWithHexString:@"#FF4801"];
        priceLabel.font = [UIFont systemFontOfSize:12];
        [bottomView addSubview:priceLabel];
        
        UIButton *addTrolleyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        addTrolleyBtn.frame = CGRectMake(imgBtn.right - 18, countLabel.bottom, 18, 18);
        [addTrolleyBtn setImage:[UIImage imageNamed:@"scc_addTrolley"] forState:UIControlStateNormal];
        [addTrolleyBtn addTarget:self action:@selector(addTrolleyBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:addTrolleyBtn];
        [self.goodsScrollView addSubview:bottomView];
    }
}

- (void)oneGoodsBtnClickAction:(UIButton *)button{
    NSLog(@"one goods");
}

- (void)addTrolleyBtnClickAction:(UIButton *)button{
    NSLog(@"add trolley");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
