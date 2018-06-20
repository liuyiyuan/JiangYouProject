//
//  RCDGroupInfo.h
//  Micropulse
//
//  Created by 茭白 on 2016/11/11.
//  Copyright © 2016年 iChoice. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>

@interface RCDGroupInfo : RCGroup
/** 人数 */
@property(nonatomic, strong) NSString *number;
/** 最大人数 */
@property(nonatomic, strong) NSString *maxNumber;
/** 群简介 */
@property(nonatomic, strong) NSString *introduce;

/** 创建者Id */
@property(nonatomic, strong) NSString *creatorId;
/** 创建日期 */
@property(nonatomic, strong) NSString *creatorTime;
/** 是否加入 */
@property(nonatomic, assign) BOOL isJoin;
/** 是否解散 */
@property(nonatomic, strong) NSString *isDismiss;


@end
