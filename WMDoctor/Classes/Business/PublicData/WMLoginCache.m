//
//  WMLoginCache.m
//  WMDoctor
//
//  Created by choice-ios1 on 16/12/27.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import "WMLoginCache.h"

@interface WMLoginCache()

+ (WMLoginCache *)shareInstance;

@property (nonatomic,strong) LoginModel * loginModel;

@end

@implementation WMLoginCache

+ (WMLoginCache *)shareInstance
{
    static WMLoginCache * instace = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instace = [[WMLoginCache alloc] init];
    });
    return instace;
}

+ (void)setDiskLoginModel:(LoginModel*)model
{
    NSString * filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.archive"];
    // 归档
    [NSKeyedArchiver archiveRootObject:model toFile:filePath];
}
+ (LoginModel *)getDiskLoginModel
{
    NSString * filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.archive"];
    
    LoginModel *account = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    return account;
}
+ (void)setMemoryLoginModel:(LoginModel*)model
{
    [WMLoginCache shareInstance].loginModel = model;
}

+ (LoginModel *)getMemoryLoginModel
{
    return [[WMLoginCache shareInstance] loginModel];
}

+ (void)removeMemoryModel
{
    [WMLoginCache shareInstance].loginModel = nil;
}


@end
