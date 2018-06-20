//
//  QuestionEntity+CoreDataProperties.m
//  
//
//  Created by JacksonMichael on 2017/12/26.
//
//

#import "QuestionEntity+CoreDataProperties.h"

@implementation QuestionEntity (CoreDataProperties)

+ (NSFetchRequest<QuestionEntity *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"QuestionEntity"];
}

@dynamic context;
@dynamic questionId;
@dynamic userId;
@dynamic theTime;

@end
