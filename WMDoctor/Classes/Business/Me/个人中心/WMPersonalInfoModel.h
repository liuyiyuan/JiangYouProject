//
//  WMPersonalInfoModel.h
//  WMDoctor
//  个人信息页面大model
//  Created by JacksonMichael on 2016/12/29.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import "WMJSONModel.h"


@interface WMDoctorDetailModel : WMJSONModel


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
 性别
 */
@property (nonatomic,copy) NSString * sex;

/**
 评分
 */
@property (nonatomic,copy) NSString * star;

/**
 标题title
 */
@property (nonatomic,copy) NSString * title;

@end

@protocol WMPatientCommentsModel;

@interface WMPatientCommentsModel : WMJSONModel

/**
 评价内容
 */
@property (nonatomic,copy) NSString * commentContent;

/**
 评价时间
 */
@property (nonatomic,copy) NSString * commentDate;

/**
 评价标签
 */
@property (nonatomic,copy) NSString * commentTag;

/**
 评价人手机号
 */
@property (nonatomic,copy) NSString * phone;

/**
 评价值
 */
@property (nonatomic,copy) NSString * star;

@end



@interface WMPersonalInfoModel : WMJSONModel

@property (nonatomic,copy) NSString * commentsNum;

/**
 当前页
 */
@property (nonatomic,copy) NSString * currentPage;


/**
 总页数
 */
@property (nonatomic,copy) NSString * totalPage;

@property (nonatomic,strong) WMDoctorDetailModel * doctorInfo;

@property (nonatomic,strong) NSArray<WMPatientCommentsModel> * patientComments;
//问诊价格
@property (nonatomic,copy) NSString * price;

//定价权限： 1:是  0:否
@property (nonatomic,copy) NSString * pricingPrivilege;

//货币形式 /1:人民币2:脉豆（前端转化（比例1：100
@property (nonatomic,copy) NSString * coinType;

//人民币和脉豆换算比例：默认100
@property (nonatomic,copy) NSString * maidouRatio;

@end
