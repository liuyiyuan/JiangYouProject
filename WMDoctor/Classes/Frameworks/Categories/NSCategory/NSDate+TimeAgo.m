#import "NSDate+TimeAgo.h"
#import "DateTimeUtil.h"

#define DATE_COMPONENTS (NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekOfYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal)
#define CURRENT_CALENDAR [NSCalendar currentCalendar]

@interface NSDate()
-(NSString *)getLocaleFormatUnderscoresWithValue:(double)value;
@end

@implementation NSDate (TimeAgo)

- (NSString *)timeAgo
{
    NSDate *now = [NSDate date];
    double deltaSeconds = fabs([self timeIntervalSinceDate:now]);
    double deltaMinutes = deltaSeconds / 60.0f;
    
    int minutes;
    
    if (deltaSeconds<60) {
        return [self stringFromFormat:@"%%d %@秒前" withValue:deltaSeconds];
    }
    else if (deltaMinutes < 60)
    {
        return [self stringFromFormat:@"%%d %@分钟前" withValue:deltaMinutes];
    }
    else if (deltaMinutes < (24 * 60))
    {
        minutes = (int)floor(deltaMinutes/60);
        return [self stringFromFormat:@"%%d %@小时前" withValue:minutes];
    }
    else if (deltaMinutes < (24 * 60 * 7))
    {
        minutes = (int)floor(deltaMinutes/(60 * 24));
        return [self stringFromFormat:@"%%d %@天前" withValue:minutes];
    }
    else if (deltaMinutes<(24 * 60 * 365))
    {
        NSInteger year1 = [DateTimeUtil getYearFromDate:self];
        NSInteger year2 = [DateTimeUtil getYearFromDate:now];
        if (year1 == year2)
        {
//            return [NSString stringWithFormat:@"%ld-%ld",(long)[CommonUtil getMonthFromDate:self],(long)[CommonUtil getDayFromDate:self]];
            return [DateTimeUtil stringFromDate:self formatter:@"MM-dd"];
        }
    }
    //NSString * dateString = [CommonUtil stringFromDate:self WithType:DateFormatterType1];
    NSString *dateString = [DateTimeUtil stringFromDate:self formatter:@"yyyy-MM-dd"];
    return dateString;
}

//微脉标准时间格式
- (NSString *)timeAgoForWemay
{
    
//    //实例化一个NSDateFormatter对象
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    
//    
//    //设定时间格式,这里可以设置成自己需要的格式、
//    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//    
//    NSString * thisDate = [dateFormatter stringFromDate:self];
//    //用[NSDate date]可以获取系统当前时间
//    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    
    if ([self isToday]) {
        return [DateTimeUtil stringFromDate:self formatter:@"HH:mm"];
    }else{
        return [DateTimeUtil stringFromDate:self formatter:@"yyyy-MM-dd HH:mm"];

    }
    
}
- (BOOL) isToday
{
    return [self isEqualToDateIgnoringTime:[NSDate date]];
}
- (BOOL) isEqualToDateIgnoringTime: (NSDate *) aDate
{
    NSDateComponents *components1 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    NSDateComponents *components2 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:aDate];
    return ((components1.year == components2.year) &&
            (components1.month == components2.month) &&
            (components1.day == components2.day));
}

- (NSString *)timeRemaining{
    
    //超过一个月不予考虑，挂号有时间限制
    if ([self timeIntervalSinceNow]>2592000) {
        return @"";
    }
    
    double deltaSeconds = fabs([self timeIntervalSinceNow]);
    double deltaMinutes = deltaSeconds / 60.0f;
    
    if (deltaSeconds<60) {
        return @"即将";
    }
    else if (deltaMinutes < 60){
        return [self stringFromFormat:@"%%d%@分钟后" withValue:deltaMinutes];
    }
    else if (deltaMinutes < (24 * 60)){
        return [self stringFromFormat:@"%%d%@小时后" withValue:(int)floor(deltaMinutes/60)];
    }
    else{
        return [self stringFromFormat:@"%%d%@天后" withValue:(int)floor(deltaMinutes/(60 * 24))];
    }
}
- (TodayCompare)todayCompare
{
    NSDateComponents * nowComponents = [self dateComponentsWithDate:[NSDate date]];
    NSDateComponents * currentComponents = [self dateComponentsWithDate:self];    
    if (currentComponents.year<nowComponents.year)
    {
        return TodayCompareEarlier;
    }else if (currentComponents.year>nowComponents.year)
    {
        return TodayCompareLater;
    }else{
        if (currentComponents.month<nowComponents.month)
        {
            return TodayCompareEarlier;
        }else if (currentComponents.month>nowComponents.month)
        {
            return TodayCompareLater;
        }else{
            if (currentComponents.day<nowComponents.day)
            {
                return TodayCompareEarlier;
            }else if (currentComponents.day>nowComponents.day)
            {
                return TodayCompareLater;
            }else{
                return TodayCompareCurrent;
            }
        }
    }
}

- (NSString *) stringFromFormat:(NSString *)format withValue:(NSInteger)value
{
    NSString * localeFormat = [NSString stringWithFormat:format, [self getLocaleFormatUnderscoresWithValue:value]];

    return [NSString stringWithFormat:localeFormat,value];
}

- (NSDateComponents*)dateComponentsWithDate:(NSDate *)date
{
    NSCalendar * calendar = nil;
    
    NSInteger unitFlags = 0;
    
    calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    unitFlags = NSCalendarUnitYear |
    NSCalendarUnitMonth |
    NSCalendarUnitDay |
    NSCalendarUnitWeekday |
    NSCalendarUnitHour |
    NSCalendarUnitMinute |
    NSCalendarUnitSecond;
    NSDateComponents* components = [[NSDateComponents alloc] init];
    
    components = [calendar components:unitFlags fromDate:date];

    return components;

}
// Helper functions

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

/*
 - Author  : Almas Adilbek
 - Method  : getLocaleFormatUnderscoresWithValue
 - Param   : value (Double value of seconds or minutes)
 - Return  : @"" or the set of underscores ("_")
 in order to define exact translation format for specific translation rules.
 (Ex: "%d _seconds ago" for "%d секунды назад", "%d __seconds ago" for "%d секунда назад",
 and default format without underscore %d seconds ago" for "%d секунд назад")
 Updated : 12/12/2012
 
 Note    : This method must be used for all languages that have specific translation rules.
 Using method argument "value" you must define all possible conditions language have for translation
 and return set of underscores ("_") as it is an ID for locale format. No underscore ("") means default locale format;
 */
-(NSString *)getLocaleFormatUnderscoresWithValue:(double)value
{
    NSString *localeCode = [[NSLocale preferredLanguages] objectAtIndex:0];
    
    // Russian (ru)
    if([localeCode isEqual:@"ru"]) {
        int XY = (int)floor(value) % 100;
        int Y = (int)floor(value) % 10;
        
        if(Y == 0 || Y > 4 || (XY > 10 && XY < 15)) return @"";
        if(Y > 1 && Y < 5 && (XY < 10 || XY > 20))  return @"_";
        if(Y == 1 && XY != 11)                      return @"__";
    }
    
    // Add more languages here, which are have specific translation rules...
    
    return @"";
}

#pragma clang diagnostic pop

@end
