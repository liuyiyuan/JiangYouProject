//
//  JYSCCGoodsCell.h
//  WMDoctor
//
//  Created by xugq on 2018/8/2.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYSCCGoodsModel.h"

@interface JYSCCGoodsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *storeImageView;
@property (weak, nonatomic) IBOutlet UIScrollView *goodsScrollView;


/**
 根据商品model设置商家推荐商品value

 @return
 */
- (void)setValueWithGoodsModel:(JYSCCGoodsModel *)goods;

@end
