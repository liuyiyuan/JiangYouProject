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

//保存一条回复草稿
+ (void)saveQuestionEntity:(WMQuestionDraftModel *)entity{
    
    
    
    NSManagedObjectContext * context = [NSManagedObjectContext MR_defaultContext];
    
    QuestionEntity * question = [QuestionEntity MR_createEntityInContext:context];
    question.questionId = entity.questionId;
    question.userId = entity.userId;
    question.context = entity.context;
    question.theTime = entity.theTime;
    
    [context MR_saveToPersistentStoreAndWait];
}

@end
