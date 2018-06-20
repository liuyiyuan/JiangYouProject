//
//  RCUserInfo+WMAddition.h
//  Micropulse
//
//  Created by 茭白 on 16/8/29.
//  Copyright © 2016年 iChoice. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>

@interface RCUserInfo (WMAddition)
/**
 用户信息类
 */
/** 用户ID */
@property(nonatomic, strong) NSString *userId;//用户ID用户融云连接
/** 用户名*/
@property(nonatomic, strong) NSString *name;
/** 头像URL*/
@property(nonatomic, strong) NSString *portraitUri;

/** sex*/
@property(nonatomic, strong) NSString *sex;

/** type  0患者 1 医生或助理*/
@property(nonatomic, strong) NSString *type;

/**     1:vip患者 ；0普通患者*/
@property(nonatomic, strong) NSString *vip;

/**     标签名字，可以有多个*/
@property(nonatomic, strong) NSArray *tagNames;


/**
 
 指派的初始化方法，根据给定字段初始化实例
 
 @param userId          用户ID
 @param sex        用户名
 @param portrait        头像URL
 
 */
- (instancetype)initWithUserId:(NSString *)userId portrait:(NSString *)portrait sex:(NSString *)sex type:(NSString *)type;

@end
