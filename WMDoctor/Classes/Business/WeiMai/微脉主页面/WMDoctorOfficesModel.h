//
//  WMDoctorOfficesModel.h
//  WMDoctor
//
//  Created by 茭白 on 2017/3/24.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMJSONModel.h"

@protocol WMDoctorOfficesDetailModel;


@interface WMDoctorOfficesModel : WMJSONModel
@property (nonatomic ,strong)NSArray<WMDoctorOfficesDetailModel> *offices;

@end

@interface WMDoctorOfficesDetailModel : WMJSONModel
@property(nonatomic ,copy) NSString *officeId;
@property(nonatomic ,copy) NSString *officeName;

@end
