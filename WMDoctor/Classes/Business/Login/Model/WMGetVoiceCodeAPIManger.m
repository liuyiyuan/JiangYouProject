//
//  WMGetVoiceCodeAPIManger.m
//  WMDoctor
//
//  Created by JacksonMichael on 2016/12/28.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import "WMGetVoiceCodeAPIManger.h"

@implementation WMGetVoiceCodeAPIManger

-(NSString *)methodName
{
    return @"/users/voice_code";
}

- (HTTPMethodType)requestType
{
    return Method_GET;
    
}

@end
