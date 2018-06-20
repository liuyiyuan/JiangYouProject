//
//  WMDoctorInfoModel.h
//  WMDoctor
//
//  Created by JacksonMichael on 2016/12/29.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import "WMJSONModel.h"

@interface WMDoctorInfoModel : WMJSONModel

@property (nonatomic,copy) NSString * name;

@property (nonatomic,copy) NSString * photo;

@property (nonatomic,copy) NSString * sex;

@property (nonatomic,copy) NSString<Optional> * title;
@property (nonatomic,copy) NSString * star;
@property (nonatomic,copy) NSString * openRenmai;

/**
 0休息、1忙碌、2在线
 */
@property (nonatomic,copy) NSString * status;

/**
 我的钱包的显示与否 1：是  0：否
 */
@property (nonatomic,copy) NSString * payVisible;

/**
 认证状态：0:未提交认证 1:等待认证 2:认证通过 3:认证不通过
 */
@property (nonatomic,copy) NSString * certificationStatus;

@end
