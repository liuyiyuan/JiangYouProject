//
//  WMBaseAPIManager.m
//  Micropulse
//
//  Created by zhangchaojie on 16/3/28.
//  Copyright © 2016年 ENJOYOR. All rights reserved.
//

#import "WMBaseAPIManager.h"
#import "AFHTTPSessionManager+MultipleRequest.h"
#import "AppConfig.h"
#import "WMCacheModel.h"
#import <PINCache.h>

//默认请求超时时间
static NSTimeInterval const kRequestTimeoutInterval = 60;


@interface WMBaseAPIManager ()

@property (nonatomic,copy) FormDataBlock myFormDataBlock;

- (FormDataBlock)formDataBlock;


@end

@implementation WMBaseAPIManager

-(instancetype)init
{
    self = [super init];
    if (self) {
        _delegate = nil;
        
        EnvironmentModel * envirModel = [[AppConfig httpURLs] objectAtIndex:[AppConfig currentEnvir]];
        
        NSString *baseUrlString = envirModel.content;
        
        NSURLSessionConfiguration * configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        _manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:baseUrlString] sessionConfiguration:configuration];
                
        _requestSerializerGenerate = [WMRequestSerializerGenerate new];
        _loadEffectManager = [WMNetworkLoadingEffect new];
        _result = [ResponseResult new];
        
        AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
        responseSerializer.removesKeysWithNullValues = YES;
        responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"multipart/form-data", nil];
        _manager.responseSerializer = responseSerializer;
        
        if ([self conformsToProtocol:@protocol(WMAPIManager)]) {
            self.child = (NSObject<WMAPIManager>*)self;
        }
    }
    return self;
}
- (void)setFormDataBlock:(FormDataBlock)formDataBlock
{
    _myFormDataBlock = [formDataBlock copy];
}

- (FormDataBlock)formDataBlock
{
    return _myFormDataBlock;
}

- (NSInteger)loadDataWithParams:(NSDictionary *)param
{
    return [self loadDataWithParams:param withSuccess:nil withFailure:nil];
}

- (NSInteger)loadDataWithParams:(NSDictionary *)param withSuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))success withFailure:(void (^)(ResponseResult *errorResult))failure
{
    NSString * urlStr = self.child.methodName;

    _manager.requestSerializer = [_requestSerializerGenerate generateHeaderWithType:self.child.requestType withURL:urlStr withParam:param];
   
    if ([self.child respondsToSelector:@selector(requestTimeoutInterval)]) {
        _manager.requestSerializer.timeoutInterval = self.child.requestTimeoutInterval;
    }else{
        _manager.requestSerializer.timeoutInterval = kRequestTimeoutInterval;
    }
    /*
#warning cache object need edit
    //缓存
    if ([self.child respondsToSelector:@selector(cachePolicyType)] && self.child.cachePolicyType != CachePolicyType_None && [self canLoadCache:self.child.methodName]) {
        [[PINCache sharedCache] objectForKey:urlStr block:^(PINCache * _Nonnull cache, NSString * _Nonnull key, id  _Nullable object)
         {
             id result = ((WMCacheModel *)object).jsonObject;
             
             if ([self.child respondsToSelector:@selector(classType)] && self.child.classType) {
                 //使用JsonModel完成Json转model
                 NSError * error = nil;
                 result = [self jsonToModelWith:result with:&error];
                 if (error) {
                     if (self.delegate) {
                         [self.delegate managerCallAPIDidFailed:error];
                     }
                     if (failure) {
                         failure(error);
                     }
                     return;
                 }
             }
             
             if (self.delegate) {
                 [self.delegate managerCallAPIDidSuccess:result withDataTask:nil];
             }
             if (success) {
                 success(nil, result);
             }
         }];
        
        if (self.child.cachePolicyType != CachePolicyType_AtOnce) {
            return 0;
        }
    }
    */
    
    __weak WMBaseAPIManager *wSelf = self;
    
    //失败回调
    void (^errorBlock)() = ^{
        
        //登陆失效，重新登陆
        if (_result.code == 12002) {
            
            BOOL logincheck = [urlStr containsString:@"/users/login_check"];
            
            [[AppDelegate sharedAppDelegate] loginUnVaildWithAlert:!logincheck];
        }else{
            
            //是否弹出错误提示
            if ([self.child respondsToSelector:@selector(isHideErrorTip)] && self.child.isHideErrorTip) {
            }
            else{
                if (_result.code == 18008) {        //认证接口返回认证失败时不提示
                    
                }else{
                    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
                    [WMHUDUntil showFailWithMessage:_result.message toView:window];
                }
            }
        }
        
        if (self.delegate) {
            [self.delegate managerCallAPIDidFailed:_result];
        }
        if (failure) {
            failure(_result);
        }
    };
    
    
    /**********************************成功回调*********************************************************************************/
    void (^mySuccessBlock)(NSURLSessionDataTask * task, id responseObject) = ^(NSURLSessionDataTask * task, id responseObject){
    
        _result.code = [responseObject[@"resultCode"] integerValue];
        _result.message = responseObject[@"message"];
        _result.userInfo = responseObject[@"data"];
        
        //取消加载动画
        [self dealLoadingEffect:NO];
        
        //请求成功，服务端逻辑错误
        if (_result.code != 200) {
            
            errorBlock();
            
            return;
        }
        
        //请求数据成功，服务端逻辑正确
        //缓存
        if ([self.child respondsToSelector:@selector(cachePolicyType)] && self.child.cachePolicyType != CachePolicyType_None) {
            WMCacheModel *cacheModel = [WMCacheModel new];
            cacheModel.cacheTime = [NSDate date];
            cacheModel.jsonObject = responseObject;
            [[PINCache sharedCache] setObject:cacheModel forKey:urlStr];
        }
        
        id result = responseObject[@"data"];
        
        //使用JsonModel完成Json转model
        if ([self.child respondsToSelector:@selector(classType)] && self.child.classType) {
            NSError * error = nil;
            result = [self jsonToModelWith:result with:&error];
            if (error) {
                _result = [ResponseResult resultWithError:error];
                
                errorBlock();
                return ;
            }
        }
        
        //服务返回正确的数据
        if (self.delegate) {
            [wSelf.delegate managerCallAPIDidSuccess:result withDataTask:task];
        }
        if (success) {
            success(task, result);
        }
    
    };
    /**********************************失败回调*********************************************************************************/

    void (^myErrorBlock)(NSURLSessionDataTask * task, NSError * error) = ^(NSURLSessionDataTask * task, NSError * error){
    
        //取消加载动画
        [self dealLoadingEffect:NO];
        
        NSError * myError = nil;
        
        if ([error.domain isEqualToString:AFURLResponseSerializationErrorDomain]) {
            //AF处理过的返回错误
            NSData * errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
            
            NSError * errorDataError = nil;
            id  errorCallBackJson = [NSJSONSerialization JSONObjectWithData:errorData options:NSJSONReadingMutableContainers error:&errorDataError];
            if (errorDataError||![errorCallBackJson isKindOfClass:[NSDictionary class]]) {
                myError = [[NSError alloc] initWithDomain:WMURLResponseErrorDomain code:WMErrorCode_JSONModel userInfo:@{NSLocalizedDescriptionKey:WMJSONModelErrorLocalizedDescription}];
                
            }else{//错误日志正常解析
                NSDictionary * callBackDic = (NSDictionary*)errorCallBackJson;
                if (callBackDic[@"message"]) {
                    
                    myError = [[NSError alloc] initWithDomain:WMURLResponseErrorDomain code:[callBackDic[@"resultCode"] integerValue] userInfo:@{NSLocalizedDescriptionKey:callBackDic[@"message"],@"data":callBackDic[@"data"]}];
                }
            }
            
        }else{
            myError = error;
        }
        _result = [ResponseResult resultWithError:myError];
        
        errorBlock();
    };
    
    //加载动画
    [self dealLoadingEffect:YES];
    
    NSString *methodType = @"";
    switch (self.child.requestType) {
        case Method_GET:
            methodType = @"GET";
            break;
        case Method_POST:
            methodType = @"POST";
            break;
        case Method_PUT:
            methodType = @"PUT";
            break;
        case Method_DELETE:
            methodType = @"DELETE";
            break;
            
        default:
            break;
    }
    
    NSURLSessionDataTask *dataTask;
    
    if (!_myFormDataBlock) {
        dataTask = [self.manager dataTaskWithHTTPMethod:methodType URLString:urlStr parameters:param uploadProgress:^(NSProgress *uploadProgress) {
            //上传进度
        } downloadProgress:^(NSProgress *downloadProgress) {
            //下载进度
        } success:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull responseObject) {
            
            mySuccessBlock(task,responseObject);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            myErrorBlock(task,error);
        }];
    }else{
        dataTask = [self.manager POST:urlStr parameters:param constructingBodyWithBlock:_myFormDataBlock progress:^(NSProgress * _Nonnull uploadProgress) {
            //上传进度
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            mySuccessBlock(task,responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            myErrorBlock(task,error);
        }];
    }
    
    [dataTask resume];
    
    return 0;
}
/*
- (NSInteger)loadDataWithParams:(NSDictionary *)param constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block withSuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))success withFailure:(void (^)(ResponseResult *errorResult))failure
{
    NSString * urlStr = self.child.methodName;
    
    _manager.requestSerializer = [_requestSerializerGenerate generateHeaderWithType:self.child.requestType withURL:urlStr withParam:param];
    
    if ([self.child respondsToSelector:@selector(requestTimeoutInterval)]) {
        _manager.requestSerializer.timeoutInterval = self.child.requestTimeoutInterval;
    }else{
        _manager.requestSerializer.timeoutInterval = kRequestTimeoutInterval;
    }
    
    __weak WMBaseAPIManager *wSelf = self;
    
    //失败回调
    void (^errorBlock)() = ^{
        
        //登陆失效，重新登陆
        if (_result.code == 12002) {
            
            BOOL logincheck = [urlStr containsString:@"/users/login_check"];
            
            [[AppDelegate sharedAppDelegate] loginUnVaildWithAlert:!logincheck];
        }else{
            
            //是否弹出错误提示
            if ([self.child respondsToSelector:@selector(isHideErrorTip)] && self.child.isHideErrorTip) {
            }
            else{
                UIWindow * window = [[UIApplication sharedApplication] keyWindow];
                [WMHUDUntil showFailWithMessage:_result.message toView:window];
            }
        }
        
        if (self.delegate) {
            [self.delegate managerCallAPIDidFailed:_result];
        }
        if (failure) {
            failure(_result);
        }
    };
    
    //加载动画
    [self dealLoadingEffect:YES];
    

    NSURLSessionDataTask *dataTask = [self.manager POST:urlStr parameters:param constructingBodyWithBlock:block progress:^(NSProgress * _Nonnull uploadProgress) {
        //上传进度
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        _result.code = [responseObject[@"resultCode"] integerValue];
        _result.message = responseObject[@"message"];
        _result.userInfo = responseObject[@"data"];
        
        //取消加载动画
        [self dealLoadingEffect:NO];
        
        //请求成功，服务端逻辑错误
        if (_result.code != 200) {
            
            errorBlock();
            
            return;
        }
        
        //请求数据成功，服务端逻辑正确
        //缓存
        if ([self.child respondsToSelector:@selector(cachePolicyType)] && self.child.cachePolicyType != CachePolicyType_None) {
            WMCacheModel *cacheModel = [WMCacheModel new];
            cacheModel.cacheTime = [NSDate date];
            cacheModel.jsonObject = responseObject;
            [[PINCache sharedCache] setObject:cacheModel forKey:urlStr];
        }
        
        id result = responseObject[@"data"];
        
        //使用JsonModel完成Json转model
        if ([self.child respondsToSelector:@selector(classType)] && self.child.classType) {
            NSError * error = nil;
            result = [self jsonToModelWith:result with:&error];
            if (error) {
                _result = [ResponseResult resultWithError:error];
                
                errorBlock();
                return ;
            }
        }
        
        //服务返回正确的数据
        if (self.delegate) {
            [wSelf.delegate managerCallAPIDidSuccess:result withDataTask:task];
        }
        if (success) {
            success(task, result);
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //取消加载动画
        [self dealLoadingEffect:NO];
        
        NSError * myError = nil;
        
        if ([error.domain isEqualToString:AFURLResponseSerializationErrorDomain]) {
            //AF处理过的返回错误
            NSData * errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
            
            NSError * errorDataError = nil;
            id  errorCallBackJson = [NSJSONSerialization JSONObjectWithData:errorData options:NSJSONReadingMutableContainers error:&errorDataError];
            if (errorDataError||![errorCallBackJson isKindOfClass:[NSDictionary class]]) {
                myError = [[NSError alloc] initWithDomain:WMURLResponseErrorDomain code:WMErrorCode_JSONModel userInfo:@{NSLocalizedDescriptionKey:WMJSONModelErrorLocalizedDescription}];
                
            }else{//错误日志正常解析
                NSDictionary * callBackDic = (NSDictionary*)errorCallBackJson;
                if (callBackDic[@"message"]) {
                    
                    myError = [[NSError alloc] initWithDomain:WMURLResponseErrorDomain code:[callBackDic[@"resultCode"] integerValue] userInfo:@{NSLocalizedDescriptionKey:callBackDic[@"message"],@"data":callBackDic[@"data"]}];
                }
            }
            
        }else{
            myError = error;
        }
        _result = [ResponseResult resultWithError:myError];
        
        errorBlock();

    }];
    
    [dataTask resume];
    
    return 0;
}
*/

//目前没什么卵用，待后续处理...
- (void)cancelAllRequests
{
    NSArray *tasks = _manager.tasks;
    //    NSLog(@"WMapi tasks count = %lu",(unsigned long)tasks.count);
    
    for (NSURLSessionDataTask *task in tasks) {
        if (task.state==NSURLSessionTaskStateRunning) {
            //                NSLog(@"task cancel:%@",task.description);
            [task cancel];
            
        }
    }
}

-(void)dealloc
{
    [self cancelAllRequests];
}

#pragma - private method
- (void)dealLoadingEffect:(BOOL)type
{
    if (type) {
        //添加加载动画
        if ([self.child respondsToSelector:@selector(loadingEffertType)]) {
            [self.loadEffectManager addLoadingEffectWith:self.child.loadingEffertType];
        }
        else
        {
            [self.loadEffectManager addLoadingEffectWith:LoadingEffertTypeDefault];
        }
    }
    else
    {
        //取消加载动画
        if ([self.child respondsToSelector:@selector(loadingEffertType)]) {
            [self.loadEffectManager removeLoadingEffectWith:self.child.loadingEffertType];
        }
        else
        {
            [self.loadEffectManager removeLoadingEffectWith:LoadingEffertTypeDefault];
        }
    }
}


- (BOOL)canLoadCache:(NSString *)key {
    BOOL result = NO;
    NSObject *cache = [[PINCache sharedCache] objectForKey:key];
    if (cache == nil) {
        return NO;
    }
    
    WMCacheModel *cacheModel = (WMCacheModel *)cache;
    NSDate * currentDate = [NSDate date];
    NSTimeInterval currentStamp = [currentDate timeIntervalSince1970];
    
    NSDate * lastDate = cacheModel.cacheTime;
    NSTimeInterval lastStamp = [lastDate timeIntervalSince1970];
    
    NSTimeInterval distanceStamp = currentStamp-lastStamp;
    
    
    if (self.child.cachePolicyType == CachePolicyType_AtOnce || ((distanceStamp>0)&&(distanceStamp<self.child.cachePolicyType))) {
        result = YES;
    }else{
        result = NO;
    }
    
    return result;
}


- (id)jsonToModelWith:(id)responseObject with:(NSError **)error {
    id result;
    //responseObject是NSDictionary类型，但是不影响后续操作
    if ([responseObject isKindOfClass:[NSDictionary class]]) {
        
        result = [[self.child.classType alloc] initWithDictionary:responseObject error:error];
        
    }else if ([responseObject isKindOfClass:[NSArray class]]){
        result = [self.child.classType arrayOfModelsFromDictionaries:responseObject error:error];
        
    }else{
        *error = [NSError errorWithDomain:JSONModelErrorDomain code:WMErrorCode_JSONModel userInfo:@{NSLocalizedDescriptionKey: WMJSONModelErrorLocalizedDescription}];
    }
    return result;
}

@end
