//
//  NSString+IDCardVerify.h
//  Micropulse
//
//  Created by 黄云高 on 2016/12/13.
//  Copyright © 2016年 iChoice. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (IDCardVerify)

#pragma 正则匹配用户身份证号
+ (BOOL)validateIDCardNumber:(NSString *)idCard;

+ (NSInteger)getIDCardSex:(NSString *)card;   //得到身份证的性别（1男0女）

+ (NSInteger)getAgeWithIdCard:(NSString *)idCard;


@end
