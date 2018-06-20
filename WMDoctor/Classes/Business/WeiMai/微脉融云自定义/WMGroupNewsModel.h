//
//  WMGroupNewsModel.h
//  Micropulse
//
//  Created by 茭白 on 2017/8/11.
//  Copyright © 2017年 iChoice. All rights reserved.
//

#import "WMJSONModel.h"

@interface WMGroupNewsModel : WMJSONModel
@property (nonatomic , copy)NSString *commentNum;//评论数目
@property (nonatomic , copy)NSString *liushuihao;//流水号
@property (nonatomic , copy)NSString *shareImgUrl;//分享Url
@property (nonatomic , copy)NSString *type;//类型
@property (nonatomic , copy)NSString *url;//连接Url
@end
