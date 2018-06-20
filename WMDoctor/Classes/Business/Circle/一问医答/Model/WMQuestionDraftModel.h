//
//  WMQuestionDraftModel.h
//  WMDoctor
//
//  Created by JacksonMichael on 2017/12/28.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMJSONModel.h"

@interface WMQuestionDraftModel : WMJSONModel

@property (nonatomic,copy) NSString * questionId;
@property (nonatomic,copy) NSString * userId;
@property (nonatomic,copy) NSString * context;
@property (nonatomic,strong) NSDate * theTime;

@end
