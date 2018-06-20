//
//  WMSpecialtiesModel.h
//  WMDoctor
//
//  Created by JacksonMichael on 2017/3/23.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMJSONModel.h"

@protocol WMSpecialtieModel;
@interface WMSpecialtieModel : WMJSONModel
/**
 专业ID
 */
@property (nonatomic,copy) NSString * specialtyId;

/**
 专业名字
 */
@property (nonatomic,copy) NSString * specialtyName;

@end

@interface WMSpecialtiesModel : WMJSONModel

@property (nonatomic,strong) NSArray<WMSpecialtieModel> * specialties;

@end
