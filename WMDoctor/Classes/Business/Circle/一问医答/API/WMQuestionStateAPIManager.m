//
//  WMQuestionStateAPIManager.m
//  WMDoctor
//
//  Created by xugq on 2017/11/23.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMQuestionStateAPIManager.h"

@implementation WMQuestionStateAPIManager

-(NSString *)methodName
{
    return @"/doctor_answer/question_state";
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
