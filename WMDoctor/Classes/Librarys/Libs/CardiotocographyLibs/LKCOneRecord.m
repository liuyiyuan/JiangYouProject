//
//  LKCOneRecord.m
//  OctobarBaby
//
//  Created by lazy-thuai on 14-7-5.
//  Copyright (c) 2014年 luckcome. All rights reserved.
//

#import "LKCOneRecord.h"

@implementation LKCOneRecord

/**
 1、为了将应用数据存储到硬盘中，iOS提供基本的文件API、Property List序列化、SQLite、CoreData以及NSCoding。对于轻量级的数据要求，NSCoding因其简单而成为一种比较合适的方式。 NSCoding是一个你需要在数据类上要实现的协议以支持数据类和数据流间的编码和解码。数据流可以持久化到硬盘。
 2、是类对象本身数据的写入到本地文件。
 
 我 们需要实现两个方法: encodeWithCoder和initWithEncoder。encodeWithCoder就是编码，initWithCoder就是解码。 encodeWithCoder方法传入的是一个NSCoder对象，实现的时候我们就可以调用encodeObject、encodeFloat、 encodeInt等各种方法并通过指定键值进行编码。
 **/
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.hearts = [coder decodeObjectForKey:@"hearts"];
        self.monitorDuration = [coder decodeDoubleForKey:@"monitorDuration"];
        self.totalFetalMove = [coder decodeIntegerForKey:@"totalFetalMove"];
        self.startTimeInterval = [coder decodeDoubleForKey:@"startTimeInterval"];
        self.recordWeek = [coder decodeIntegerForKey:@"recordWeek"];
        self.recordDay = [coder decodeIntegerForKey:@"recordDay"];
        self.needUpOrDown = [coder decodeIntegerForKey:@"needUpOrDown"];
        self.choose_mid = [coder decodeObjectForKey:@"choose_mid"];
        self.Blu_number = [coder decodeObjectForKey:@"Blu_number"];
        self.history_sceen = [coder decodeObjectForKey:@"history_sceen"];
        self.doc_replay = [coder decodeBoolForKey:@"doc_replay"];
        self.isUploaded = [coder decodeBoolForKey:@"isUploaded"];
        self.isConsoled = [coder decodeBoolForKey:@"isConsoled"];
        self.used = [coder decodeBoolForKey:@"used"];

        
        
        self.UpOrNot = [coder decodeBoolForKey:@"UpOrNot"];
        self.TocoOrNot = [coder decodeBoolForKey:@"TocoOrNot"];
        
        self.doc_replaynote = [coder decodeObjectForKey:@"doc_replaynote"];
        self.doc_replayscore = [coder decodeIntegerForKey:@"doc_replayscore"];
        self.womenQuestion = [coder decodeObjectForKey:@"womenQuestion"];
        self.startTime = [coder decodeObjectForKey:@"startTime"];
        self.hospitalAccount = [coder decodeObjectForKey:@"hospitalAccount"];
        self.ppid = [coder decodeObjectForKey:@"ppid"];
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.hearts forKey:@"hearts"];
    [aCoder encodeDouble:self.monitorDuration forKey:@"monitorDuration"];
    [aCoder encodeInteger:self.totalFetalMove forKey:@"totalFetalMove"];
    [aCoder encodeDouble:self.startTimeInterval forKey:@"startTimeInterval"];
    [aCoder encodeInteger:self.recordDay forKey:@"recordDay"];
    [aCoder encodeInteger:self.recordWeek forKey:@"recordWeek"];
    [aCoder encodeInteger:self.needUpOrDown forKey:@"needUpOrDown"];
    [aCoder encodeObject: self.choose_mid forKey:@"choose_mid"];
    [aCoder encodeObject: self.Blu_number forKey:@"Blu_number"];
    [aCoder encodeObject: self.history_sceen forKey:@"history_sceen"];
    [aCoder encodeBool:(BOOL)self.doc_replay forKey:@"doc_replay"];
    [aCoder encodeBool:(BOOL)self.UpOrNot forKey:@"UpOrNot"];
    [aCoder encodeBool:(BOOL)self.TocoOrNot forKey:@"TocoOrNot"];
      [aCoder encodeBool:(BOOL)self.isConsoled forKey:@"isConsoled"];
      [aCoder encodeBool:(BOOL)self.isUploaded forKey:@"isUploaded"];
     [aCoder encodeBool:(BOOL)self.used forKey:@"used"];
    
    
    [aCoder encodeObject:self.doc_replaynote forKey:@"doc_replaynote"];
    [aCoder encodeInteger:self.doc_replayscore forKey:@"doc_replayscore"];
    
    [aCoder encodeObject:self.womenQuestion forKey:@"womenQuestion"];
    [aCoder encodeObject:self.startTime forKey:@"startTime"];
    [aCoder encodeObject:self.hospitalAccount forKey:@"hospitalAccount"];
    [aCoder encodeObject:self.ppid forKey:@"ppid"];
}

@end
