//
//  JYPanicBuyCell.h
//  WMDoctor
//
//  Created by xugq on 2018/8/3.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYPanicBuyModel.h"
#import "JYGroupBuyModel.h"

@interface JYPanicBuyCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *goodsInfo;
@property (weak, nonatomic) IBOutlet UILabel *goodsActiveTime;
@property (weak, nonatomic) IBOutlet UILabel *goodsCouponPrice;
@property (weak, nonatomic) IBOutlet UILabel *goodsPrice;
@property (weak, nonatomic) IBOutlet UIButton *goodsStatusBtn;


/**
 商城-抢购cell设置数据

 @param panicBuyGoods <#panicBuyGoods description#>
 */
- (void)setValueWithPanicBuyGoodsModel:(JYPanicBuyGoodsModel *)panicBuyGoods;


/**
 商城-团购cell设置数据

 @param groupBuyGoods <#groupBuyGoods description#>
 */
- (void)setValueWithGroupBuyGoodsModel:(JYGroupBuyOneGoodsModel *)groupBuyGoods;

@end
