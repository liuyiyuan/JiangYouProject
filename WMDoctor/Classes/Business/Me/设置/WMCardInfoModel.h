//
//  WMCardInfoModel.h
//  WMDoctor
//
//  Created by JacksonMichael on 2016/12/30.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import "WMJSONModel.h"

@interface WMCardInfoModel : WMJSONModel

/**
 医生姓名
 */
@property (nonatomic,copy) NSString * doctorName;

/**
 科室名称
 */
@property (nonatomic,copy) NSString * keshiName;

/**
 职称
 */
@property (nonatomic,copy) NSString * organization;

/**
 头像
 */
@property (nonatomic,copy) NSString * photo;

/**
 二维码
 */
@property (nonatomic,copy) NSString * qrcode;

/**
 性别
 */
@property (nonatomic,copy) NSString * sex;

/**
 标题
 */
@property (nonatomic,copy) NSString * title;


/**
 职工编号
 */
@property (nonatomic,copy) NSString * workerId;

@end

@interface WMCardInfoBaseModel : WMJSONModel

@property (nonatomic,strong) WMCardInfoModel * cardInfo;

@end
