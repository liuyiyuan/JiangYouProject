//
//  HomeAppModel.h
//  WMDoctor
//
//  Created by xugq on 2018/7/21.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "WMJSONModel.h"

@interface HomeAppModel : WMJSONModel

@property (nonatomic,copy) NSString *name;//应用名称
@property (nonatomic,copy) NSString *image;//应用图片地址
@property (nonatomic,copy) NSString *sortNumber;//顺序号
@property (nonatomic,copy) NSString *displayArea;//显示坐标
@property (nonatomic,copy) NSString *isEnable;//启用标志
@property (nonatomic,copy) NSString *tips;//提示信息
@property (nonatomic,copy) NSString *skipType;//跳转类型
@property (nonatomic,copy) NSString *skipId;//跳转ID
@property (nonatomic,copy) NSString *skipUrl;//跳转地址
@property (nonatomic,copy) NSString *skipParameters;//跳转参数
@property (nonatomic,copy) NSString *isHot;//热点标志
@property (nonatomic,copy) NSString *hotDes;//活动标签
@property (nonatomic,copy) NSString *describe;//应用描述
@property (nonatomic,copy) NSString *isRequireCompleteInfo;//是否需要认证

@end
