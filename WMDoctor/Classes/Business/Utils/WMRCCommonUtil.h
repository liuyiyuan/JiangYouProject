//
//  WMRCCommonUtil.h
//  Micropulse
//
//  Created by 茭白 on 2017/8/3.
//  Copyright © 2017年 iChoice. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 * 该类 专门用于处理 融云的公共方法
 */
@interface WMRCCommonUtil : NSObject
/**
 * 该方法 跳转到目标单聊 目标页面
 * parameter ：targetId -- 对方融云号
 * parameter ：isNormalType -- 是否普通模式
 * parameter ：isSendRemind -- 是否需要发送提醒
 * parameter ：navigationController -- 当前navigationController
 */
+(void)jumpToChatVCWithTargetId:(NSString *)targetId
                       withTitleName:(NSString * )titleName
                       withDingdanhao:(NSString * )dingdanhao
                       withType:(BOOL )isNormalType
                 withSendRemind:(BOOL )isSendRemind
                 isFromDelegateDoctor:(BOOL )delegateDoctor
       withNavigationController:(UINavigationController *)navigationController;



/**
 * 该方法 跳转到群聊 目标页面
 * parameter ：groupId -- 群融云号
 * parameter ：navigationController -- 当前navigationController
 */
+(void)jumpToGroupVCWithGroupId:(NSString *)groupId
                       withType:(BOOL )isNormalType
       withNavigationController:(UINavigationController *)navigationController;


/**
 * 该方法 用于 Lib单聊聊天列表页面 最后一条消息内容
 * parameter ：RCConversation --会话类 所以消息的基类
 * detailStr ：异步返回 显示详情
 */
+(void)chatListDetailShowWith:(RCConversation *)model detailStr:(void (^)(NSString*))detailStr;

/**
 * 该方法 用于 Lib群聊聊天列表页面 最后一条消息内容
 * parameter ：RCConversation --会话类 所以消息的基类
 * detailStr ：异步返回 显示详情
 */
+(void)groupChatListDetailShowWith:(RCConversation *)model detailStr:(void (^)(NSString*))detailStr;


/**
 * 该方法  用于 Kit单聊聊天列表页面 最后一条消息内容
 * parameter ：RCConversation --会话类 所以消息的基类
 * detailStr ：异步返回 显示详情
 */
+(void)chatListDetailShowWithKit:(RCConversationModel *)model detailStr:(void (^)(NSString*))detailStr;

/**
 * 该方法 用于 Kit群聊聊天列表页面 最后一条消息内容
 * parameter ：RCConversation --会话类 所以消息的基类
 * detailStr ：异步返回 显示详情
 */
+(void)groupChatListDetailShowWithKit:(RCConversationModel *)model detailStr:(void (^)(NSString*))detailStr;

+ (void)getPatientsInfoWithUserId:(NSString *)userId loadSuccessed:(void (^)(void))loadSuccessed;

@end
