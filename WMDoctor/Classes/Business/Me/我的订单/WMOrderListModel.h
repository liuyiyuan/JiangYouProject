//
//  WMOrderListModel.h
//  WMDoctor
//
//  Created by JacksonMichael on 2017/1/3.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMJSONModel.h"


/**
 订单列表单项List
 */
@protocol WMOrderListModel;
@interface WMOrderListModel : WMJSONModel

@property (nonatomic,copy) NSString * huanzhetx;

@property (nonatomic,copy) NSString * huanzhexm;

@property (nonatomic,copy) NSString * orderDate;

@property (nonatomic,copy) NSString * orderFee;

@property (nonatomic,copy) NSString * orderItem;

@property (nonatomic,copy) NSString * orderStatus;

@property (nonatomic,copy) NSString * sex;

//价格单位
@property (nonatomic,copy) NSString * unit;

//结束时间（服务有效期）
@property (nonatomic,copy) NSString * orderEndDate;

//患者微脉号：前端根据这个来跳转
@property (nonatomic,copy) NSString * patientWeimaihao;

//群编号（前端跳转具体群
@property (nonatomic,copy) NSString * groupId;

//群名字
@property (nonatomic,copy) NSString * groupName;

//订单类型 数据字典 DAIMALB:60612 1:付费订单 2:导诊订单 3:转诊订单 4:患者报到随访订单 5:人脉订单 6:主动随访订单 7：妇幼VIP咨询 8：医患圈入群 9:一问医答
@property (nonatomic,copy) NSString * orderType;

//问题ID
@property (nonatomic,copy) NSString * questionId;

@end



/**
 我的订单主页总Model
 */
@interface WMOrderListMainModel : WMJSONModel


/**
 总价格
 */
@property (nonatomic,copy) NSString * totalFee;

/**
 当前页
 */
@property (nonatomic,copy) NSString * currentPage;


/**
 总页数
 */
@property (nonatomic,copy) NSString * totalPage;

@property (nonatomic,strong) NSArray<WMOrderListModel> * orders;


@end


/**
 订单说明Model
 */
@interface WMIncomeModel : WMJSONModel
@property (nonatomic,copy) NSString * orderDesc;
@end
