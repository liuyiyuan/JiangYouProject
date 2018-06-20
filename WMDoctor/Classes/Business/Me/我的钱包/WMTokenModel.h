//
//  WMTokenModel.h
//  WMDoctor
//
//  Created by JacksonMichael on 2017/1/12.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMJSONModel.h"

@interface WMTokenModel : WMJSONModel

@property (nonatomic,copy) NSString * weimaipayToken;

@property (nonatomic,copy) NSString * expiredDateTime;

@end
