//
//  WMSectionChooseViewController.h
//  WMDoctor
//
//  Created by 茭白 on 2017/5/18.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMBaseViewController.h"
#import "WMDoctorInformationModel.h"

@interface WMSectionChooseViewController : WMBaseViewController
@property (nonatomic ,copy)NSString *organizationCode;//只有当是科室才用

@property(nonatomic)NSString *hosName;

@property (nonatomic,strong) WMDoctorInformationModel * save_model;

@property (nonatomic,assign) BOOL isInfo;
@end
