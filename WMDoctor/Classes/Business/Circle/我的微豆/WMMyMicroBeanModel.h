//
//  WMMyMicroBeanModel.h
//  WMDoctor
//
//  Created by xugq on 2017/11/27.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMJSONModel.h"

@protocol WMBeanExchangeModel;
@interface WMBeanExchangeModel : WMJSONModel

/**
 项目id
 */
@property (nonatomic,copy) NSString * id;

/**
 项目图标
 */
@property (nonatomic,copy) NSString * itemImg;

/**
 项目名字
 */
@property (nonatomic,copy) NSString * name;

/**
 项目分值
 */
@property (nonatomic,copy) NSString * score;


@end

@interface WMMyMicroBeanModel : WMJSONModel

/**
 积分对话项目列表
 */
@property (nonatomic,strong) NSArray<WMBeanExchangeModel> * scoreConversionItems;

/**
 医生积分
 */
@property (nonatomic,copy) NSString * doctorScore;

@end
