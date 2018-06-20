//
//  WMDoctorInformationCustomModel.h
//  WMDoctor
//
//  Created by JacksonMichael on 2017/3/27.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMJSONModel.h"

@interface WMDoctorInformationCustomModel : WMJSONModel

@property (nonatomic,copy) NSString * idcard;

@property (nonatomic,copy) NSString * provinceId;

@property (nonatomic,copy) NSString * cityId;

@property (nonatomic,copy) NSString * areaId;

@property (nonatomic,copy) NSString * streetId;

@property (nonatomic,copy) NSString * villageId;

@property (nonatomic,copy) NSString * area;

@property (nonatomic,copy) NSString * address;

@property (nonatomic,copy) NSString * tags;

@property (nonatomic,copy) NSString * customTags;

@end
