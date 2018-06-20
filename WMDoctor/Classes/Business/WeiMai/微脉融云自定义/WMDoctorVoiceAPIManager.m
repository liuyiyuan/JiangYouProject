//
//  WMDoctorVoiceAPIManager.m
//  WMDoctor
//
//  Created by xugq on 2017/9/29.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMDoctorVoiceAPIManager.h"

@implementation WMDoctorVoiceAPIManager

- (NSString *)methodName{
    return @"/doctor_sound/records";
}

- (HTTPMethodType)requestType{
    return Method_GET;
}

- (LoadingEffertType)loadingEffertType{
    return LoadingEffertTypeNone;
}

@end
