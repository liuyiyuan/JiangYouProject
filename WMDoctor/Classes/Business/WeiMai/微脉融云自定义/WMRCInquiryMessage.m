//
//  WMRCInquiryMessage.m
//  Micropulse
//
//  Created by 茭白 on 2016/11/30.
//  Copyright © 2016年 iChoice. All rights reserved.
//

#import "WMRCInquiryMessage.h"

@implementation WMRCInquiryMessage
///初始化
+(instancetype)messageWithInquiryTextMsg:(NSString *)inquiryTextMsg withInquiryPicture:(NSMutableArray *)inquiryPictureArr
{
    WMRCInquiryMessage *inquiryMessage=[[WMRCInquiryMessage alloc]init];
    if (inquiryMessage) {
        inquiryMessage.inquiryTextMsg=inquiryTextMsg;
        inquiryMessage.inquiryPictureArr=inquiryPictureArr;
        
    }
    return inquiryMessage;
}

///消息是否存储，是否计入未读数
+ (RCMessagePersistent)persistentFlag {
    return (MessagePersistent_ISPERSISTED | MessagePersistent_ISCOUNTED);
}

/// NSCoding
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.inquiryTextMsg = [aDecoder decodeObjectForKey:@"inquiryTextMsg"];
        self.extra = [aDecoder decodeObjectForKey:@"extra"];
        self.inquiryPictureArr = [aDecoder decodeObjectForKey:@"inquiryPictureArr"];
        
    }
    return self;
}

/// NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.inquiryPictureArr forKey:@"inquiryPictureArr"];
    [aCoder encodeObject:self.extra forKey:@"extra"];
    [aCoder encodeObject:self.inquiryTextMsg forKey:@"inquiryTextMsg"];
}

///将消息内容编码成json
- (NSData *)encode {
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    [dataDict setObject:self.inquiryTextMsg forKey:@"inquiryTextMsg"];
    [dataDict setObject:self.inquiryPictureArr forKey:@"inquiryPictureArr"];
    
    
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
            self.inquiryPictureArr = dictionary[@"inquiryPictureArr"];
            self.extra = dictionary[@"extra"];
            self.inquiryTextMsg = dictionary[@"inquiryTextMsg"];
            
            NSDictionary *userinfoDic = dictionary[@"user"];
            [self decodeUserInfo:userinfoDic];
        }
    }
}

/// 会话列表中显示的摘要
- (NSString *)conversationDigest {
    return self.inquiryTextMsg;
}

///消息的类型名
+ (NSString *)getObjectName {
    return WMRCInquiryMessageTypeIdentifier;
}


@end
