//
//  QuickEntity+CoreDataClass.h
//  
//
//  Created by JacksonMichael on 2017/7/26.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface QuickEntity : NSManagedObject



//获取快捷回复列表
+ (NSMutableArray *)getQuickEntityList:(NSString *)userId andType:(NSString *)type;

@end

NS_ASSUME_NONNULL_END

#import "QuickEntity+CoreDataProperties.h"
