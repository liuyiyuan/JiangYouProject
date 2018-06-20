//
//  WMRCInquiryMessage.h
//  Micropulse
//
//  Created by 茭白 on 2016/11/30.
//  Copyright © 2016年 iChoice. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>
#define    WMRCInquiryMessageTypeIdentifier @"RCD:WMInquiryMsg"

@interface WMRCInquiryMessage : RCMessageContent<NSCoding>
/*!
 问诊的文字信息
 */
@property(nonatomic, strong) NSString *inquiryTextMsg;
/*!
 问诊的图片信息数组
 */
@property(nonatomic, strong) NSMutableArray *inquiryPictureArr;


 /*!
 预留附加信息
 */
@property(nonatomic, strong) NSString *extra;

/*!
 初始化测试消息
 
 @param inquiryTextMsg 文本内容
 @return        测试消息对象
 */

+ (instancetype)messageWithInquiryTextMsg:(NSString *)inquiryTextMsg withInquiryPicture:(NSMutableArray *)inquiryPictureArr;
@end
