//
//  WMServiceUpdatePriceModel.h
//  WMDoctor
//
//  Created by JacksonMichael on 2017/4/19.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMJSONModel.h"

@interface WMServiceUpdatePriceModel : WMJSONModel

@property (nonatomic,copy) NSString * price;

@property (nonatomic,copy) NSString * custom;

@end
