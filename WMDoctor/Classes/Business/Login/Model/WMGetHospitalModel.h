//
//  WMGetHospitalModel.h
//  WMDoctor
//
//  Created by 茭白 on 2017/5/17.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMJSONModel.h"

@protocol WMHospitalDetailModel;
@interface WMHospitalDetailModel : WMJSONModel

@property(nonatomic ,strong)NSString *flushCode;//流水号
@property(nonatomic ,strong)NSString *name;//名称
@property(nonatomic ,strong)NSString *organizationCode;//机构编号
@property(nonatomic ,strong)NSString *platformCode;//平台编号


@end


@protocol WMGetHospitalDetailModel;
@interface WMGetHospitalDetailModel : WMJSONModel
@property(nonatomic ,strong)NSString *code;//编码
@property(nonatomic ,strong)NSString *flashCode;//流水号
@property(nonatomic ,strong)NSString *name;//名称
@property (nonatomic ,strong)NSArray<WMHospitalDetailModel> *  hospitalVoList;
@end
@interface WMGetHospitalModel : WMJSONModel
@property (nonatomic ,strong)NSArray<WMGetHospitalDetailModel> *regionHospitalVoList;

@end
