//
//  WMReplyMessage.h
//  WMDoctor
//
//  Created by xugq on 2018/3/26.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>
#define     WMRCReplyMessageTypeIdentifier @"RCD:WMReplyMsg"

@interface WMReplyMessage : RCMessageContent

/*!
 回复对象名称
 */
@property(nonatomic, strong) NSString *targetName;

/*!
 回复对象提问的问题
 */
@property(nonatomic, strong) NSString *targetContent;

/*!
 回复的内容
 */
@property(nonatomic, strong) NSString *replyMessage;



/*
 
 @param replyObjName 回复对象名称
 @param replyObjQuestion 回复对象提问的问题
 @param replyContent 回复的内容
 */
+ (instancetype)messageWithTargetName:(NSString *)targetName
                   withTargetContent:(NSString *)targetContent
                        withReplyMessage:(NSString *)replyMessage;


@end
