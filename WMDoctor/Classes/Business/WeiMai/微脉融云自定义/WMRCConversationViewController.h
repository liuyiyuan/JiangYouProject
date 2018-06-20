//
//  WMRCConversationViewController.h
//  WMDoctor
//
//  Created by 茭白 on 2017/1/6.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>
#import "WMPatientStateModel.h"
#import "WMRCBaseChatViewController.h"

@interface WMRCConversationViewController :WMRCBaseChatViewController
@property (nonatomic ,strong)WMPatientStateModel *patientStateMode;
@property (nonatomic ,strong)NSString *titleName;
@property (nonatomic, strong)NSString *targetId;

@end
