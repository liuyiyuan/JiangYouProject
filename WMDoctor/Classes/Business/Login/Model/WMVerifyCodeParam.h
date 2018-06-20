//
//  WMVerifyCodeParam.h
//  WMDoctor
//
//  Created by JacksonMichael on 2017/1/17.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMJSONModel.h"

@interface WMVerifyCodeParam : WMJSONModel

@property (nonatomic,copy) NSString * phone;

@property (nonatomic,copy) NSString * verifyCode;

@property (nonatomic,copy) NSString * phoneModel;

@property (nonatomic,copy) NSString * phoneOS;

@property (nonatomic,copy) NSString * phoneId;

@property (nonatomic,copy) NSString * clientType;//客户端类型 IOS / Android

@property (nonatomic,copy) NSString * departmentCode;//科室编号

@property (nonatomic,copy) NSString * jobLevel;//职称 代码字典

@property (nonatomic,copy) NSString * jobType;//职业 医生 / 护士

@property (nonatomic,copy) NSString * name;//医生名称

@property (nonatomic,copy) NSString * organizationCode;//机构编号（医院）

@property (nonatomic,copy) NSString * cid;//注册个推cid
@end
