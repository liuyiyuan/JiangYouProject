//
//  WMQuickReplyModel.h
//  WMDoctor
//
//  Created by JacksonMichael on 2017/7/26.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMJSONModel.h"

@interface WMQuickReplyModel : WMJSONModel

@property (nonatomic,copy) NSString * contentText;

@property (nonatomic,copy) NSString * userId;

@property (nonatomic,assign) NSNumber* order;

@property (nonatomic,copy) NSString * theType;

@end
