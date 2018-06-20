//
//  WMQuestionModel.h
//  WMDoctor
//
//  Created by xugq on 2017/11/21.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMJSONModel.h"

@interface WMQuestionModel : WMJSONModel

/**
 提问时间
 */
@property (nonatomic,copy) NSString * askTime;

/**
 问题内容
 */
@property (nonatomic,copy) NSString * content;

/**
 价格
 */
@property (nonatomic,copy) NSString * price;

/**
 问题id
 */
@property (nonatomic,copy) NSString * questionId;

/**
 问题状态 1：待解答 2：被抢答 3：已解答 4：已关闭 5：解答中
 */
@property (nonatomic,copy) NSString * state;


@end
