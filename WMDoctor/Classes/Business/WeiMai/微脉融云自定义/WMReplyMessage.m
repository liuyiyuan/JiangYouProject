//
//  WMReplyMessage.m
//  WMDoctor
//
//  Created by xugq on 2018/3/26.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "WMReplyMessage.h"

@implementation WMReplyMessage
///初始化
+ (instancetype)messageWithTargetName:(NSString *)targetName
                    withTargetContent:(NSString *)targetContent
                     withReplyMessage:(NSString *)replyMessage;{
    WMReplyMessage *message = [[WMReplyMessage alloc] init];
    if (message) {
        message.targetName = targetName;
        message.targetContent = targetContent;
        message.replyMessage = replyMessage;
    }
    return message;
}

///消息是否存储，是否计入未读数
+ (RCMessagePersistent)persistentFlag {
    return (MessagePersistent_ISPERSISTED | MessagePersistent_ISCOUNTED);
}

/// NSCoding
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.targetName = [aDecoder decodeObjectForKey:@"targetName"];
        self.targetContent = [aDecoder decodeObjectForKey:@"targetContent"];
        self.replyMessage = [aDecoder decodeObjectForKey:@"replyMessage"];
        
    }
    return self;
}

/// NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.targetName forKey:@"targetName"];
    [aCoder encodeObject:self.targetContent forKey:@"targetContent"];
    [aCoder encodeObject:self.replyMessage forKey:@"replyMessage"];
}

///将消息内容编码成json
- (NSData *)encode {
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    [dataDict setObject:self.targetName forKey:@"targetName"];
    [dataDict setObject:self.targetContent forKey:@"targetContent"];
    [dataDict setObject:self.replyMessage forKey:@"replyMessage"];
    
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
            self.targetName = dictionary[@"targetName"];
            self.targetContent = dictionary[@"targetContent"];
            self.replyMessage = dictionary[@"replyMessage"];
            NSDictionary *userinfoDic = dictionary[@"user"];
            [self decodeUserInfo:userinfoDic];
        }
    }
}

/// 会话列表中显示的摘要
- (NSString *)conversationDigest {
    return self.replyMessage;
}

///消息的类型名
+ (NSString *)getObjectName {
    return WMRCReplyMessageTypeIdentifier;
}


@end
