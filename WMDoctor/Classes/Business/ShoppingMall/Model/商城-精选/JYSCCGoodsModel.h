//
//  JYSCCGoodsModel.h
//  WMDoctor
//
//  Created by xugq on 2018/8/2.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "WMJSONModel.h"

@interface JYSCCOneGoodModel : WMJSONModel

@property(nonatomic, strong)NSString *productId;
@property(nonatomic, strong)NSString *productPic;
@property(nonatomic, strong)NSString *productPrice;
@property(nonatomic, strong)NSString *productSpecification;
@property(nonatomic, strong)NSString *productTitle;

@end


@protocol JYSCCOneGoodModel;


/**
 商城-精选-商家商品列表model
 */
@interface JYSCCGoodsModel : WMJSONModel

@property(nonatomic, strong)NSString *merchantInfo;
@property(nonatomic, strong)NSString *merchantName;
@property(nonatomic, strong)NSString *merchantPic;
@property(nonatomic, strong)NSString *merchantid;
@property(nonatomic, strong)NSArray<JYSCCOneGoodModel> *merList;

@end
