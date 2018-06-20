//
//  WMMessageListModel.h
//  WMDoctor
//
//  Created by 茭白 on 2016/12/29.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import "WMJSONModel.h"

@protocol WMMessageListDetailModel;

@interface WMMessageListDetailModel : WMJSONModel
@property (nonatomic ,copy)NSString *messageDate;//消息时间
@property (nonatomic ,copy)NSString *messageImg;//图片标志
@property (nonatomic ,copy)NSString *messageSummary;//摘要
@property (nonatomic ,copy)NSString *messageTitle;//标题
@property (nonatomic ,copy)NSString *miniVersion;//最低版本号
@property (nonatomic ,strong)NSNumber *skipTag;//跳转标志(0否 1是)
@property (nonatomic ,copy)NSString *messageUrl; //新闻详情地址 ,%key前端自己约定

@end

@interface WMMessageListModel : WMJSONModel
@property(nonatomic ,strong)NSArray <WMMessageListDetailModel>*messageList;
@property (nonatomic ,strong) NSNumber *totalPage;
@property (nonatomic ,strong) NSNumber *currentPage;

@end
