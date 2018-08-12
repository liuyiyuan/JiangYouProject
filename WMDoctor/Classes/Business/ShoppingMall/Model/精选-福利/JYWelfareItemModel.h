//
//  JYWelfareItemModel.h
//  WMDoctor
//
//  Created by xugq on 2018/8/12.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "WMJSONModel.h"

@interface JYWelfareOneItemModel : WMJSONModel

@property(nonatomic, strong)NSString *classId;
@property(nonatomic, strong)NSString *className;
@property(nonatomic, strong)NSString *classPic;

@end

@protocol JYWelfareOneItemModel;
@interface JYWelfareItemModel : WMJSONModel

@property(nonatomic, strong)NSArray<JYWelfareOneItemModel> *classArray;

@end
