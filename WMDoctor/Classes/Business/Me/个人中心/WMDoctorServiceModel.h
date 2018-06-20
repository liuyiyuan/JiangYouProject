//
//  WMDoctorServiceModel.h
//  WMDoctor
//
//  Created by JacksonMichael on 2017/4/19.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMJSONModel.h"

@protocol WMDoctorMyServiceModel;
@interface WMDoctorMyServiceModel : WMJSONModel

@property (nonatomic,copy) NSString * img;  //服务类型图标

@property (nonatomic,copy) NSString * name;  //服务名字

@property (nonatomic,assign) int openService;  //开启标志 1是  0否

@property (nonatomic,strong) NSArray<Optional> * prices;  //服务价格的集合,服务已加上单位   //2.1 交易平台新增

@property (nonatomic,copy) NSString<Optional> * inquiryType;  //开启标志 1是  0否        //2.1 交易平台新增



@property (nonatomic,copy) NSString<Optional> * price;  //服务价格（脉豆转换后台已算好

@property (nonatomic,copy) NSString<Optional> * pricingPrivilege;  //定价权限 0无 1有

@property (nonatomic,copy) NSString<Optional> * type;  //服务类型(0图文 1包月

@property (nonatomic,copy) NSString<Optional> * typeId;  //服务类型的id，在修改是否提供服务里传参


@end

@protocol WMDoctorServiceCommentsModel;
@interface WMDoctorServiceCommentsModel : WMJSONModel

@property (nonatomic,copy) NSString * commentContent;  //评价内容

@property (nonatomic,copy) NSString * commentDate;  //评价时间

@property (nonatomic,copy) NSString * commentTag;  //评价标签，多个值逗号隔开

@property (nonatomic,copy) NSString * phone;  //手机号，已作星处理

@property (nonatomic,copy) NSString * star;  //评分


@end


@interface WMDoctorServiceModel : WMJSONModel

@property (nonatomic,strong) NSArray<WMDoctorMyServiceModel> * myServices;

@property (nonatomic,copy) NSString * certificationStatus;  //认证状态：0:未提交认证 1:等待认证 2:认证通过 3:认证不通过

@end
