//
//  WMPatientsHealthModel.h
//  WMDoctor
//
//  Created by 茭白 on 2017/1/5.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMJSONModel.h"


@protocol WMPatientsHealthDetailModel;
@interface WMPatientsHealthDetailModel : WMJSONModel

@property (nonatomic, copy)NSString *jiuzhensj;//就诊时间
@property (nonatomic, copy)NSString *keshimc;//科室名称
@property (nonatomic, copy)NSString <Optional>*yiyuanmc;//医院名称
@property (nonatomic, copy)NSString *zhenduanmc;//主诊断
@property (nonatomic, copy)NSString *jiuzhenmxlb;


@end


@interface WMPatientsHealthModel : WMJSONModel
@property (nonatomic ,strong)NSArray <WMPatientsHealthDetailModel>*health;
@end

