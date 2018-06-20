//
//  WMPatientCommentsModel.h
//  WMDoctor
//
//  Created by JacksonMichael on 2017/5/16.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMJSONModel.h"
#import "WMDoctorServiceModel.h"


@interface WMPatientCommentModel : WMJSONModel

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
 手机号
 */
@property (nonatomic,copy) NSString * phone;

/**
 评分星数
 */
@property (nonatomic,copy) NSString * star;

@end



@interface WMPatientCommentsNewModel : WMJSONModel

/**
 评价数
 */
@property (nonatomic,copy) NSString * commentsNum;

/**
 当前页
 */
@property (nonatomic,copy) NSString * currentPage;

/**
 患者评价
 */
@property (nonatomic,copy) NSArray<WMDoctorServiceCommentsModel> * patientComments;

/**
 总页数
 */
@property (nonatomic,copy) NSString * totalPage;


@end



