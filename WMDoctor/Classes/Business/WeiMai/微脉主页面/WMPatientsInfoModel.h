//
//  WMPatientsInfoModel.h
//  WMDoctor
//
//  Created by 茭白 on 2017/1/4.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMJSONModel.h"

@interface WMPatientsInfoModel : WMJSONModel
@property (nonatomic ,strong)NSString *xingming;//患者姓名
@property (nonatomic ,strong)NSString *xingbie;//患者性别  0:未知的性别1:男2:女3:未说明的性别
@property (nonatomic ,strong)NSString *url; //患者头像
@property (nonatomic ,strong)NSString *type; //0患者 1 医生或助理
@property (nonatomic ,strong)NSString *vip; //1:vip患者 ；0普通患者
@property (nonatomic ,strong)NSArray *tagNames;
@end
