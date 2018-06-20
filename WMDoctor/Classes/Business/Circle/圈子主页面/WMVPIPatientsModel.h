//
//  WMVPIPatientsModel.h
//  WMDoctor
//
//  Created by 茭白 on 2017/4/13.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMJSONModel.h"

@protocol WMVPIPatientsDetailModel;
@interface WMVPIPatientsModel : WMJSONModel
@property (nonatomic ,strong)NSArray<WMVPIPatientsDetailModel> *vipPatients;

@end

@interface WMVPIPatientsDetailModel : WMJSONModel
@property (nonatomic ,copy) NSString *avator;// 头像
@property (nonatomic ,copy) NSString *name;//患者名字
@property (nonatomic ,strong)NSNumber *sex;//患者性别 1男 2女 ；和 其它
@property (nonatomic ,copy) NSString *tag;//标签 包月 包季 包年
@property (nonatomic ,copy) NSString *visitDate;//最近咨询时间
@property (nonatomic ,copy) NSString *weimaihao; //微脉号
@property (nonatomic,copy)NSString *age;//年龄
@property (nonatomic,copy)NSArray<WMPatientTagModel> *tagGroups;//

@end
