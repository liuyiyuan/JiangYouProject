//
//  QuestionEntity+CoreDataClass.m
//  
//
//  Created by JacksonMichael on 2017/12/26.
//
//

#import "QuestionEntity+CoreDataClass.h"

@implementation QuestionEntity

//获取一条回复草稿
+ (QuestionEntity *)getQuestionEntityWith:(NSString *)userId andQuestionId:(NSString *)questionId{
    
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@" userId = %@ and questionId = %@ ",userId,questionId];
    
    QuestionEntity * question = [QuestionEntity MR_findFirstWithPredicate:predicate sortedBy:@"theTime" ascending:NO];

    return question;
    
}


@end
