//
//  WMPatientReportedModel.m
//  WMDoctor
//
//  Created by 茭白 on 2016/12/28.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import "WMPatientReportedModel.h"

@implementation WMPatientReportedModel
+ (JSONKeyMapper *)keyMapper
{
    
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"focusTime":@"focusTime",
                                                                  @"freshMark":@"freshMark",
                                                                  @"headPicture":@"headPicture",
                                                                  @"name":@"name",
                                                                  @"phone":@"phone",
                                      @"sex":@"sex",                            @"weimaihao":@"weimaihao",
                                                                  @"acceptMark":@"acceptMark",
                                                                  @"sackName":@"sackName",
                                                                  @"liushuihao":@"liushuihao",
                                    @"visitDate":@"visitDate"
                                                                  }];
}
@end
@implementation WMPatientReportedDataModel

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"list":@"list",
                                                                  @"totalPage":@"totalPage",
                                                                  @"currentPage":@"currentPage"
                                                                                                    }];
}
 
@end

@implementation WMPatientHealthModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end

@implementation WMPatientDataModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end

@implementation WMOneMemberModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end
@implementation WMGroupMemberModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end

@implementation WMPatientTagModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end

@implementation WMPatientModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end

@implementation WMTagGroupModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end


