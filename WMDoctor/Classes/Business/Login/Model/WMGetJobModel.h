//
//  WMGetJobModel.h
//  WMDoctor
//
//  Created by 茭白 on 2017/5/18.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMJSONModel.h"


@protocol WMJobDetailModel;
@interface WMJobDetailModel : WMJSONModel
@property (nonatomic,copy)NSString *levelId;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *bianMa;

@end
@protocol WMGetJobDetailModel;
@interface WMGetJobDetailModel : WMJSONModel
@property (nonatomic,strong)NSArray <WMJobDetailModel>*jobLevelList;
@property (nonatomic,copy)NSString *jobType;
@property (nonatomic,copy)NSString *jobTypeId;

@end
@interface WMGetJobModel : WMJSONModel
@property (nonatomic,strong)NSArray <WMGetJobDetailModel>*jobLevelList;
@end
