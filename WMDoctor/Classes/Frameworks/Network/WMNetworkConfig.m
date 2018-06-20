//
//  WMNetworkConfig.m
//  Micropulse
//
//  Created by zhangchaojie on 16/4/19.
//  Copyright © 2016年 ENJOYOR. All rights reserved.
//

#import "WMNetworkConfig.h"

NSString *const WMURLResponseErrorDomain = @"com.wemay.error.response";

NSString *const WMJSONModelErrorLocalizedDescription = @"解析数据出错";


@implementation WMNetworkConfig

@end


@implementation ResponseResult

+ (ResponseResult*)resultWithError:(NSError*)error
{
    ResponseResult * result = [[ResponseResult alloc] init];
    result.code = error.code;
    result.message = error.localizedDescription;
    result.userInfo = error.userInfo;
    
    NSInteger code = error.code;
    NSString * message = error.localizedDescription;
    
    if (error.domain==NSURLErrorDomain) {
        
        switch (error.code) {
            case NSURLErrorNetworkConnectionLost://-1005
            case NSURLErrorNotConnectedToInternet://-1009
            {
                code = WMErrorCode_NetWorkBad;
                message = @"似乎断开与互联网的链接";
            }
                break;
                
            case NSURLErrorCannotConnectToHost://-1004
            case NSURLErrorCannotFindHost://-1003
            {
                code= WMErrorCode_ServicerNotConnect;
                message = @"无法连接到服务器";
            }
                break;
                
            default:
                break;
        }

    }
    
    return result;
}
- (NSString*)description
{
    return [NSString stringWithFormat:@"resultCode=%ld|resultMessage=%@",(long)_code,_message];
}
@end
