//
//  WMFunctionUtil.h
//  Micropulse
//
//  Created by choice-ios1 on 15/8/31.
//  Copyright (c) 2015年 ENJOYOR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WMFunctionUtil : NSObject

/** 获取Json数据时传入字典和想要创建的model的名字 */
+ (void)createJsonModelWithDictionary:(NSDictionary *)dict modelName:(NSString *)modelName;

@end
