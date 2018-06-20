//
//  WMDoctorCardModel.h
//  WMDoctor
//
//  Created by 茭白 on 2017/3/23.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMJSONModel.h"
@protocol WMDoctorCardDetailModel;
@interface WMDoctorCardModel : WMJSONModel

@property (nonatomic ,strong) NSMutableArray <WMDoctorCardDetailModel>* doctorCards;
@property (nonatomic ,copy) NSString *officeName;


@end
@interface WMDoctorCardDetailModel : WMJSONModel
@property (nonatomic ,copy) NSString *doctorName;//医生姓名
@property (nonatomic ,copy) NSString *officeId;//科室编号
//@property (nonatomic ,copy) NSString *orderId; //问诊订单编号,医生打招呼产生,保存发名片记录用
@property (nonatomic ,copy) NSString *orgId; //机构编号
@property (nonatomic ,copy) NSString *orgName; //机构名称
//@property (nonatomic ,copy) NSString *patientId; //客户编号(打招呼的患者id
@property (nonatomic ,copy) NSString *photo; //头像
@property (nonatomic ,copy) NSString *title; //技术职称
@property (nonatomic ,copy) NSString *userCode; //被推荐医生用户编号
@property (nonatomic ,copy) NSString *employCode; //职工编号编号



@end


