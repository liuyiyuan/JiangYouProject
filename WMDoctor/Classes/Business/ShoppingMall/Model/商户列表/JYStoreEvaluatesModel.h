//
//  JYStoreEvaluatesModel.h
//  WMDoctor
//
//  Created by xugq on 2018/8/15.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "WMJSONModel.h"

@interface JYStoreSomeOneEvaluateModel : WMJSONModel

@property(nonatomic, strong)NSString *avatar;
@property(nonatomic, strong)NSString *evaluationfraction;
@property(nonatomic, strong)NSString *evaluationinfo;
@property(nonatomic, strong)NSString *evaluationtime;
@property(nonatomic, strong)NSString *realname;

@end

@protocol JYStoreSomeOneEvaluateModel;
@interface JYStoreEvaluatesModel : WMJSONModel

@property(nonatomic, strong)NSArray<JYStoreSomeOneEvaluateModel> *evaluationArray;

@end
