//
//  JYPanicBuyModel.h
//  WMDoctor
//
//  Created by xugq on 2018/8/11.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "WMJSONModel.h"

@interface JYPanicBuyGoodsModel : WMJSONModel

@property(nonatomic, strong)NSString *finTime;
@property(nonatomic, strong)NSString *imageUrl;
@property(nonatomic, strong)NSString *name;
@property(nonatomic, strong)NSString *oriPrice;
@property(nonatomic, strong)NSString *pdesc;
@property(nonatomic, strong)NSString *price;
@property(nonatomic, strong)NSString *productId;

@end

@protocol JYPanicBuyGoodsModel;
@interface JYPanicBuyModel : WMJSONModel

@property(nonatomic, strong)NSArray *RushArray;

@end
