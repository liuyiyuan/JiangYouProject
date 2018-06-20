//
//  WMRequestSerializerGenerate.h
//  Micropulse
//
//  Created by zhangchaojie on 16/4/1.
//  Copyright © 2016年 ENJOYOR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMNetworkConfig.h"
#import <AFNetworking.h>

@class RequestHeader;


/**
 * 请求解析器
 */
@interface WMRequestSerializerGenerate : NSObject
@property (nonatomic, strong)RequestHeader *otherHeader;

- (AFJSONRequestSerializer *)generateHeaderWithType:(HTTPMethodType)type
                                            withURL:(NSString*)url
                                          withParam:(NSDictionary *)param;

@end

@interface RequestHeader : JSONModel

@property (nonatomic,copy) NSString *grbh;
@property (nonatomic,copy) NSString *logid;

@end
