//
//  WMDoctorInfoModel.h
//  WMDoctor
//
//  Created by JacksonMichael on 2017/3/23.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMJSONModel.h"

@interface WMDoctorInformationModel : WMJSONModel

/**
 地区
 */
@property (nonatomic,copy) NSString * area;

/**
 选中标签
 */
//@property (nonatomic,copy) NSString * choiceTags;

/**
 详细地址
 */
//@property (nonatomic,copy) NSString * address;

/**
 电话
 */
//@property (nonatomic,copy) NSString * phone;

/**
 身份证
 */
//@property (nonatomic,copy) NSString * idcard;

/**
 姓名
 */
@property (nonatomic,copy) NSString * name;

/**
 默认的标签
 */
//@property (nonatomic,copy) NSString * defaultTags;

/**
 自定义标签
 */
//@property (nonatomic,copy) NSString * customTags;


/**
 学校名字
 */
@property (nonatomic,copy) NSString * schoolName;


/**
 认证状态（0:未提交认证 1:等待认证 2:认证通过 3:认证不通过）
 */
@property (nonatomic,copy) NSString * certificationStatus;

/**
 医院
 */
@property (nonatomic,copy) NSString * hospitalName;

@property (nonatomic,copy) NSString * hospitalCode;

/**
 科室
 */
@property (nonatomic,copy) NSString * officeName;

/**
 职称
 */
@property (nonatomic,copy) NSString * title;

/**
 简介
 */
@property (nonatomic,copy) NSString * intro;

/**
 擅长
 */
@property (nonatomic,copy) NSString * skill;


/**
 头像
 */
@property (nonatomic,copy) NSString * photo;

@end
