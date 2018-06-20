//
//  WMEducationCustomModel.h
//  WMDoctor
//
//  Created by JacksonMichael on 2017/3/23.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMJSONModel.h"

@interface WMEducationCustomModel : WMJSONModel

@property (nonatomic,copy) NSString * schoolId;

@property (nonatomic,copy) NSString * specialtyId;

@property (nonatomic,copy) NSString * entranceYear;

@property (nonatomic,copy) NSString * educationId;

@property (nonatomic,copy) NSString * schoolGrade;
@end
