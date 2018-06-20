//
//  WMSchoolTypeModel.h
//  WMDoctor
//
//  Created by JacksonMichael on 2017/3/23.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMJSONModel.h"

@protocol WMSchoolTypeModel;
@interface WMSchoolTypeModel : WMJSONModel


/**
 学历
 */
@property (nonatomic,copy) NSString * gradeName;

/**
 学历编号
 */
@property (nonatomic,copy) NSString * schoolGrade;

@end


@interface WMSchoolTypesModel : WMJSONModel

@property (nonatomic,strong) NSArray<WMSchoolTypeModel> * schoolType;

@end

