//
//  WMQuestionExpiredAPIManager.m
//  WMDoctor
//
//  Created by JacksonMichael on 2017/12/28.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMQuestionExpiredAPIManager.h"

@implementation WMQuestionExpiredAPIManager
-(NSString *)methodName
{
    return @"/doctor_answer/freeze_expired";
}

- (HTTPMethodType)requestType
{
    return Method_PUT;
}

- (LoadingEffertType)loadingEffertType
{
    return LoadingEffertTypeDefault;
}
@end
