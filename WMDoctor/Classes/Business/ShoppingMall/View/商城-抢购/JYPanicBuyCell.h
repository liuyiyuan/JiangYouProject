//
//  JYPanicBuyCell.h
//  WMDoctor
//
//  Created by xugq on 2018/8/3.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYPanicBuyModel.h"

@interface JYPanicBuyCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *goodsInfo;
@property (weak, nonatomic) IBOutlet UILabel *goodsActiveTime;
@property (weak, nonatomic) IBOutlet UILabel *goodsCouponPrice;
@property (weak, nonatomic) IBOutlet UILabel *goodsPrice;
@property (weak, nonatomic) IBOutlet UIButton *goodsStatusBtn;

- (void)setValueWithPanicBuyGoodsModel:(JYPanicBuyGoodsModel *)panicBuyGoods;

@end
