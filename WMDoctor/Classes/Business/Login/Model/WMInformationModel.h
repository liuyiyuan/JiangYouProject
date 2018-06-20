//
//  WMInformationModel.h
//  WMDoctor
//
//  Created by 茭白 on 2017/5/15.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMJSONModel.h"

@interface WMInformationModel : WMJSONModel

@property(nonatomic ,copy)NSString *name;
@property(nonatomic ,copy)NSString *jobName;
@property(nonatomic ,copy)NSString *jobBH;
@property(nonatomic ,copy)NSString *jobType;
@property(nonatomic ,copy)NSString *hosName;
@property(nonatomic ,copy)NSString *hosBH;
@property(nonatomic ,copy)NSString *SectionName;
@property(nonatomic ,copy)NSString *SectionBH;
+(WMInformationModel *)shareInformationModel;
@end
