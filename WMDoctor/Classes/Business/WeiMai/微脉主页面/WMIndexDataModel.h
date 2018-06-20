//
//  WMIndexDataModel.h
//  WMDoctor
//
//  Created by JacksonMichael on 2018/1/30.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "WMJSONModel.h"

@protocol WMIndexBanners;
@interface WMIndexBanners : WMJSONModel

//banner id
@property (nonatomic,copy) NSString * theID;

//banner 背景图片
@property (nonatomic,copy) NSString * img;

//banner主题
@property (nonatomic,copy) NSString * subject;

//banner点击跳转地址
@property (nonatomic,copy) NSString * url;

@end

@protocol WMFunctionEntries;
@interface WMFunctionEntries :WMJSONModel

//编码1001一问医答1002咨询服务 1003医聊圈 1004患者报道 1005我的患者1000更多
@property (nonatomic,copy) NSString * code;

//热点标志：1是 0否
@property (nonatomic,copy) NSString * hot;

//图标icon
@property (nonatomic,copy) NSString * icon;

//链接参数，当链接类型是2时是地址；当是1时前端根据链接类型跳转
@property (nonatomic,copy) NSString * linkParam;

//链接类型：1 约定编码 2 固定链接
@property (nonatomic,copy) NSString * linkType;

//名字
@property (nonatomic,copy) NSString * name;

//启用标志：1是 0否
@property (nonatomic,copy) NSString * openFlag;

@end

@protocol WMGridEntries;
@interface WMGridEntries : WMJSONModel

//2001：热门活动 2002：微脉大学 2003：进修课程 2004：医生风云榜
@property (nonatomic,copy) NSString * code;

//水平单元格数量
@property (nonatomic,copy) NSString * horizontalCellNum;


@property (nonatomic,copy) NSString * hot;


@property (nonatomic,copy) NSString * icon;

//显示位置
@property (nonatomic,copy) NSString * iconPosition;


@property (nonatomic,copy) NSString * linkParam;


@property (nonatomic,copy) NSString * linkType;


@property (nonatomic,copy) NSString * name;


@property (nonatomic,copy) NSString * openFlag;

//垂直单元格数量
@property (nonatomic,copy) NSString * verticalCellNum;

@end

@interface WMIndexDataModel : WMJSONModel

@property (nonatomic,strong) NSMutableArray<WMIndexBanners> * banners;

@property (nonatomic,strong) NSMutableArray<WMFunctionEntries> * functionEntries;

@property (nonatomic,strong) NSMutableArray<WMGridEntries> * gridEntries;


@end


//------  新首页应用model

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
@property (nonatomic,copy) NSString *describe;//应用描述
@property (nonatomic,copy) NSString *isRequireCompleteInfo;//是否需要认证

@end
