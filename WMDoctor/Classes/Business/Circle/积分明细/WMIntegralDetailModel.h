//
//  WMIntegralDetailModel.h
//  WMDoctor
//
//  Created by xugq on 2017/11/23.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMJSONModel.h"


@protocol WMIntegralModel;
@interface WMIntegralModel : WMJSONModel

/**
 分值
 */
@property (nonatomic,copy) NSString * score;

/**
 获得积分时间
 */
@property (nonatomic,copy) NSString * scoreDate;

/**
 积分名字
 */
@property (nonatomic,copy) NSString * scoreName;

/**
 积分的增减类型：+、-
 */
@property (nonatomic,copy) NSString * scoreType;


@end

@interface WMIntegralDetailModel : WMJSONModel

/**
 积分明细列表
 */
@property (nonatomic,strong) NSArray<WMIntegralModel> * scoreHistories;

/**
 医生积分
 */
@property (nonatomic,copy) NSString * doctorScore;
@end
