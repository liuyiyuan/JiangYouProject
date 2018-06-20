//
//  WMLoginCache.h
//  WMDoctor
//
//  Created by choice-ios1 on 16/12/27.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginModel.h"

@interface WMLoginCache : NSObject


+ (void)setDiskLoginModel:(LoginModel*)model;

+ (LoginModel *)getDiskLoginModel;

+ (void)setMemoryLoginModel:(LoginModel*)model;

+ (LoginModel *)getMemoryLoginModel;

+ (void)removeMemoryModel;

@end
