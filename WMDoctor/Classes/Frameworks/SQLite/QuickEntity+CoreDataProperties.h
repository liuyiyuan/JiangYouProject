//
//  QuickEntity+CoreDataProperties.h
//  
//
//  Created by JacksonMichael on 2017/7/26.
//
//

#import "QuickEntity+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface QuickEntity (CoreDataProperties)

+ (NSFetchRequest<QuickEntity *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *contentText;
@property (nullable, nonatomic, copy) NSNumber *order;
@property (nullable, nonatomic, copy) NSString *userId;
@property (nullable, nonatomic, copy) NSString *theType;

@end

NS_ASSUME_NONNULL_END
