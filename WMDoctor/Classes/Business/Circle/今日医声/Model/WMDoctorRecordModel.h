//
//  WMDoctorRecordModel.h
//  WMDoctor
//
//  Created by JacksonMichael on 2017/10/11.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMJSONModel.h"

@interface WMDoctorRecordModel : WMJSONModel

@property (nonatomic,copy) NSString * groupId;

@property (nonatomic,copy) NSString * timeLength;

@property (nonatomic,copy) NSString * title;

@property (nonatomic,copy) NSString * suffix;

@end
