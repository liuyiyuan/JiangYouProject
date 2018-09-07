//
//  QuestionEntity+CoreDataClass.h
//  
//
//  Created by JacksonMichael on 2017/12/26.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface QuestionEntity : NSManagedObject

+ (QuestionEntity *)getQuestionEntityWith:(NSString *)userId andQuestionId:(NSString *)questionId;


@end

NS_ASSUME_NONNULL_END

#import "QuestionEntity+CoreDataProperties.h"
