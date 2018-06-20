//
//  WMDevice.h
//  Micropulse
//
//  Created by choice-ios1 on 15/4/15.
//  Copyright (c) 2015年 ENJOYOR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WMDevice : NSObject

+ (WMDevice*)currentDevice;

/**
 *  "My iPhone"
 */
- (NSString *)deviceName;

// e.g. @"4.0"
- (NSString *)systemVersion;

// e.g. @"iOS"
- (NSString *)systemName;

// e.g. @"iPhone 20"
- (NSString *)deviceModel;

// e.g. @"1.1.0"
- (NSString *)appVersion;

// application identifier
- (NSString *)uuidString;

@end
