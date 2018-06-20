//
//  WMSchoolModel.h
//  WMDoctor
//
//  Created by JacksonMichael on 2017/3/23.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMJSONModel.h"

@protocol WMSchoolModel;
@interface WMSchoolModel : WMJSONModel

@property (nonatomic,copy) NSString * schoolId;

@property (nonatomic,copy) NSString * schoolName;

@end

@interface WMSchoolsModel : WMJSONModel

@property (nonatomic,strong) NSArray<WMSchoolModel> * schools;

@end
