//
//  WMOtherDataModel.h
//  WMDoctor
//
//  Created by xugq on 2017/8/9.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMJSONModel.h"

@interface WMOtherDataModel : WMJSONModel



@end


#pragma 个推推送消息
@interface PushInfoModel : WMJSONModel
//消息标题
@property (nonatomic,copy) NSString *TITLE;
//消息内容
@property (nonatomic,copy) NSString *TEXT;
//消息类型  10:新闻资讯  20:服务项目  30:预约成功  40:活动推送   41:挂号成功   42:医院停诊  43:预约过期
@property (nonatomic,copy) NSString *NOTIFYTYPE;
//消息编号
@property (nonatomic,copy) NSString * PARAM1;
//NOTIFYTYPE＝10 ：新闻URL连接地址
@property (nonatomic,copy) NSString<Optional> * PARAM2;
/** 保留参数 */
@property (nonatomic,copy) NSString<Optional> * PARAM3;
@property (nonatomic,copy) NSString<Optional> * PARAM4;
@property (nonatomic,copy) NSString<Optional> * PARAM5;
@property (nonatomic,copy) NSString<Optional> * PARAM6;


@end
