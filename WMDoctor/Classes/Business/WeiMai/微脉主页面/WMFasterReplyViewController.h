//
//  WMFasterReplyViewController.h
//  WMDoctor
//
//  Created by 茭白 on 2016/12/22.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import "WMBaseViewController.h"
#import "WMRCConversationViewController.h"
#import "RCIMGroupViewController.h"
@interface WMFasterReplyViewController : WMBaseViewController
@property(nonatomic,strong) WMRCConversationViewController *conversationVC;
@property(nonatomic,strong) RCIMGroupViewController *groupConversationVC;
@end
