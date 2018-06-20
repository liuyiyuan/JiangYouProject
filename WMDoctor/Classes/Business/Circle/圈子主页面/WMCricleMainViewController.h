//
//  WMCricleMainViewController.h
//  WMDoctor
//
//  Created by 茭白 on 2016/12/14.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import "WMBaseViewController.h"


typedef NS_ENUM(NSInteger,WMCricleType)
{
    PatientReportedCricleType               = 1,//患者报道
    DoctorCricleType                        = 2,//暂定医生圈子
    VIPPatientCricleType                    = 3,//VIP圈子
    VIPFriendCricleType                     = 4,//VIP圈子
    GroupType                               = 5,//群组
    TagGroupType                            = 6,//标签分组

    
};

@interface WMCricleMainViewController : WMBaseViewController

@end
