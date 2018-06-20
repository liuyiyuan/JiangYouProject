//
//  WMServiceSetInfoModel.h
//  WMDoctor
//
//  Created by JacksonMichael on 2017/12/11.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMJSONModel.h"

@protocol WMServiceSetInfoModels;
@interface WMServiceSetInfoModels : WMJSONModel

@property (nonatomic,copy) NSString * custom;

@property (nonatomic,copy) NSString * inquiryType;

@property (nonatomic,copy) NSString * name;

@property (nonatomic,copy) NSString * openService;

@property (nonatomic,copy) NSString * price;

@property (nonatomic,strong) NSArray * prices;

@property (nonatomic,copy) NSString * pricingPrivilege;

@property (nonatomic,copy) NSString * type;

@property (nonatomic,copy) NSString * typeId;

@property (nonatomic,copy) NSString * unit;

@property (nonatomic,copy) NSString<Optional> * coinType;

@property (nonatomic,copy) NSString<Optional> * num;

@end


@interface WMServiceSetInfoModel : WMJSONModel

@property (nonatomic,copy) NSString * theDescription;

@property (nonatomic,strong) NSArray<WMServiceSetInfoModels> * serviceSetting;

@property (nonatomic,copy) NSString * openStatus;

@end
