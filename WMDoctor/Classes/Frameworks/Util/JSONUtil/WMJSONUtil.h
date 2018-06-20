//
//  WMJSONUtil.h
//  WMDoctor
//
//  Created by choice-ios1 on 16/12/15.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WMJSONUtil : NSObject

#pragma mark Deserializing methods

+ (NSString *)stringWithJSONObject:(id)obj;

+ (NSString *)stringWithJSONObject:(id)obj failureHander:(void (^)(NSError *error))hander;

#pragma mark Serializing methods

+ (id)JSONObjectWithString:(NSString *)string;

+ (id)JSONObjectWithString:(NSString *)string failureHander:(void (^)(NSError *error))hander;

@end
