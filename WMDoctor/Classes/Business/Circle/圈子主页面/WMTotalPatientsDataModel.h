//
//  WMTotalPatientsDataModel.h
//  WMDoctor
//
//  Created by 茭白 on 2017/2/27.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMJSONModel.h"

@protocol WMTotalPatientsModel;
@interface WMTotalPatientsModel : WMJSONModel
@property (nonatomic,copy)NSString *focusTime;//时间
@property (nonatomic,copy)NSString *headPicture;//头像
@property (nonatomic,copy)NSString *name;//名字
@property (nonatomic,copy)NSString *phone;//手机号
@property (nonatomic,strong)NSString *weimaihao;//微脉号
@property (nonatomic,copy)NSString *age;//年龄
@property (nonatomic,copy)NSArray<WMPatientTagModel> *tagGroups;//
@property (nonatomic,strong)NSNumber *sex;//性别
@property (nonatomic,strong)NSNumber *type;//1:患者报到，2:历史问诊订单
@property (nonatomic,strong)NSNumber *vip;//1 是 0否
@property (nonatomic,strong)NSString *vipTagName;


@end

@interface WMTotalPatientsDataModel : WMJSONModel
@property (nonatomic ,strong)NSArray<WMTotalPatientsModel> *list;
@property (nonatomic ,strong) NSNumber *totalPage;
@property (nonatomic ,strong) NSNumber *currentPage;
@end
