//
//  QuickEntity+CoreDataClass.h
//  
//
//  Created by JacksonMichael on 2017/7/26.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "WMQuickReplyModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QuickEntity : NSManagedObject

//获取某条快捷回复
+ (WMQuickReplyModel *)getQuickEntity:(NSString *)userId andTheType:(NSString *)type;

//保存一条快捷回复
+ (void)saveQuickEntity:(WMQuickReplyModel *)model;

//删除某条快捷回复
+ (void)deleteQuickEntity:(NSString *)userId andTheType:(NSString *)type andTheText:(NSString *)text;

//获取快捷回复列表
+ (NSMutableArray *)getQuickEntityList:(NSString *)userId andType:(NSString *)type;

@end

NS_ASSUME_NONNULL_END

#import "QuickEntity+CoreDataProperties.h"
