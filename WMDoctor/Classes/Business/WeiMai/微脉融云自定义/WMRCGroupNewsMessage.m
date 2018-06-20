//
//  WMRCGroupNewsMessage.m
//  Micropulse
//
//  Created by 茭白 on 2017/7/27.
//  Copyright © 2017年 iChoice. All rights reserved.
//

#import "WMRCGroupNewsMessage.h"

@implementation WMRCGroupNewsMessage
///初始化
+ (instancetype)messageWithTitle:(NSString *)title withShowUrl:(NSString *)showUrl withDetailLabel:(NSString *)detailLabel withSenateModelString:(NSString *)senateModelString withTemplateString:(NSString *)templateString{
    WMRCGroupNewsMessage *businessCardMessage = [[WMRCGroupNewsMessage alloc] init];
    if (businessCardMessage) {
        businessCardMessage.title=title;
        businessCardMessage.showUrl=showUrl;
        businessCardMessage.detailLabel=detailLabel;
        businessCardMessage.senateModelString=senateModelString;
        businessCardMessage.templateString =templateString;
        
    }
    return businessCardMessage;
}

///消息是否存储，是否计入未读数
+ (RCMessagePersistent)persistentFlag {
    return (MessagePersistent_ISPERSISTED | MessagePersistent_ISCOUNTED);
}

/// NSCoding
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.showUrl = [aDecoder decodeObjectForKey:@"showUrl"];
        self.detailLabel = [aDecoder decodeObjectForKey:@"detailLabel"];
        self.senateModelString = [aDecoder decodeObjectForKey:@"senateModelString"];
        self.templateString = [aDecoder decodeObjectForKey:@"templateString"];
        self.extra = [aDecoder decodeObjectForKey:@"extra"];
        
    }
    return self;
}

/// NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.showUrl forKey:@"showUrl"];
    [aCoder encodeObject:self.detailLabel forKey:@"detailLabel"];
    [aCoder encodeObject:self.senateModelString forKey:@"senateModelString"];
    [aCoder encodeObject:self.templateString forKey:@"templateString"];
    [aCoder encodeObject:self.extra forKey:@"extra"];
}

///将消息内容编码成json
- (NSData *)encode {
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    [dataDict setObject:self.title forKey:@"title"];
    [dataDict setObject:self.showUrl forKey:@"showUrl"];
    [dataDict setObject:self.detailLabel forKey:@"detailLabel"];
    [dataDict setObject:self.senateModelString forKey:@"senateModelString"];
    [dataDict setObject:self.templateString forKey:@"templateString"];
    
    if (self.extra) {
        [dataDict setObject:self.extra forKey:@"extra"];
    }
    
    if (self.senderUserInfo) {
        NSMutableDictionary *userInfoDic = [[NSMutableDictionary alloc] init];
        if (self.senderUserInfo.name) {
            [userInfoDic setObject:self.senderUserInfo.name
                 forKeyedSubscript:@"name"];
        }
        if (self.senderUserInfo.portraitUri) {
            [userInfoDic setObject:self.senderUserInfo.portraitUri
                 forKeyedSubscript:@"icon"];
        }
        if (self.senderUserInfo.userId) {
            [userInfoDic setObject:self.senderUserInfo.userId
                 forKeyedSubscript:@"id"];
        }
        [dataDict setObject:userInfoDic forKey:@"user"];
    }
    NSData *data = [NSJSONSerialization dataWithJSONObject:dataDict
                                                   options:kNilOptions
                                                     error:nil];
    return data;
}

///将json解码生成消息内容
- (void)decodeWithData:(NSData *)data {
    if (data) {
        __autoreleasing NSError *error = nil;
        
        NSDictionary *dictionary =
        [NSJSONSerialization JSONObjectWithData:data
                                        options:kNilOptions
                                          error:&error];
        
        if (dictionary) {
            self.title = dictionary[@"title"];
            self.showUrl = dictionary[@"showUrl"];
            self.detailLabel = dictionary[@"detailLabel"];
            self.templateString = dictionary[@"templateString"];
            self.senateModelString = dictionary[@"senateModelString"];
            self.extra = dictionary[@"extra"];
            NSDictionary *userinfoDic = dictionary[@"user"];
            [self decodeUserInfo:userinfoDic];
        }
    }
}

/// 会话列表中显示的摘要
- (NSString *)conversationDigest {
    return [NSString stringWithFormat:@"%@的名片",self.title];
}

///消息的类型名
+ (NSString *)getObjectName {
    return WMRCGroupNewsMessageTypeIdentifier;
}

@end
