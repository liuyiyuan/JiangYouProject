//
//  WMQuestionDetailAPIManager.m
//  WMDoctor
//
//  Created by JacksonMichael on 2017/11/24.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMQuestionDetailAPIManager.h"
#import "WMQuestionDetailModel.h"

@implementation WMQuestionDetailAPIManager
-(NSString *)methodName
{
    return @"/doctor_answer/answer_question_record";
}

- (HTTPMethodType)requestType
{
    return Method_GET;
}

- (LoadingEffertType)loadingEffertType
{
    return LoadingEffertTypeDefault;
}

-(Class)classType{
    
    return [WMQuestionDetailModel class];
}
@end
