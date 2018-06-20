//
//  WMPatientStateModel.h
//  WMDoctor
//
//  Created by 茭白 on 2017/1/4.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMJSONModel.h"

@interface WMPatientStateModel : WMJSONModel
@property (nonatomic ,strong)NSString  <Optional>*dingdanhao;//订单号
@property (nonatomic ,copy)NSString *xingming;//患者姓名
@property (nonatomic ,copy)NSString *xingbie;//患者性别  0:未知的性别1:男2:女 3:未说明的性别
@property (nonatomic ,copy)NSString <Optional>*huifubz; //医生回复标志    1:是    0:否
@property (nonatomic ,copy)NSString *chakanjkdaqbz;//查看健康档案权限   1:是  0:否
@property (nonatomic ,copy)NSString *url; //患者头像
@property (nonatomic ,copy)NSString *status;//订单状态 ：0 可以接受患者的咨询，1 不可以 接受患者咨询
@property (nonatomic ,copy)NSString *serviceType;// 0-随访，1-主动联系
@property (nonatomic ,copy)NSString *vip;// 0-不是vip，1-是vip

@property (nonatomic ,strong)NSNumber *close;//此患者还在包月服务期内，暂时无法结束咨询 关闭对话权限 1能关闭 0不能关闭
@property (nonatomic ,copy)NSString <Optional>*deadlineText;//此患者还在包月服务期内，暂时无法结束咨询 关闭对话权限 1能关闭 0不能关闭
@property (nonatomic, strong)NSArray *tagNames;

@end
