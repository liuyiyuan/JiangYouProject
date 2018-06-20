//
//  NSString+Regular.h
//  WMDoctor
//
//  Created by choice-ios1 on 16/12/15.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 * 正则匹配相关类
 */
@interface NSString (Regular)


/**
 * 匹配字符串是否为数字

 @return 符合 YES 否则 NO
 */
- (BOOL)isNumber;

/**
 * 匹配字符串是否符合手机号标准

 @return 符合 YES 否则 NO
 */
- (BOOL)isMobileNumber;

/**
 * 匹配字符串是否符合邮箱标准

 @return 符合 YES 否则 NO
 */
- (BOOL)isEmail;


/**
 * 匹配字符串是否符合大陆身份证标准

 @return 符合 YES 否则 NO
 */
- (BOOL)isIDCardNumber;


/**
 * 获取身份证性别(需要事先校验下是否是正确的身份证)

 @return 1男0女，不符合条件者为2
 */
- (NSInteger)getIDCardSex;


/**
 * 获取身份证的年龄(需要事先校验下是否是正确的身份证)

 @return 当前身份证的年龄
 */
- (NSInteger)getIDCardAge;


@end
