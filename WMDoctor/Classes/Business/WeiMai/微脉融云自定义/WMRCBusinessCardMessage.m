//
//  WMRCBusinessCardMessage.m
//  WMDoctor
//
//  Created by 茭白 on 2017/3/23.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMRCBusinessCardMessage.h"

@implementation WMRCBusinessCardMessage
///初始化
+ (instancetype)messageWithTitle:(NSString *)title withDoctorName:(NSString *)name withHospital:(NSString *)hospital withHeadUrl:(NSString *)headUrl withDepartment:(NSString *)department withCardStr:(NSString *)cardLabel {
    WMRCBusinessCardMessage *businessCardMessage = [[WMRCBusinessCardMessage alloc] init];
    if (businessCardMessage) {
        businessCardMessage.title=title;
        businessCardMessage.hospital=hospital;
        businessCardMessage.name=name;
        businessCardMessage.headUrl=headUrl;
        businessCardMessage.department =department;
        businessCardMessage.cardLabel=cardLabel;
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
        self.hospital = [aDecoder decodeObjectForKey:@"hospital"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.department = [aDecoder decodeObjectForKey:@"department"];
        self.headUrl = [aDecoder decodeObjectForKey:@"headUrl"];
        self.cardLabel = [aDecoder decodeObjectForKey:@"cardLabel"];
        self.extra = [aDecoder decodeObjectForKey:@"extra"];
        
    }
    return self;
}

/// NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.hospital forKey:@"hospital"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.department forKey:@"department"];
    [aCoder encodeObject:self.headUrl forKey:@"headUrl"];
    [aCoder encodeObject:self.cardLabel forKey:@"cardLabel"];
    [aCoder encodeObject:self.extra forKey:@"extra"];
}

///将消息内容编码成json
- (NSData *)encode {
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    [dataDict setObject:self.title forKey:@"title"];
    [dataDict setObject:self.hospital forKey:@"hospital"];
    [dataDict setObject:self.department forKey:@"department"];
    [dataDict setObject:self.name forKey:@"name"];
    [dataDict setObject:self.headUrl forKey:@"headUrl"];
    [dataDict setObject:self.cardLabel forKey:@"cardLabel"];
    
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
            self.hospital = dictionary[@"hospital"];
            self.name = dictionary[@"name"];
            self.headUrl = dictionary[@"headUrl"];
            self.department = dictionary[@"department"];
            self.cardLabel = dictionary[@"cardLabel"];
            self.extra = dictionary[@"extra"];
            NSDictionary *userinfoDic = dictionary[@"user"];
            [self decodeUserInfo:userinfoDic];
        }
    }
}

/// 会话列表中显示的摘要
- (NSString *)conversationDigest {
    return [NSString stringWithFormat:@"%@的名片",self.name];
}

///消息的类型名
+ (NSString *)getObjectName {
    return WMRCBusinessCardMessageTypeIdentifier;
}
@end
