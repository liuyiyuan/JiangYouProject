//
//  LKCOneRecord.h
//  OctobarBaby
//
//  Created by lazy-thuai on 14-7-5.
//  Copyright (c) 2014年 luckcome. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  一个监听记录模型
 */
@interface LKCOneRecord : NSObject <NSCoding>

@property (strong, nonatomic) NSMutableArray *hearts;                   // 监护数据，是一个数组
@property (assign, nonatomic) NSTimeInterval monitorDuration;           // 记录的时间
@property (assign, nonatomic) NSInteger      totalFetalMove;            // 胎动总数
@property (assign, nonatomic) NSTimeInterval startTimeInterval;         // 开始记录的时间
@property (assign, nonatomic) NSInteger      recordWeek;
@property (assign, nonatomic) NSInteger      recordDay;
@property (assign, nonatomic) NSInteger      needUpOrDown;
@property (assign, nonatomic) BOOL           historyEdit;
@property (assign, nonatomic) BOOL           chooseCell;
@property (assign, nonatomic) BOOL           doc_replay;
@property (assign, nonatomic) BOOL           UpOrNot;
@property (assign, nonatomic) BOOL           TocoOrNot;

@property (assign, nonatomic) BOOL           isUploaded;
@property (assign, nonatomic) BOOL           isConsoled;

@property (assign, nonatomic) BOOL           used;

@property (strong, nonatomic) NSString      *choose_mid;
@property (strong, nonatomic) NSString      *Blu_number;
@property (strong, nonatomic) NSString      *history_sceen; //判断该条记录在哪个界面
@property (strong, nonatomic) NSString*       doc_replaynote;           // 医生回复
@property (assign, nonatomic) NSInteger       doc_replayscore;           // 医生回复

@property (strong, nonatomic) NSString      * startTime; //string 类型的开始时间  换为assign 会崩溃
@property (strong, nonatomic) NSString      *womenQuestion;// 孕妇问题
@property (strong, nonatomic) NSString      *hospitalAccount;//院内监护时 存储用户账号
@property (strong, nonatomic) NSString      *ppid;//院内监护时 存储医院账号

@end
