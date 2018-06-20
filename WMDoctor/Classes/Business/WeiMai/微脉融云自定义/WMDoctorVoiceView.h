//
//  WMDoctorVoiceView.h
//  WMDoctor
//
//  Created by xugq on 2017/10/11.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WMDoctorVoiceView : UIView

@property(nonatomic, strong)NSString *targetId;
@property(nonatomic, strong)UINavigationController *navigationController;
- (void)setupDoctorVoiceView;

@end
