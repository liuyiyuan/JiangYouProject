//
//  JYSCCStoreModel.h
//  WMDoctor
//
//  Created by xugq on 2018/8/14.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "WMJSONModel.h"

@interface JYStoreGoodsModel : WMJSONModel

@property(nonatomic, strong)NSString *listImg;
@property(nonatomic, strong)NSString *mdescription;
@property(nonatomic, strong)NSString *name;
@property(nonatomic, strong)NSString *productId;
@property(nonatomic, strong)NSString *salePrice;

@end

@protocol JYStoreGoodsModel;
@interface JYSomeOneStoreModel : WMJSONModel

@property(nonatomic, strong)NSString *merchantId;
@property(nonatomic, strong)NSString *selectExplain;
@property(nonatomic, strong)NSString *selectPic;
@property(nonatomic, strong)NSString *selectTag;
@property(nonatomic, strong)NSString *selectText;
@property(nonatomic, strong)NSString *selectTitle;
@property(nonatomic, strong)NSArray<JYStoreGoodsModel> *productArray;

@end

@protocol JYSomeOneStoreModel;
@interface JYSCCStoreModel : WMJSONModel

@property(nonatomic, strong)NSArray<JYSomeOneStoreModel> *selectedArray;

@end
