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
    self.goodsScrollView.contentSize = CGSizeMake(10 + (70 + 8) * goods.merList.count, 110);
    self.goodsScrollView.backgroundColor = [UIColor whiteColor];
    self.goodsScrollView.layer.masksToBounds = YES;
    self.goodsScrollView.layer.cornerRadius = 5;
    float view_x = 8;
    float view_y = 11;
    float view_w = 117;
    float view_h = 144;
    
    for (int i = 0; i < goods.merList.count; i ++) {
        JYSCCOneGoodModel *oneGoods = goods.merList[i];
        view_x = view_x + 78 * i;
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(view_x, view_y, view_w, view_h)];
        
        UIButton *imgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        imgBtn.frame = CGRectMake(0, 0, 105, 92);
        [imgBtn setImage:[UIImage imageNamed:@"scc_oneGoods"] forState:UIControlStateNormal];
        imgBtn.tag = i;
        [imgBtn addTarget:self action:@selector(oneGoodsBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:imgBtn];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, imgBtn.bottom + 6, bottomView.width, 11)];
        titleLabel.text = @"牛排新鲜肉眼牛扒...";
        titleLabel.textColor = [UIColor colorWithHexString:@"#000000"];
        titleLabel.font = [UIFont systemFontOfSize:11];
        [bottomView addSubview:titleLabel];
        
        UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, titleLabel.bottom + 5, bottomView.width - 20, 6)];
        countLabel.text = @"200g*1包";
        countLabel.textColor = [UIColor colorWithHexString:@"#8B8A8A"];
        countLabel.font = [UIFont systemFontOfSize:5];
        [bottomView addSubview:countLabel];
        
        UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, countLabel.bottom + 7, bottomView.width - 20, 12)];
        priceLabel.text = @"$ 29.9";
        priceLabel.textColor = [UIColor colorWithHexString:@"#FF4801"];
        priceLabel.font = [UIFont systemFontOfSize:12];
        [bottomView addSubview:priceLabel];
        
        UIButton *addTrolleyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        addTrolleyBtn.frame = CGRectMake(bottomView.width - 18, countLabel.bottom, 18, 18);
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
