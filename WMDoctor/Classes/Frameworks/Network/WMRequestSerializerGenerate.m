//
//  WMRequestSerializerGenerate.m
//  Micropulse
//
//  Created by zhangchaojie on 16/4/1.
//  Copyright © 2016年 ENJOYOR. All rights reserved.
//

#import "WMRequestSerializerGenerate.h"
#import "Encrypt.h"
#import "DateTimeUtil.h"
#import "WMJSONUtil.h"
#import "AppConfig.h"

static NSString * const  defaultUserId = @"0";
static NSString * const defaultSessionId = @"0";


@implementation RequestHeader

@end

@implementation WMRequestSerializerGenerate

-(instancetype)init
{
    self = [super init];
    if (self) {
        _otherHeader = [RequestHeader new];
    }
    return self;
}
- (AFJSONRequestSerializer *)generateHeaderWithType:(HTTPMethodType)type withURL:(NSString*)url withParam:(NSDictionary *)param
{
    NSParameterAssert(url);
    
    
    NSString * newURL = url;
    NSDictionary * newParam = param;
    
    if (type==Method_GET||type==Method_DELETE) {

        newURL = [self getFullURLWithURLString:url paramters:param];
        newParam = nil;
    }
    EnvironmentModel * envirModel = [[AppConfig httpURLs] objectAtIndex:[AppConfig currentEnvir]];
    
    NSLog(@"HTTP URL=%@%@",envirModel.content,newURL);

    //date时间戳，精确到毫秒
    NSTimeInterval timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *timestampString = [NSString stringWithFormat:@"%.0f", timestamp*1000];
    
    NSString * body = nil;
    if (newParam) {
        //body内容
        body = [WMJSONUtil stringWithJSONObject:newParam];
        //按要求去除\s\t\r\n
        body = [self getZZwithString:body];
    }

    NSString * Authorization = [self createAuthorizationWithDateString:timestampString url:newURL param:body header:self.otherHeader];
    
    //如果有json嵌套的话，AFHTTPRequestSerializer会默认为AFPropertyListRequestSerializer，此处应使用JSONRequest
    AFJSONRequestSerializer * serializer = [AFJSONRequestSerializer serializer];
    
    [serializer setValue:Authorization forHTTPHeaderField:@"Authorization"];
    [serializer setValue:timestampString forHTTPHeaderField:@"X-WeiMai-Date"];
    [serializer setValue:[self getWeiMaiVersion] forHTTPHeaderField:@"X-WeiMai-Version"];
    /**
     *  后期如果RequestHeader有值，可以在这做处理，三目运算符走起……
     */
    [serializer setValue:[self getWeiMaiUerId] forHTTPHeaderField:@"X-WeiMai-UserId"];
    [serializer setValue:[self getWeiMaiSessionId] forHTTPHeaderField:@"X-WeiMai-SessionId"];
    [serializer setValue:[[NSUUID alloc] init].UUIDString forHTTPHeaderField:@"x-weimai-eventid"];

    //NSLog(@"requestHeaderFields =\n%@",serializer.HTTPRequestHeaders);
    
    return serializer;
}
//正则去除网络标签
-(NSString *)getZZwithString:(NSString *)string{
    NSRegularExpression *regularExpretion=[NSRegularExpression regularExpressionWithPattern:@"\\s*|\t|\r|\n"
                                                                                    options:0
                                                                                      error:nil];
    string=[regularExpretion stringByReplacingMatchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, string.length) withTemplate:@""];
    return string;
}
/**
 *  根据URL和参数拼接成后台需要的全部URL路径:目前用于get请求和delete请求
 *
 *  @param urlString 相对URL路径
 *  @param parameters 参数字典
 */
- (NSString *)getFullURLWithURLString:(NSString *)urlString
                                paramters:(NSDictionary*)parameters
{
    NSMutableString * newURL = [NSMutableString stringWithString:urlString];
    
    if (parameters) {
        
        NSAssert([parameters isKindOfClass:[NSDictionary class]], @"parameters must be dictionary type");
        
        NSDictionary * parametersDic = (NSDictionary*)parameters;
        
        NSMutableString * tempString = [NSMutableString stringWithString:@""];
        
        NSString * key;
        //判断url是否拼接过内容
        key = [newURL containsString:@"?"]?@"&":@"?";
        [tempString appendString:key];
        
        //探囊取物
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"description"
                                                                         ascending:YES
                                                                          selector:@selector(compare:)];
        
        for (NSString * key in [parametersDic.allKeys sortedArrayUsingDescriptors:@[sortDescriptor]]) {
            
            [tempString appendFormat:@"%@=%@",AFPercentEscapedStringFromString([key description]),AFPercentEscapedStringFromString([parametersDic[key] description])];
            [tempString appendString:@"&"];
        }
        //temstr是?a=1&b=2&c=3
        NSString * tempstr = [tempString substringWithRange:NSMakeRange(0, tempString.length-1)];
        
        [newURL appendString:tempstr];
        
    }
    return newURL;
}
- (NSString *)createAuthorizationWithDateString:(NSString *)date
                                            url:(NSString *)url
                                          param:(NSString*)paramString
                                         header:(RequestHeader*)header
{
    
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionaryWithDictionary:@{}];

    [dictionary setObject:date forKey:@"X-WeiMai-Date"];
    [dictionary setObject:[self getWeiMaiUerId] forKey:@"X-WeiMai-UserId"];
    [dictionary setObject:[self getWeiMaiSessionId] forKey:@"X-WeiMai-SessionId"];
    [dictionary setObject:url forKey:@"X-WeiMai-Url"];
    [dictionary setObject:[self getWeiMaiVersion] forKey:@"X-WeiMai-Version"];
    if (paramString) {
        [dictionary setObject:paramString forKey:@"X-WeiMai-Body"];
    }
    
    NSMutableString * CanonicalizedZSVHHeaders = [NSMutableString stringWithString:@""];
    NSString * SignatureValue;
    
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"description"
                                                                     ascending:YES
                                                                      selector:@selector(compare:)];
    
    for (NSString * key in [dictionary.allKeys sortedArrayUsingDescriptors:@[sortDescriptor]]) {
        
        //这里不需要escape
        [CanonicalizedZSVHHeaders appendFormat:@"%@=%@",key,dictionary[key]];
        [CanonicalizedZSVHHeaders appendString:@"&"];
    }
    
    NSString * SignatureContent = [CanonicalizedZSVHHeaders substringWithRange:NSMakeRange(0, CanonicalizedZSVHHeaders.length-1)];
    
    SignatureValue = [Encrypt hmacsha1:SignatureContent secret:gkey];
    
//    NSLog(@"SignatureValue =\n%@",SignatureContent);
    
    /**
     *  认证，需要 Access Key Id 和 Signature
     */
    NSString * Authorization = [NSString stringWithFormat:@"WEIMAI:%@:%@",gIv,SignatureValue];
    
    return Authorization;
}

- (NSString *)getWeiMaiUerId
{
    LoginModel *model = [WMLoginCache getMemoryLoginModel];

    if ([model.loginFlag isEqual:@"1"]) {
        return [NSString stringWithFormat:@"%@",model.userId];
    }
    return defaultUserId;
}
- (NSString *)getWeiMaiSessionId
{
    LoginModel *model=[WMLoginCache getMemoryLoginModel];
    
    if ([model.loginFlag isEqual:@"1"]) {
        //这种方式保证返回的值肯定不是nil
        return [NSString stringWithFormat:@"%@",model.sessionId];
    }
    return defaultSessionId;
}

- (NSString*)getWeiMaiVersion
{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    return [NSString stringWithFormat:@"iOS/%@",appVersion];
}

@end
