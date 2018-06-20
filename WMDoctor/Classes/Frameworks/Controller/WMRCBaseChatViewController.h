//
//  WMRCBaseChatViewController.h
//  WMDoctor
//
//  Created by 茭白 on 2017/3/27.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

@interface WMRCBaseChatViewController : RCConversationViewController

@property (nonatomic ,copy)NSString *backName;

/**
 根据输入框位置重新设置页面frame
 
 @param chatInputBar 输入框控制器
 @param frame 位置改变frame
 融云API并没有暴露该方法 只有在该类中重写此方法并在子类中重写才可以顺利地给页面重新布局 为了实现医患链1.6群聊回复功能而设置 2018、4、12添加
 */
- (void)chatInputBar:(RCChatSessionInputBarControl *)chatInputBar shouldChangeFrame:(CGRect)frame;

@end
