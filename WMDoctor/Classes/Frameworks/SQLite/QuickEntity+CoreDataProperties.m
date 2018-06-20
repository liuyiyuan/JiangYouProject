//
//  QuickEntity+CoreDataProperties.m
//  
//
//  Created by JacksonMichael on 2017/7/26.
//
//

#import "QuickEntity+CoreDataProperties.h"

@implementation QuickEntity (CoreDataProperties)

+ (NSFetchRequest<QuickEntity *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"QuickEntity"];
}

@dynamic contentText;
@dynamic order;
@dynamic userId;
@dynamic theType;

@end
