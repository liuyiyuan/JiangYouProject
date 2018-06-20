

typedef NS_ENUM(NSUInteger, TodayCompare) {
    //当天<指同一天，不区分时分秒>
    TodayCompareCurrent =0,
    //今天之前的日期
    TodayCompareEarlier,
    //今天之后的日期
    TodayCompareLater,
};
#import <UIKit/UIKit.h>

@interface NSDate (TimeAgo)

- (NSString *) timeAgo;

- (NSString *)timeAgoForWemay;

- (NSString *) timeRemaining;

/**
 *  判断此日期是不是当天日期
 *
 *  @return enum
 */
- (TodayCompare)todayCompare;




@end

