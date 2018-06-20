//
//  QuestionEntity+CoreDataProperties.h
//  
//
//  Created by JacksonMichael on 2017/12/26.
//
//

#import "QuestionEntity+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface QuestionEntity (CoreDataProperties)

+ (NSFetchRequest<QuestionEntity *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *context;
@property (nullable, nonatomic, copy) NSString *questionId;
@property (nullable, nonatomic, copy) NSString *userId;
@property (nullable, nonatomic, strong) NSDate *theTime;

@end

NS_ASSUME_NONNULL_END
