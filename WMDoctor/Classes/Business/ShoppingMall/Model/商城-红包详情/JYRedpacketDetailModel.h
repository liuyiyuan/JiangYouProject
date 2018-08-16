//
//  JYRedpacketDetailModel.h
//  WMDoctor
//
//  Created by xugq on 2018/8/16.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "WMJSONModel.h"

@interface JYRedpacketDetailModel : WMJSONModel

//商品名称
@property(nonatomic, strong)NSString *name;
//商品类别0普通1优惠券2红包
@property(nonatomic, strong)NSString *type;
//数量
@property(nonatomic, strong)NSString *stockCount;
//商品价格
@property(nonatomic, strong)NSString *salePrice;
//备注
@property(nonatomic, strong)NSString *remark;
//温馨提示
@property(nonatomic, strong)NSString *tips;
//起始日期
@property(nonatomic, strong)NSString *effectivestarttime;
//截止日期
@property(nonatomic, strong)NSString *effectiveendtime;
//开始时间
@property(nonatomic, strong)NSString *userstarttime;
//结束时间
@property(nonatomic, strong)NSString *userendtime;
//时间范围
@property(nonatomic, strong)NSString *tmelimitinfo;
//服务标签id
@property(nonatomic, strong)NSString *serviceids;
//图片
@property(nonatomic, strong)NSString *images;


@end
