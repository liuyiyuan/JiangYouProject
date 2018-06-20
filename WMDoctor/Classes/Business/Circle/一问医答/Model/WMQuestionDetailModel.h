//
//  WMQuestionDetailModel.h
//  WMDoctor
//
//  Created by JacksonMichael on 2017/11/24.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMJSONModel.h"

@interface WMQuestionDetailInfoModel : WMJSONModel

//问题回答内容
@property (nonatomic,copy) NSString<Optional> * answerContent;

//问题内容
@property (nonatomic,copy) NSString<Optional> * content;

//医生所在科室名称
@property (nonatomic,copy) NSString<Optional> * departmentName;

//医生头像
@property (nonatomic,copy) NSString<Optional> * doctorImage;

//医生名称
@property (nonatomic,copy) NSString<Optional> * doctorName;

//医生所在机构名称
@property (nonatomic,copy) NSString<Optional> * organizationName;

//价格
@property (nonatomic,copy) NSString<Optional> * price;

//图片索引
@property (nonatomic,copy) NSMutableArray<Optional> * pritureIndexs;

//问题ID
@property (nonatomic,copy) NSString<Optional> * questionId;

//问题结束时间
@property (nonatomic,copy) NSString<Optional> * remainingTime;

//问题状态 1：待解答 2：被抢答 3：已解答 4：已关闭
@property (nonatomic,copy) NSString * state;

//医生职称
@property (nonatomic,copy) NSString<Optional> * title;

@property (nonatomic,copy) NSString<Optional> * freezeTime;

@end

@interface WMQuestionDetailModel : WMJSONModel

@property (nonatomic,strong) WMQuestionDetailInfoModel * doctorQuestionDetailVo;



@end


