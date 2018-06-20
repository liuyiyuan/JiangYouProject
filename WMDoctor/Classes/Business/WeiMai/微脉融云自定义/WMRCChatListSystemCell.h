//
//  WMRCChatListSystemCell.h
//  WMDoctor
//
//  Created by 茭白 on 2016/12/29.
//  Copyright © 2016年 Choice. All rights reserved.
//
/**
 * 由于微脉系统消息是聚合消息 所以是单独的样式 （不容易）
 */
#import <RongIMKit/RongIMKit.h>
#define kCellHeight 80

@interface WMRCChatListSystemCell : RCConversationBaseCell
///头像
@property (nonatomic,retain) UIImageView *avatarImage;

//职位(医院单位)
@property (nonatomic,retain)UILabel *doctorPositionLable;

///真实姓名
@property (nonatomic,retain) UILabel *nameLabel;

///时间
@property (nonatomic,retain) UILabel *timeLabel;

///内容（病情的描述）
@property (nonatomic,retain) UILabel *contentLabel;

///角标（UIView）
@property (nonatomic,retain) UILabel *ppBadgeView;

@property (nonatomic,retain) UIImageView *flogImageView;

///评论按钮
//@property (nonatomic, strong) WMBlueButton *commentButton;

@end
