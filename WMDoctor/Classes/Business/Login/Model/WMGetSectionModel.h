//
//  WMGetSectionModel.h
//  WMDoctor
//
//  Created by 茭白 on 2017/5/17.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMJSONModel.h"

@protocol WMSectionDetailModel;
@interface WMSectionDetailModel : WMJSONModel
@property(nonatomic ,strong)NSString *departmentId;//院内科室id
@property(nonatomic ,strong)NSString *flushCode;//流水号
@property(nonatomic ,strong)NSString *name;//名称
@property(nonatomic ,strong)NSString *organizationCode;//机构编号
@end

@protocol WMGetSectionDetailModel;

@interface WMGetSectionDetailModel : WMJSONModel
@property(nonatomic ,strong)NSString *departmentCategory;//分类名称
@property(nonatomic ,strong)NSString *mappingCode;//映射编码
@property (nonatomic ,strong)NSArray<WMSectionDetailModel> *  departmentVoList;
@end

@interface WMGetSectionModel : WMJSONModel
@property (nonatomic ,strong)NSArray<WMGetSectionDetailModel> *keshiVoList;

@end
