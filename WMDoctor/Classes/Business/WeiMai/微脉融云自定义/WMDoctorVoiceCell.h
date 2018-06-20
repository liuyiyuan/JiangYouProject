//
//  WMDoctorVoiceCell.h
//  WMDoctor
//
//  Created by xugq on 2017/9/29.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMDoctorVoiceModel.h"
@interface WMDoctorVoiceCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *publishedTime;
@property (weak, nonatomic) IBOutlet UILabel *desc;
@property (weak, nonatomic) IBOutlet UILabel *voiceInLength;
@property (weak, nonatomic) IBOutlet UILabel *audience;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descHeightLayout;

- (void)setupValueWithModel:(WMDoctorVoiceModel *)doctorVoice;

@end
