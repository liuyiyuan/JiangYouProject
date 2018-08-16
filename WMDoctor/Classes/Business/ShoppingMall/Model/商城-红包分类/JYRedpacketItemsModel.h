//
//  JYRedpacketItemModel.h
//  WMDoctor
//
//  Created by xugq on 2018/8/16.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "WMJSONModel.h"

@interface JYRedpacketGoodsModel : WMJSONModel

@property(nonatomic, strong)NSString *productId;
@property(nonatomic, strong)NSString *listImg;
@property(nonatomic, strong)NSString *name;
@property(nonatomic, strong)NSString *mdescription;

@end

@protocol JYRedpacketGoodsModel;
@interface JYRedpacketItemsModel : WMJSONModel

@property(nonatomic, strong)NSString *ptypeId;
@property(nonatomic, strong)NSString *name;
@property(nonatomic, strong)NSArray<JYRedpacketGoodsModel> *redPocketArray;

@end
