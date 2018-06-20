//
//  WMRCGroupNewsMessage.h
//  Micropulse
//
//  Created by 茭白 on 2017/7/27.
//  Copyright © 2017年 iChoice. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>
#define     WMRCGroupNewsMessageTypeIdentifier @"RCD:WMGroupNewsMsg"

@interface WMRCGroupNewsMessage : RCMessageContent
/*!
 主标题
 */
@property(nonatomic, strong) NSString *title;
/*!
 头像url
 */
@property(nonatomic, strong) NSString *showUrl;
/*!
  详情label
 */
@property(nonatomic, strong) NSString *detailLabel;
/*!
 入参model 的 jsonsting
 */
@property(nonatomic, strong) NSString *senateModelString;

/*!
 专题model 的 jsonsting
 
@property(nonatomic, strong) NSString *projectModelString;


 咨询model 的 jsonsting
 
@property(nonatomic, strong) NSString *newsModelString;


 活动model 的 jsonsting
 
@property(nonatomic, strong) NSString *activityModelString;
*/

/*!
 消息模板 消息的输入模板
 */
@property(nonatomic, copy) NSString *templateString;


/*!
 测试消息的附加信息
 */
@property(nonatomic, strong) NSString *extra;

/* 
 
 @param title 文本内容
 @param showUrl 分享url
 @param detailLabel 文本内容
 @param showModelString 文本内容
 @param projectModelString 文本内容
 @param newsModelString  科室
 @param activityModelString  科室
 @return        测试消息对象
 */
+ (instancetype)messageWithTitle:(NSString *)title withShowUrl:(NSString *)showUrl withDetailLabel:(NSString *)detailLabel withSenateModelString:(NSString *)senateModelString withTemplateString:(NSString *)templateString ;
@end
