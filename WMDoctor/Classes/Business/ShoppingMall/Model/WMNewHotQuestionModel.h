//
//  WMNewHotQuestionModel.h
//  WMDoctor
//
//  Created by xugq on 2018/7/31.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "WMJSONModel.h"

@interface WMNewHotQuestionModel : WMJSONModel

@property (nonatomic,copy) NSString <Optional> *qaContent;//问答内容
@property (nonatomic,copy) NSString <Optional> *qaID;//问答编号
@property (nonatomic,copy) NSString <Optional> *topNewsContent;//新闻资讯标题
@property (nonatomic,copy) NSString <Optional> *topNewsID;//新闻资讯流水号
@property (nonatomic,copy) NSString <Optional> *bottomNewsContent;//新闻资讯标题
@property (nonatomic,copy) NSString <Optional> *bottomNewsID;//新闻资讯流水号
@property (nonatomic,copy) NSString <Optional> *type;//判断是问答还是咨询 qa问答 其他咨询

@end
