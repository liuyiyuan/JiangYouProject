//
//  WMScoreTaskModel.h
//  WMDoctor
//
//  Created by JacksonMichael on 2017/11/28.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMJSONModel.h"

@protocol WMScoreTaskDetailModel;
@interface WMScoreTaskDetailModel : WMJSONModel

@property (nonatomic,copy) NSString * buttonText;

@property (nonatomic,copy) NSString * finishNum;

@property (nonatomic,copy) NSString * score;

@property (nonatomic,copy) NSString * status;

@property (nonatomic,copy) NSString * taskCode;

@property (nonatomic,copy) NSString * taskDesc;

@property (nonatomic,copy) NSString * taskName;

@end

@protocol WMScoreTaskListModel;
@interface WMScoreTaskListModel : WMJSONModel

@property (nonatomic,strong) NSArray<WMScoreTaskDetailModel> * taskRuleList;

@property (nonatomic,copy) NSString * taskTypeId;

@property (nonatomic,copy) NSString * taskTypeName;

@end

@interface WMScoreTaskModel : WMJSONModel

@property (nonatomic,strong) NSArray<WMScoreTaskListModel> * tasks;

@end
