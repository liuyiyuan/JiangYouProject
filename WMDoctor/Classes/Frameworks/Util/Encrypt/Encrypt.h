//
//  main.m
//  3DES
//
//  Created by apple on 15/10/22.
//  Copyright © 2015年 apple. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface Encrypt : NSObject

//密匙 key
#define gkey            @"9d29fe54bab2e54f6274b13911eacd5ad9807944"
//偏移量
#define gIv             @"ZG9jdG9yX2tleV9pb3M="

/**
 *  字符串加密
 *
 *  @param data <#data description#>
 *  @param key  <#key description#>
 *
 *  @return <#return value description#>
 */
//- (NSString *)hmacsha1:(NSString *)data secret:(NSString *)key;
+ (NSString *)encryptUseDES:(NSString *)plainText needToReplace:(BOOL)needToReplace;

+ (NSString *)hmacsha1:(NSString *)str secret:(NSString *)key;
@end
