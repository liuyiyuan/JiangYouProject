//
//  WMStatusModel.h
//  WMDoctor
//
//  Created by JacksonMichael on 2017/5/19.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMJSONModel.h"

@interface WMStatusModel : WMJSONModel

@property (nonatomic,copy) NSString * money;
/**
 认证状态：0:未提交认证 1:等待认证 2:认证通过 3:认证不通过
 */
@property (nonatomic,copy) NSString * status;
/**
 认证状态：0:不弹 1:弹 2:无数据
 */
@property (nonatomic,copy) NSString * popup;


@end
