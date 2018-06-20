//
//  WMCacheModel.h
//  Micropulse
//
//  Created by zhangchaojie on 16/8/24.
//  Copyright © 2016年 iChoice. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WMCacheModel : NSObject<NSCoding>

@property (nonatomic,strong) NSDate * cacheTime;

@property (nonatomic,copy) id<NSCoding> jsonObject;

@end
