//
//  LKCHistoryManager.m
//  OctobarBaby
//
//  Created by lazy-thuai on 14-7-6.
//  Copyright (c) 2014年 luckcome. All rights reserved.
//

#import "LKCHistoryManager.h"
#import "LKCOneRecord.h"

#define UserDefaults                        [NSUserDefaults standardUserDefaults]
#define NotificationCenter                  [NSNotificationCenter defaultCenter]

//没有用到
NSString * const LKCHistoryManagerNotificationHistoryChanged = @"LKCHistoryManagerNotificationHistoryChanged";

// LKCHistoryManager的deleteAllHistory发送;LKCTabBarController的onHistoryDeleted接受处理
NSString * const LKCHistoryManagerNotificationHistoryDeleted = @"LKCHistoryManagerNotificationHistoryDeleted";


@implementation LKCHistoryManager

//创建单例
+ (instancetype)shareHistoryManager
{
    static LKCHistoryManager *historyManager = nil;
    static dispatch_once_t onceToken;// 单例
    dispatch_once(&onceToken, ^{
        historyManager = [[LKCHistoryManager alloc] init];
    });
    return historyManager;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.records = [[NSMutableArray alloc] initWithCapacity:0];
        self.localRecordArr = [[NSMutableArray alloc] initWithCapacity:0];
           }
    return self;
}
-(void)fullNetWorkArr{
    NSLog(@"历史记录中  同步数据");
    
    //![self accessToTheNetworkData];
}
/*
- (void)accessToTheNetworkData{
    
    self.httpManager = [LKCHttpManager shareInstance];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        int ret = [self.httpManager getAllList];//1: 获取所有列表
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // [self.wrapper dismissView:viewNowupdate];
            
            if (ret == 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [UserDefaults setObject:@"1" forKey:@"isFirstLocal"];
                    [NotificationCenter postNotificationName:@"netRecordSuccess" object:nil userInfo:nil];
                });

                self.netRecordArr = [self.httpManager.allHttpList.lists mutableCopy];
                 
            } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                         [UserDefaults removeObjectForKey:@"isFirstLocal"];
                        [NotificationCenter postNotificationName:@"netRecordfail" object:nil];
            
                    });
            }
            
        });
    });
    
}
*/

/**
 *  打包一次监听记录为历史数据
 */
- (void)archiveRecordToHistory:(LKCOneRecord *)oneRecord
{
    //  [self.records addObject:oneRecord];
    NSString *recordFile = [self getRecordFilePath];
    
    long long startTime      =  oneRecord.startTimeInterval * 1000;
    
    NSString *archiveFielPath = [recordFile stringByAppendingPathComponent:[NSString stringWithFormat:@"%lld.rtf", startTime]];
    
    
    NSLog(@"打包一次监听记录 ====== %@",archiveFielPath);
    // NSString *archiveFielPath = [recordFile stringByAppendingPathComponent:[NSString stringWithFormat:@"%f.rtf", oneRecord.startTimeInterval]];
    [NSKeyedArchiver archiveRootObject:oneRecord toFile:archiveFielPath];//写入一个文件,NSKeyedArchiver--对象归档(对象归档是指将对象写入文件再硬盘上，当再次重新打开文件时，可以还原这些对象)
}

/**
 *  解包所有的历史数据，是不是太多了？，进入一次"记录"执行一次
 */
- (void)unarchiveRecordFromHistory
{
    // 清除掉所有的记录
    [self.records removeAllObjects];
    //recordDir = /var/mobile/Containers/Data/Application/AD8E024B-E8EB-4FCE-B279-E3B36D33EA21/Documents/records
    //file[0] = "1419498840.322080.rtf"
    NSString *recordDir = [self getRecordFilePath];
    NSArray *files = [self getFilenamelistOfType:@"rtf" fromDirPath:recordDir];//返回所有的 .rtf文件
    
    if (files.count > 0) {
        [files enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSString *recordFilePath = [recordDir stringByAppendingPathComponent:obj];//recordFilePath ＝ 全路径/xx.rtf
            NSLog(@"%@",recordFilePath);
            LKCOneRecord *oneRecord = [NSKeyedUnarchiver unarchiveObjectWithFile:recordFilePath];
            NSLog(@"%@ ------- %@",oneRecord,[NSKeyedUnarchiver unarchiveObjectWithFile:recordFilePath]);
            [self.records addObject:oneRecord];//从一个文件读取数据,NSKeyedUnarchiver--反归档
        }];

    }
    
}

//返回records目录下的所有 .rtf文件; firpath = xxxxx/records/
- (NSArray *)getFilenamelistOfType:(NSString *)type fromDirPath:(NSString *)dirPath
{
    NSMutableArray *filenamelist = [NSMutableArray arrayWithCapacity:10];
    NSArray *tmplist = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:dirPath error:nil];//查找文件夹的内容，如 /records/1418441019.939042.rtf
    
    for (NSString *filename in tmplist) {
        NSString *fullpath = [dirPath stringByAppendingPathComponent:filename];
        if ([self isFileExistAtPath:fullpath]) {
            if ([[filename pathExtension] isEqualToString:type]) {//pathExtension:路径最后部分的扩展名
                [filenamelist  addObject:filename];
            }
        }
    }
    
    return filenamelist;
}

- (BOOL)isFileExistAtPath:(NSString*)fileFullPath {
    BOOL isExist = NO;
    isExist = [[NSFileManager defaultManager] fileExistsAtPath:fileFullPath];
    return isExist;
}

/**
 *  获取历史记录在手机中的保存目录
 *  1:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES):
 *          获取document目录（存放该应用程序需要持久保存的数据）看《文件管理中的沙盒一节》
 *  2:NSTemporaryDirectiory:
 获取tmp路径  （存放临时文件）
 */
- (NSString *)getRecordFilePath
{
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *recordDataDir = [docDir stringByAppendingPathComponent:@"records"];
    NSError *error = nil;
    //该路径是否存在，如果不存在则需要创建
    if (![[NSFileManager defaultManager] fileExistsAtPath:recordDataDir]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:recordDataDir withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            NSLog(@"create record history directory error");
        }
    }
    return recordDataDir;
}

/**
 *  删除所有的历史记录，被LKCMoreViewController的clearnupData调用
 */
- (void)deleteAllHistory
{
    // 删除音频文件//audioDir为音频数据存放地址
    NSString *audioDir = [self getAudioFilePath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    [fileManager removeItemAtPath:audioDir error:&error];
    if (error) {
        NSLog(@"remove audio directory failure");
    }
    
    NSString *recordDir = [self getRecordFilePath];
    [fileManager removeItemAtPath:recordDir error:&error];
    if (error) {
        NSLog(@"remove record direcotry failure");
    }
    
    [NotificationCenter postNotificationName:LKCHistoryManagerNotificationHistoryDeleted object:nil];
}

/**
 *  删除被选中的历史记录
 */
- (void)deleteSelectHistory:(LKCOneRecord *)oneRecord
{
    long long startTime      =  oneRecord.startTimeInterval * 1000;
    [self.records removeObject:oneRecord];
    NSString *recordFile = [self getRecordFilePath];
    NSString *audioDir = [self getAudioFilePath];
    
    
    
    
    NSString *archiveFilePath = [recordFile stringByAppendingPathComponent:[NSString stringWithFormat:@"%lld.rtf",startTime]];
    NSString *wavFilePath = [audioDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%lld.mp3",startTime]];
    NSString * wavFilePathwav = [audioDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%lld.wav",startTime]];
    
    NSFileManager *f = [NSFileManager defaultManager];
    NSError *error = nil;
    
    if ([f fileExistsAtPath:archiveFilePath])
    {
        [f removeItemAtPath:archiveFilePath error:&error];
    }
    
    if ([f fileExistsAtPath:wavFilePath])
    {
        [f removeItemAtPath:wavFilePath error:&error];
        
    }
    if ([f fileExistsAtPath:wavFilePathwav]) {
        [f removeItemAtPath:wavFilePathwav error:&error];
        
    }
    
    NSAssert(error == nil, @"删除文件错误");
}



/**
 *  获取音频文件在手机中的保存路径
 */
- (NSString *)getAudioFilePath
{
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *recordDataDir = [docDir stringByAppendingPathComponent:@"audios"];
    NSError *error = nil;
    if (![[NSFileManager defaultManager] fileExistsAtPath:recordDataDir]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:recordDataDir withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            NSLog(@"create record history directory error");
        }
    }
    return recordDataDir;
}

@end
