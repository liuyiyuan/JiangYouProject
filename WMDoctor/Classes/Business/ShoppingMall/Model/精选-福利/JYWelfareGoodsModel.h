//
//  JYWelfareGoodsModel.h
//  WMDoctor
//
//  Created by xugq on 2018/8/12.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "WMJSONModel.h"

@interface JYWelfareOneGoodsModel : WMJSONModel

@property(nonatomic, strong)NSString *bgp;
@property(nonatomic, strong)NSString *classId;
@property(nonatomic, strong)NSString *className;
@property(nonatomic, strong)NSString *coordinate;
@property(nonatomic, strong)NSString *hot;
@property(nonatomic, strong)NSString *merchantId;
@property(nonatomic, strong)NSString *merchantName;

@end

@protocol JYWelfareOneGoodsModel;
@interface JYWelfareGoodsModel : WMJSONModel

@property(nonatomic, strong)NSArray<JYWelfareOneGoodsModel> *merfl;

@end
