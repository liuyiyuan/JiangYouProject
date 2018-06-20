//
//  LKCHistoryManager.h
//  OctobarBaby
//
//  Created by lazy-thuai on 14-7-6.
//  Copyright (c) 2014年 luckcome. All rights reserved.
//

#import <Foundation/Foundation.h>
extern NSString * const LKCHistoryManagerNotificationHistoryChanged;
extern NSString * const LKCHistoryManagerNotificationHistoryDeleted;

@class LKCOneRecord;

@class WomenModel;

/**
 *  监听历史记录管理类
 */
@interface LKCHistoryManager : NSObject

@property (strong, nonatomic) NSMutableArray *records;//所有的历史数据，里面存储的是LKCOneRecord＊
@property (nonatomic , strong) NSMutableArray * netRecordArr;
@property (nonatomic , strong) NSMutableArray * localRecordArr;


+ (instancetype)shareHistoryManager;

- (void)archiveRecordToHistory:(LKCOneRecord *)oneRecord;
- (void)unarchiveRecordFromHistory;

- (NSString *)getRecordFilePath;
- (NSString *)getAudioFilePath;

- (void)deleteAllHistory;
- (void)deleteSelectHistory:(LKCOneRecord *)oneRecord;
- (NSArray *)getFilenamelistOfType:(NSString *)type fromDirPath:(NSString *)dirPath;




-(void)fullNetWorkArr;
@end
