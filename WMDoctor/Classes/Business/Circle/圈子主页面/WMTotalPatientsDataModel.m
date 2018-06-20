//
//  WMTotalPatientsDataModel.m
//  WMDoctor
//
//  Created by 茭白 on 2017/2/27.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMTotalPatientsDataModel.h"


@implementation WMTotalPatientsModel
/* + (JSONKeyMapper *)keyMapper
{
       return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"focusTime":@"focusTime",
                                                                  @"headPicture":@"headPicture",
                                                                  @"name":@"name",
                                                                  @"phone":@"phone",
                                                                  @"sex":@"sex",                            @"weimaihao":@"weimaihao",
                                                                  @"type":@"type"
                                                                  }];
 

}*/
@end


@implementation WMTotalPatientsDataModel
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"list":@"list",
                                                                  @"totalPage":@"totalPage",
                                                                  @"currentPage":@"currentPage"
                                                                  }];
}

@end
