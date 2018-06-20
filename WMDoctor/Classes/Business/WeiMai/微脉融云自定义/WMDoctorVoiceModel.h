//
//  WMDoctorVoiceModel.h
//  WMDoctor
//
//  Created by xugq on 2017/9/29.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMJSONModel.h"

@interface WMDoctorVoiceModel : WMJSONModel

//医生头像
@property (nonatomic , copy)NSString *doctorImage;
//医生姓名
@property (nonatomic , copy)NSString<Optional> *doctorName;
//已听人数
@property (nonatomic , copy)NSString *listenedNum;
//发布时间
@property (nonatomic , copy)NSString *releaseTime;
//录音文件索引（oss上调取）
@property (nonatomic , copy)NSString *soundFileIndex;
//该条录音id
@property (nonatomic , copy)NSString *soundId;
//录音时长
@property (nonatomic , copy)NSString *timeLength;
//标题
@property (nonatomic , copy)NSString *title;

@end
