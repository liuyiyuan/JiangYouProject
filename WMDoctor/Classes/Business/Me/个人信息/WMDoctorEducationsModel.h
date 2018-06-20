//
//  WMDoctorEducationsModel.h
//  WMDoctor
//
//  Created by JacksonMichael on 2017/3/23.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMJSONModel.h"

@protocol WMDoctorEducationModel;
@interface WMDoctorEducationModel : WMJSONModel

@property (nonatomic,copy) NSString * schoolGrade;

@property (nonatomic,copy) NSString * gradeName;

@property (nonatomic,copy) NSString * schoolName;

@property (nonatomic,copy) NSString * schoolId;

@property (nonatomic,copy) NSString * specialtyId;

@property (nonatomic,copy) NSString * entranceYear;

@property (nonatomic,copy) NSString * educationId;

@end



@interface WMDoctorEducationsModel : WMJSONModel

@property (nonatomic,strong) NSArray<WMDoctorEducationModel> * doctorEducations;

@end


