//
//  LoginModel.h
//  WMDoctor
//
//  Created by choice-ios1 on 16/12/27.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import "WMJSONModel.h"

@interface LoginModel : WMJSONModel<NSCopying>

@property (nonatomic,copy) NSString * avatar;

@property (nonatomic,copy) NSString * name;

@property (nonatomic,copy) NSString * phone;

@property (nonatomic,copy) NSString * rongToken;

@property (nonatomic,copy) NSString * sessionId;

@property (nonatomic,copy) NSString * sex;

@property (nonatomic,copy) NSString * status;

@property (nonatomic,strong) NSNumber * userCode;

@property (nonatomic,strong) NSNumber * userId;


/**
 用户标识
 0 >>> 医生角色
 1 >>> 护士角色
 */
@property (nonatomic,assign) BOOL userType;

//登陆标识，1表示已登陆过，0表示已注销
@property (nonatomic,copy) NSString <Optional>* loginFlag;


/**
 医生认证状态
 */
@property (nonatomic,copy) NSString * certStatus;

@end
