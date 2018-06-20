//
//  AppConfig.h
//  Micropulse
//
//  Created by choice-ios1 on 16/6/15.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, WorkEnvironment)
{
    WorkInRelease    = 0,//正式
    WorkInDevelop    = 1,//开发
    WorkInTest       = 2,//测试
    WorkInPreRelease = 3,//预发
 
};

@interface EnvironmentModel : JSONModel
//名称
@property (nonatomic,copy) NSString * name;
//域名
@property (nonatomic,copy) NSString * content;

@end



@interface AppConfig : NSObject

//获取当前运行的库
+ (WorkEnvironment)currentEnvir;

//获取URLs 模型数组
+ (NSMutableArray<EnvironmentModel*> *)httpURLs;

//保存当前选择的库
+ (void)saveEnvirWithIndex:(WorkEnvironment)index;

@end

