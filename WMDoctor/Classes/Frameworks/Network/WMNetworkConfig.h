//
//  WMNetworkConfig.h
//  Micropulse
//
//  Created by zhangchaojie on 16/4/19.
//  Copyright © 2016年 ENJOYOR. All rights reserved.
//

#import <Foundation/Foundation.h>

UIKIT_EXTERN NSString *const WMURLResponseErrorDomain;


UIKIT_EXTERN NSString *const WMJSONModelErrorLocalizedDescription;


@interface WMNetworkConfig : NSObject

typedef NS_ENUM(NSUInteger, HTTPMethodType) {
    Method_GET =1,
    Method_POST,
    Method_PUT,
    Method_DELETE
};

typedef NS_ENUM(NSInteger, LoadingEffertType)
{
    LoadingEffertTypeNone            = 1,//无加载动画
    LoadingEffertTypeDefault          = 2,//默认加载动画，转圈
    LoadingEffertTypeCustom           = 3,//自定义加载动画
};

typedef NS_ENUM(NSUInteger, CachePolicyType) {
    CachePolicyType_None = -1,
    CachePolicyType_AtOnce = 0,
    CachePolicyType_Short = 60 * 3,
    CachePolicyType_Normal = 60 * 30,
    CachePolicyType_Long = 60 * 60 * 24
};

//微脉错误类型code，与上面的定义错误message搭配使用
typedef NS_ENUM(NSInteger, WMErrorCodeType) {
    
    WMErrorCode_JSONModel          =-521314,
    WMErrorCode_NetWorkBad         = -521315,
    WMErrorCode_ServicerNotConnect = -521316
};


@end


@interface ResponseResult : NSObject

//响应code编码
@property (nonatomic,assign) NSInteger code;
//响应消息体
@property (nonatomic,copy)   NSString *message;
//响应参数<一般用不到，预留>
@property (nonatomic,strong) NSDictionary *userInfo;

+ (ResponseResult*)resultWithError:(NSError*)error;

@end
