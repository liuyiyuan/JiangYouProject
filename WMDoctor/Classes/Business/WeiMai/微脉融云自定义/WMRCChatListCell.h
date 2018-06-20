//
//  WMRCChatListCell.h
//  Micropulse
//
//  Created by 茭白 on 16/9/11.
//  Copyright © 2016年 iChoice. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>
#define kCellHeight 80
@interface WMRCChatListCell : RCConversationBaseCell
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

//vip标签
@property (nonatomic, retain) UIImageView *vipTag;

//标签底层视图
@property (nonatomic, retain) UIView *tagView;

//根据用户的标签信息给用户打标签
- (void)setTagViewWithUserInfo:(RCUserInfo *)user;

@end
