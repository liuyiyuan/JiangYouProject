//
//  WMGroupActivityModel.h
//  WMDoctor
//
//  Created by xugq on 2017/8/9.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMJSONModel.h"

@interface WMGroupActivityModel : WMJSONModel

//疾病话题评论数
@property(nonatomic, copy)NSString<Optional> *commentNum;
//描述
@property(nonatomic, copy)NSString<Optional> *desc;
//图片地址
@property(nonatomic, copy)NSString<Optional> *img;
//流水号
@property(nonatomic, copy)NSString<Optional> *liushuihao;
//活动的分享图片地址
@property(nonatomic, copy)NSString<Optional> *shareImgUrl;
//标题
@property(nonatomic, copy)NSString<Optional> *title;
//类型: 1:新闻咨询 ； 2. 活动 3；疾病话题
@property(nonatomic, copy)NSString<Optional> *type;
//链接地址
@property(nonatomic, copy)NSString<Optional> *url;

@end
