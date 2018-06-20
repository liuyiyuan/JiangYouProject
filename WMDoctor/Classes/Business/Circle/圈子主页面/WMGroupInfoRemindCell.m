//
//  WMGroupInfoRemindCell.m
//  WMDoctor
//
//  Created by JacksonMichael on 2018/4/2.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "WMGroupInfoRemindCell.h"

@implementation WMGroupInfoRemindCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setValueforCell:(BOOL)flag{
    self.theSwitch.on = flag;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (IBAction)switchValue:(id)sender {
        //接收消息
        [[RCIMClient sharedRCIMClient] setConversationNotificationStatus:ConversationType_GROUP
                                                                targetId:self.tagertId
                                                               isBlocked:((self.theSwitch.on)?NO:YES)
                                                                 success:^(RCConversationNotificationStatus nStatus) {
                                                                     NSLog(@"设置成功，%lu",(unsigned long)nStatus);
                                                                 } error:^(RCErrorCode status) {
                                                                     NSLog(@"屏蔽群聊天失败");
                                                                 }];
    
}

@end
