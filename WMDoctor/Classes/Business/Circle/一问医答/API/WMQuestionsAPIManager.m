//
//  WMQuestionsAPIManager.m
//  WMDoctor
//
//  Created by xugq on 2017/11/20.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMQuestionsAPIManager.h"

@implementation WMQuestionsAPIManager

-(NSString *)methodName
{
    return @"/doctor_answer/answer_question_records";
}

- (HTTPMethodType)requestType
{
    return Method_GET;
}

- (LoadingEffertType)loadingEffertType
{
    return LoadingEffertTypeDefault;
}

@end
