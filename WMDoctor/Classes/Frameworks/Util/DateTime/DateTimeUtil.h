//
//  DateTimeUtil.h
//  Micropulse
//
//  Created by choice-ios1 on 16/1/4.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import <Foundation/Foundation.h>

//API专用
#define  FORMAT_MODE_HTTP   @"yyyy-MM-dd'T'HH:mm:ss Z"

#define  FORMAT_MODE_REGULAR_LONG @"yyyy-MM-dd HH:mm:ss"

#define  FORMAT_MODE_REGULAR_TUIHAO @"yyyy-MM-dd HH:mm"

#define  FORMAT_MODE_REGULAR_SHORT @"yyyy-MM-dd"


@interface DateTimeUtil : NSObject

+ (NSString *)stringFromDate:(NSDate*)aDate formatter:(NSString *)formatter;

+ (NSDate *)dateFromString:(NSString *)aDateString formatter:(NSString *)formatter;


/**
 * 获取日期是星期几/周几

 @param date 需要计算的日期
 @param prefix 前缀，值应为『星期』/『周』
 @return 星期几/周几，如果日期错误，返回空字符串 @""
 */
+ (NSString *)getWeekdayFromDate:(NSDate*)date withPrefix:(NSString*)prefix;

/**
 * 获取日期所在的年份

 @param date 需要计算的日期
 @return 返回当前年份，error year is -1
 */
+ (NSInteger)getYearFromDate:(NSDate*)date;

/**
 * 获取日期所在的月份

 @param date 需要计算的日期
 @return 返回当前月份，error month is -1
 */
+ (NSInteger)getMonthFromDate:(NSDate*)date;

/**
 * 获取日期所在的天数
 
 @param date 需要计算的日期
 @return 返回当前日期天数，error day is -1
 */
+ (NSInteger)getDayFromDate:(NSDate*)date;


/**
 * 当前日期+月份之后的新日期

 @param monthNumber 所加的月份
 @param date 原始日期
 @return 返回当前日期+月份之后的新日期
 */
+ (NSDate *)getDateByAddMonths:(NSInteger)monthNumber forDate:(NSDate *)date;


/**
 * 当前日期所在的月份有多少天

 @param date 传入日期
 @return 当前日期所在的月份天数
 */
+ (NSInteger)numberDaysInMonthOfDate:(NSDate *)date;
@end
