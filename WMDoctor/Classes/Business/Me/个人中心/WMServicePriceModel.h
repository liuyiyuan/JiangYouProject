//
//  WMServicePriceModel.h
//  WMDoctor
//
//  Created by JacksonMichael on 2017/4/19.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMJSONModel.h"

@interface WMServicePriceModel : WMJSONModel

@property (nonatomic,copy) NSString * custom;

@property (nonatomic,copy) NSString * openService;

@property (nonatomic,copy) NSString * pricingPrivilege;

@property (nonatomic,copy) NSString * price;

@property (nonatomic,copy) NSString * descriptionStr;

@property (nonatomic,copy) NSString * typeId;

@property (nonatomic,copy) NSString * type;

@property (nonatomic,strong) NSArray * prices;

@end
