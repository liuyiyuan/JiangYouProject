//
//  JYRedpacketModel.h
//  WMDoctor
//
//  Created by xugq on 2018/8/15.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "WMJSONModel.h"

@interface JYRedpacketInfo : WMJSONModel

@property(nonatomic, strong)NSString *listImg;
@property(nonatomic, strong)NSString *mdescription;
@property(nonatomic, strong)NSString *name;
@property(nonatomic, strong)NSString *productId;

@end

@protocol JYRedpacketInfo;
@interface JYRedpacketItemModel : WMJSONModel

@property(nonatomic, strong)NSString *name;
@property(nonatomic, strong)NSString *ptypeId;
@property(nonatomic, strong)NSArray<JYRedpacketInfo> *redPocketArray;

@end

@protocol JYRedpacketItemModel;
@interface JYRedpacketModel : WMJSONModel

@property(nonatomic, strong)NSArray<JYRedpacketItemModel> *redArray;

@end
