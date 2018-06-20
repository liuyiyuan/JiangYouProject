//
//  WMJSONUtil.m
//  WMDoctor
//
//  Created by choice-ios1 on 16/12/15.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import "WMJSONUtil.h"

static NSString *errorDomain = @"com.choice.wemay";
static NSInteger errorCode = -10086;
static NSString *errorMessage = @"格式不正确";

@implementation WMJSONUtil

+ (NSString *)stringWithJSONObject:(id)obj
{
    return [self stringWithJSONObject:obj failureHander:NULL];

}
+ (NSString *)stringWithJSONObject:(id)obj failureHander:(void (^)(NSError *error))hander
{
    NSParameterAssert(obj);
    BOOL isvaild = [NSJSONSerialization isValidJSONObject:obj];
    if (!isvaild) {
        NSError * error = [NSError errorWithDomain:errorDomain code:errorCode userInfo:@{NSLocalizedDescriptionKey:errorMessage}];

        if (hander) {
            hander(error);
        }else{
            NSLog(@"WMJSONUtil:stringWithJSONObject:ErrorDomain=%@ErrorMessage=%@",error.domain,error.localizedDescription);
        }
        return nil;
    }
    NSError * error = nil;
    NSData * data = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        if (hander) {
            hander(error);
        }else{
            NSLog(@"WMJSONUtil:stringWithJSONObject:ErrorDomain=%@ErrorMessage=%@",error.domain,error.localizedDescription);
        }
    }else{
        NSString * string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        return string;
    }
    
    return nil;

}
+ (id)JSONObjectWithString:(NSString *)string
{
    return [self JSONObjectWithString:string failureHander:NULL];
}
+ (id)JSONObjectWithString:(NSString *)string failureHander:(void (^)(NSError *error))hander
{
    NSParameterAssert(string);
    NSError * error = nil;
    
    id object = [NSJSONSerialization JSONObjectWithData:[string dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
    if (error) {
        if (hander) {
            hander(error);
        }else{
            NSLog(@"WMJSONUtil:JSONObjectWithString:ErrorDomain=%@ErrorMessage=%@",error.domain,error.localizedDescription);
        }
    }else{
        return object;
    }
    return nil;
}

@end
