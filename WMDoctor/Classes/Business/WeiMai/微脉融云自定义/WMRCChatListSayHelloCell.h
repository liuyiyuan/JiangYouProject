//
//  WMRCChatListSayHelloCell.h
//  WMDoctor
//
//  Created by 茭白 on 2017/3/21.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>
/***
 * 用于展示打招呼的cell
 **/
@interface WMRCChatListSayHelloCell : RCConversationBaseCell
#define kCellHeight 80
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

///打招呼时候的图片
@property (nonatomic,retain) UIImageView *sayHelloImageView;
///评论按钮
//@property (nonatomic, strong) WMBlueButton *commentButton;



@end
