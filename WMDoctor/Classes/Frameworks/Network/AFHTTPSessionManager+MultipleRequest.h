//
//  AFHTTPSessionManager+MultipleRequest.h
//  Micropulse
//
//  Created by zhangchaojie on 16/4/5.
//  Copyright © 2016年 ENJOYOR. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface AFHTTPSessionManager (MultipleRequest)

- (NSURLSessionDataTask *)dataTaskWithHTTPMethod:(NSString *)method
                                       URLString:(NSString *)URLString
                                      parameters:(id)parameters
                                  uploadProgress:(void (^)(NSProgress *uploadProgress)) uploadProgress
                                downloadProgress:(void (^)(NSProgress *downloadProgress)) downloadProgress
                                         success:(void (^)(NSURLSessionDataTask *, id))success
                                         failure:(void (^)(NSURLSessionDataTask *, NSError *))failure;
@end
