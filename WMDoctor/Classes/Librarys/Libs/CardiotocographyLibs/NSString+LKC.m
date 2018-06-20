//
//  NSString+LKC.m
//  OctobarBaby
//
//  Created by lazy-thuai on 14-6-5.
//  Copyright (c) 2014年 luckcome. All rights reserved.
//

#import "NSString+LKC.h"

@implementation NSString (LKC)

// 将播放时间秒数转成时间字符串
+ (NSString *)formatSecondsToString:(NSTimeInterval)seconds
{
//    NSString *time;
//    long secs = (long)seconds;
//    int min = (int)(secs%3600)/60;
//    int sec = (int)secs%60;
//    time = [NSString stringWithFormat:@"%02d:%02d",min,sec];
//    
//    return time;
    
    NSInteger a =round(seconds) ;
    NSInteger c = a/60;
    NSInteger d = a-c*60;
    
    if (c < 10) {
        if (d < 10) {
            NSString * time  = [NSString stringWithFormat:@"0%ld:0%ld", (long)c,(long)d];
            return time;
        } else {
            NSString * time  = [NSString stringWithFormat:@"0%ld:%ld", (long)c,(long)d];
            return time;
        }
    } else {
        if (d < 10) {
            NSString * time  = [NSString stringWithFormat:@"%ld:0%ld", (long)c,(long)d];
            return time;
        } else {
            NSString * time  = [NSString stringWithFormat:@"%ld:%ld", (long)c,(long)d];
            return time;
        }
    }

}

//将NSTimeInterval转化为指定的时间字符串格式
+ (NSString *)formatSecondsToStringWithformat:(NSString *)formatStr timeSeconds:(NSTimeInterval)seconds
{
    NSString *formatDateStr = nil;
    
    NSDate *formatDate = [NSDate dateWithTimeIntervalSince1970:seconds];
    
    NSDateFormatter *formattter=[[NSDateFormatter alloc] init];
    
    NSTimeZone *formatZone = [NSTimeZone localTimeZone];
    [formattter setTimeZone:formatZone];
    
    [formattter setDateFormat:formatStr];
    
    formatDateStr = [formattter stringFromDate:formatDate];
    
    return formatDateStr;
}

@end
