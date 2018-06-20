//
//  WMUserAgentUtil.m
//  Micropulse
//
//  Created by choice-ios1 on 2017/8/30.
//  Copyright © 2017年 iChoice. All rights reserved.
//

#import "WMUserAgentUtil.h"
#import "WMDevice.h"

@implementation WMUserAgentUtil

+ (void)loadUserAgentWithPayToken:(NSString *)token {
    
    static UIWebView *webView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    });
    NSString *oldAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    NSLog(@"old agent :%@", oldAgent);
    
    LoginModel * loginModel = [WMLoginCache getMemoryLoginModel];
    
    NSString *appVersion = [[WMDevice currentDevice] appVersion];
    NSString *systemName = [[WMDevice currentDevice] systemName];
    NSString *systemVersion = [[WMDevice currentDevice] systemVersion];
    NSString *deviceModel = [[WMDevice currentDevice] deviceModel];
    NSString *payToken = token;
    NSString *doctorId = [NSString stringWithFormat:@"%@",loginModel.userId];
    
    NSString *newAgentForH5 = [NSString stringWithFormat:@" WMDoctor/%@ (%@ %@; %@; Client Doctor; PayToken %@; DoctorId %@;)",appVersion,systemName,systemVersion,deviceModel,payToken,doctorId];
    NSString *newAgent = [oldAgent stringByAppendingString:newAgentForH5];

    NSLog(@"new agent :%@", newAgent);
    
    NSDictionary *dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:newAgent, @"UserAgent", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
    
}


@end
