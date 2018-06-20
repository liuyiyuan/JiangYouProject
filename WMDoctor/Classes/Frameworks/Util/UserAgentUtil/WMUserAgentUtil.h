//
//  WMUserAgentUtil.h
//  Micropulse
//
//  Created by choice-ios1 on 2017/8/30.
//  Copyright © 2017年 iChoice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WMUserAgentUtil : NSObject


/**
 更新UserAgent信息
 备注：登陆成功需要调用一次，更新用户的logid<H 5使用字段>，其他调用均为token更新而用

 @param token 金服token
 */
+ (void)loadUserAgentWithPayToken:(NSString *)token;

@end
