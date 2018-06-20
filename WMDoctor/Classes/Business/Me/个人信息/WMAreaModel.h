//
//  WMAreaModel.h
//  WMDoctor
//
//  Created by JacksonMichael on 2017/3/23.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMJSONModel.h"

@protocol WMAreaModel;
@interface WMAreaModel : WMJSONModel

@property (nonatomic,copy) NSString * areaId;

@property (nonatomic,copy) NSString * areaName;

@end

@interface WMAreasModel : WMJSONModel

@property (nonatomic,strong) NSArray<WMAreaModel> * areas;

@end
