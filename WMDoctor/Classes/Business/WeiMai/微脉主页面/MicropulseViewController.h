//
//  MicropulseViewController.h
//  WMDoctor
//
//  Created by 茭白 on 2016/12/16.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RongIMKit/RongIMKit.h>
#import "WMAskADoctorAwokeView.h"
@interface MicropulseViewController : RCConversationListViewController<UITextViewDelegate>

@property(nonatomic, strong)WMAskADoctorAwokeView *awokeView;

@end
