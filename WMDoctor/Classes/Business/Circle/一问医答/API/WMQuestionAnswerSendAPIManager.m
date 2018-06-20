//
//  WMQuestionAnswerSendAPIManager.m
//  WMDoctor
//
//  Created by JacksonMichael on 2017/11/28.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMQuestionAnswerSendAPIManager.h"

@implementation WMQuestionAnswerSendAPIManager
-(NSString *)methodName
{
    return @"/doctor_answer/preservation_answer_record";
}

- (HTTPMethodType)requestType
{
    return Method_POST;
}

- (LoadingEffertType)loadingEffertType
{
    return LoadingEffertTypeDefault;
}
@end
