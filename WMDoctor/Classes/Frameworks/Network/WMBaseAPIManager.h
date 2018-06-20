//
//  WMBaseAPIManager.h
//  Micropulse
//
//  Created by zhangchaojie on 16/3/28.
//  Copyright © 2016年 ENJOYOR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMRequestSerializerGenerate.h"
#import "WMNetworkLoadingEffect.h"
#import "WMNetworkConfig.h"

@protocol WMAPIManager <NSObject>

@required


/**
 * 请求URL相对路径
 */
- (NSString *)methodName;
/**
 * 请求类型，目前包含get，post，put，delete
 */

- (HTTPMethodType)requestType;

@optional
- (LoadingEffertType)loadingEffertType;
- (CachePolicyType)cachePolicyType;
- (Class)classType;
- (BOOL)isHideErrorTip;
- (NSTimeInterval)requestTimeoutInterval;
@end

@class WMBaseAPIManager;
@protocol WMAPIManagerApiCallBackDelegate <NSObject>
@required
- (void)managerCallAPIDidSuccess:(id)responseObject withDataTask:(NSURLSessionDataTask *)task;
- (void)managerCallAPIDidFailed:(ResponseResult *)errorResult;
@end


typedef void(^FormDataBlock)(id <AFMultipartFormData> formData);
/**
 * APIManager 基类，需子类继承来实现 WMAPIManager 非正式协议
 */
@interface WMBaseAPIManager : NSObject

@property (nonatomic, weak) id<WMAPIManagerApiCallBackDelegate> delegate;
@property (nonatomic, weak) NSObject<WMAPIManager> *child;

@property (nonatomic, strong)AFHTTPSessionManager *manager;

@property (nonatomic, strong)WMRequestSerializerGenerate *requestSerializerGenerate;

@property (nonatomic, strong)WMNetworkLoadingEffect *loadEffectManager;

@property (nonatomic, strong) ResponseResult * result;


/**
 * 为请求设置 formData，多用于上传接口
 
 @param formDataBlock 在内部设置回调
 */
- (void)setFormDataBlock:(FormDataBlock)formDataBlock;

/**
 * 发起请求（代理模式调用）

 @param param 入参
 @return ...
 */
- (NSInteger)loadDataWithParams:(NSDictionary *)param;


/**
 * 发起请求（block模式调用）

 @param param 入参
 @param success 成功回调
 @param failure 失败回调
 @return ...
 */
- (NSInteger)loadDataWithParams:(NSDictionary *)param withSuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))success withFailure:(void (^)(ResponseResult *errorResult))failure;

- (void)cancelAllRequests;


@end
