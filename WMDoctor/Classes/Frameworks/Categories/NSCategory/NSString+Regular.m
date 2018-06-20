//
//  NSString+Regular.m
//  WMDoctor
//
//  Created by choice-ios1 on 16/12/15.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import "NSString+Regular.h"

@implementation NSString (Regular)

- (BOOL)isNumber
{
    NSString *regex = @"^\\d$";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [test evaluateWithObject:self];
}
- (BOOL)isMobileNumber
{
    //    NSString *regex = @"^((13[0-9])|(14[5,7])|(15[^4,\\D])|(17[0,6,7,8,9])|(18[0-9]))\\d{8}$";
    NSString *regex = @"^((1[3,4,5,7,8,6,9]))\\d{9}$";      //仅限制手机第二位几个号码段的数字(3,4,5,7,8)可以通过，后面除长度外不限制
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [test evaluateWithObject:self];
}

- (BOOL)isEmail
{
    NSString *regex = @"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [test evaluateWithObject:self];
}
/***************************************************************************/
- (BOOL)isIDCardNumber
{
    NSString *idCard = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    int length =0;
    if (!idCard) {
        return NO;
    }else {
        length = (int)idCard.length;
        
        if (length !=15 && length !=18) {
            return NO;
        }
    }
    // 省份代码
    NSArray *areasArray =@[@"11",@"12", @"13",@"14", @"15",@"21", @"22",@"23", @"31",@"32", @"33",@"34", @"35",@"36", @"37",@"41", @"42",@"43", @"44",@"45", @"46",@"50", @"51",@"52", @"53",@"54", @"61",@"62", @"63",@"64", @"65",@"71", @"81",@"82", @"91"];
    
    NSString *valueStart2 = [idCard substringToIndex:2];
    BOOL areaFlag =NO;
    for (NSString *areaCode in areasArray) {
        if ([areaCode isEqualToString:valueStart2]) {
            areaFlag =YES;
            break;
        }
    }
    
    if (!areaFlag) {
        return NO;
    }
    
    NSRegularExpression *regularExpression;
    NSUInteger numberofMatch;
    
    int year =0;
    switch (length) {
        case 15:
            year = [idCard substringWithRange:NSMakeRange(6,2)].intValue +1900;
            
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$"
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$"
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:idCard
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, idCard.length)];
            
            if(numberofMatch >0) {
                return YES;
            }else {
                return NO;
            }
        case 18:
            
            year = [idCard substringWithRange:NSMakeRange(6,4)].intValue;
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19|20[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19|20[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:idCard
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, idCard.length)];
            
            
            if(numberofMatch >0) {
                int S = ([idCard substringWithRange:NSMakeRange(0,1)].intValue + [idCard substringWithRange:NSMakeRange(10,1)].intValue) *7 + ([idCard substringWithRange:NSMakeRange(1,1)].intValue + [idCard substringWithRange:NSMakeRange(11,1)].intValue) *9 + ([idCard substringWithRange:NSMakeRange(2,1)].intValue + [idCard substringWithRange:NSMakeRange(12,1)].intValue) *10 + ([idCard substringWithRange:NSMakeRange(3,1)].intValue + [idCard substringWithRange:NSMakeRange(13,1)].intValue) *5 + ([idCard substringWithRange:NSMakeRange(4,1)].intValue + [idCard substringWithRange:NSMakeRange(14,1)].intValue) *8 + ([idCard substringWithRange:NSMakeRange(5,1)].intValue + [idCard substringWithRange:NSMakeRange(15,1)].intValue) *4 + ([idCard substringWithRange:NSMakeRange(6,1)].intValue + [idCard substringWithRange:NSMakeRange(16,1)].intValue) *2 + [idCard substringWithRange:NSMakeRange(7,1)].intValue *1 + [idCard substringWithRange:NSMakeRange(8,1)].intValue *6 + [idCard substringWithRange:NSMakeRange(9,1)].intValue *3;
                int Y = S %11;
                NSString *M =@"F";
                NSString *JYM =@"10X98765432";
                M = [JYM substringWithRange:NSMakeRange(Y,1)];// 判断校验位
                if ([M isEqualToString:[idCard substringWithRange:NSMakeRange(17,1)]]) {
                    return YES;// 检测ID的校验位
                }else {
                    return NO;
                }
                
            }else {
                return NO;
            }
        default:
            return NO;
    }
}
- (NSInteger)getIDCardSex
{
    NSString *card = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([card length] == 18) {
        NSInteger number = [[card substringWithRange:NSMakeRange(16,1)] integerValue];
        if (number % 2 == 0) {  //偶数为女
            return 0;
        } else {
            return 1;
        }
    }
    if ([card length] == 15) {
        NSInteger number = [[card substringWithRange:NSMakeRange(14,1)] integerValue];
        if (number % 2 == 0) {  //偶数为女
            return 0;
        } else {
            return 1;
        }
    }
    
    return 2;
}

- (NSInteger)getIDCardAge
{
    NSString *idCard = self;
    NSInteger length = (NSInteger)[idCard length];
    NSInteger age = 0;
    NSInteger year = 0;
    
    switch (length) {
        case 15:
        {
            year = [idCard substringWithRange:NSMakeRange(6,2)].integerValue + 1900;
            NSString *birthDay = [NSString stringWithFormat:@"%li%@%@", (long)year, [idCard substringWithRange:NSMakeRange(8,2)], [idCard substringWithRange:NSMakeRange(10,2)]];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyyMMdd"];
            NSString *nowDay = [dateFormatter stringFromDate:[NSDate date]];
            
            age = ([nowDay integerValue] - [birthDay integerValue]) / 10000;
        }
            break;
        case 18:
        {
            year = [idCard substringWithRange:NSMakeRange(6,4)].integerValue;
            NSString *birthDay = [NSString stringWithFormat:@"%li%@%@", (long)year, [idCard substringWithRange:NSMakeRange(10,2)], [idCard substringWithRange:NSMakeRange(12,2)]];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyyMMdd"];
            NSString *nowDay = [dateFormatter stringFromDate:[NSDate date]];
            
            age = ([nowDay integerValue] - [birthDay integerValue]) / 10000;
        }
            break;
            
        default:
            break;
    }
    
    return age;
}
@end
