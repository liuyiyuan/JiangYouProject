//
//  WMNewsInfomationModel.h
//  WMDoctor
//
//  Created by xugq on 2018/5/29.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "WMJSONModel.h"

@interface WMNewsInfomationModel : WMJSONModel

@property (nonatomic ,copy)NSString *content;//内容
@property (nonatomic ,copy)NSString *image;//图片
@property (nonatomic ,copy)NSString *introduction;//简介
@property (nonatomic ,copy)NSString *newsId;//资讯id
@property (nonatomic ,copy)NSString *shareLink;//分享链接
@property (nonatomic ,copy)NSString *title;//标题
@property (nonatomic ,copy)NSString *type;//content内容类型 1：是超链接 2：文本

@end


@interface WMDoctorInfoNewsModel:WMJSONModel

@property (nonatomic, strong)WMNewsInfomationModel *doctorNewsDetailVo;

@end
