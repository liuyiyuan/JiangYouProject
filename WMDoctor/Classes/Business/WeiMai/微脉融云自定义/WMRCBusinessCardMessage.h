//
//  WMRCBusinessCardMessage.h
//  WMDoctor
//
//  Created by 茭白 on 2017/3/23.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>
/*!
 测试消息的类型名
 */
#define     WMRCBusinessCardMessageTypeIdentifier @"RCD:WMBusinessCardMsg"

/*!
 Demo测试用的自定义消息类
 
 @discussion Demo测试用的自定义消息类，此消息会进行存储并计入未读消息数。
 */

@interface WMRCBusinessCardMessage : RCMessageContent
/*!
 主题
 */
@property(nonatomic, strong) NSString *title;
/*!
 医院名称
 */
@property(nonatomic, strong) NSString *hospital;

/*!
 医生名字
 */
@property(nonatomic, strong) NSString *name;
/*!
 医生头像url
 */
@property(nonatomic, strong) NSString *headUrl;
/*!
 名片label
 */
@property(nonatomic, strong) NSString *cardLabel;
/*!
 名片label
 */
@property(nonatomic, strong) NSString *department;



/*!
 测试消息的附加信息
 */
@property(nonatomic, strong) NSString *extra;

/*!
 初始化测试消息
 @param title 文本内容
 @param name 文本内容
 @param hospital 文本内容
 @param headUrl 文本内容
 @param cardLabel 文本内容
 @param department  科室
 @return        测试消息对象
 */
+ (instancetype)messageWithTitle:(NSString *)title withDoctorName:(NSString *)name withHospital:(NSString *)hospital withHeadUrl:(NSString *)headUrl withDepartment:(NSString *)department withCardStr:(NSString *)cardLabel ;
@end
