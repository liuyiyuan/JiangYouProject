//
//  WMFunctionUtil.m
//  Micropulse
//
//  Created by choice-ios1 on 15/8/31.
//  Copyright (c) 2015年 ENJOYOR. All rights reserved.
//

#import "WMFunctionUtil.h"

@implementation WMFunctionUtil


/** 获取Json数据时传入字典和想要创建的model的名字 */
+(void)createJsonModelWithDictionary:(NSDictionary *)dict modelName:(NSString *)modelName
{
    printf("\n#pragma - mark <#类功能简介#>\n");
    printf("\n@interface %s : WMJSONModel\n",modelName.UTF8String);
    for (NSString * key in dict) {
        NSString * type = ([dict[key] isKindOfClass:[NSNumber class]])?@"NSNumber":@"NSString";
        NSString * property = ([dict[key] isKindOfClass:[NSString class]])?@"copy":@"strong";
        printf("\n//<#属性描述#>\n");
        printf("@property (nonatomic,%s) %s * %s;\n",property.UTF8String,type.UTF8String,key.UTF8String);
    }
    printf("\n@end\n");
    
}
@end
