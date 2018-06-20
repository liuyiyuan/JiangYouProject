//
//  DateTimeUtil.m
//  Micropulse
//
//  Created by choice-ios1 on 16/1/4.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import "DateTimeUtil.h"

@implementation DateTimeUtil

+ (NSString *)stringFromDate:(NSDate*)aDate formatter:(NSString *)formatter
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    NSTimeZone * UTCzone = [[NSTimeZone alloc] initWithName:@"UTC"];
//    [dateFormatter setTimeZone:UTCzone];
//    NSLocale * lacale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
//    [dateFormatter setLocale:lacale];
    [dateFormatter setDateFormat:formatter];
    NSString *destDate= [dateFormatter stringFromDate:aDate];

    return destDate;
}
+ (NSDate *)dateFromString:(NSString *)aDateString formatter:(NSString *)formatter
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];

    [dateFormatter setDateFormat:formatter];
    NSDate * destDate = [dateFormatter dateFromString:aDateString];
    
    return destDate;
}
/**********************************************************/

+ (NSString *)getWeekdayFromDate:(NSDate*)date withPrefix:(NSString*)prefix
{
    NSDateComponents * components = [self dateComponentsFromDate:date];
    if (!components) {
        return @"";
    }
    NSUInteger weekday = [components weekday];
    
    NSArray<NSString*>* weekArray = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六",];
    NSString *_prefix = prefix?prefix:@"星期";
    NSString *weekdaystring = [NSString stringWithFormat:@"%@%@",_prefix,weekArray[weekday-1]];
    
    return weekdaystring;
}
+ (NSInteger)getYearFromDate:(NSDate*)date
{
    NSDateComponents * components = [self dateComponentsFromDate:date];
    
    if (!components) {
        //error year is -1
        return -1;
    }
    return components.year;
}
+ (NSInteger)getMonthFromDate:(NSDate*)date
{
    NSDateComponents * components = [self dateComponentsFromDate:date];
    
    if (!components) {
        //error year is -1
        return -1;
    }
    return components.month;
}
+ (NSInteger)getDayFromDate:(NSDate*)date
{
    NSDateComponents * components = [self dateComponentsFromDate:date];
    
    if (!components) {
        //error year is -1
        return -1;
    }
    return components.day;
}

+ (NSInteger)numberDaysInMonthOfDate:(NSDate *)date
{
    
    NSCalendar *calender = [NSCalendar currentCalendar];
    
    NSRange range = [calender rangeOfUnit:NSCalendarUnitDay
                     
                                   inUnit: NSCalendarUnitMonth
                     
                                  forDate: date];
    return range.length;
}
+ (NSDate *)getDateByAddMonths:(NSInteger)monthNumber forDate:(NSDate *)date{
    NSCalendar *calendar = [self getCalendar];
    NSDateComponents *comps = nil;
    comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    [adcomps setYear:0];
    [adcomps setMonth:monthNumber];
    [adcomps setDay:0];
    NSDate *newDate = [calendar dateByAddingComponents:adcomps toDate:date options:0];
    return newDate;
}
+ (NSCalendar*)getCalendar
{
    static NSCalendar * calendar = nil;
    
    if (!calendar) {
        calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    }
    return calendar;
}

+ (NSDateComponents*)dateComponentsFromDate:(NSDate*)date
{
    static NSDateComponents * components = nil;
    
    if (!components) {
        
        components = [[NSDateComponents alloc] init];
    }
    components = [[self getCalendar] components:NSCalendarUnitYear |
                  NSCalendarUnitMonth |
                  NSCalendarUnitDay |
                  NSCalendarUnitWeekday |
                  NSCalendarUnitHour |
                  NSCalendarUnitMinute |
                  NSCalendarUnitSecond
                                       fromDate:date];
    
    return components;
}
@end
