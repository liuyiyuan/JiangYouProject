//
//  WMHospitalChooseViewController.h
//  WMDoctor
//
//  Created by 茭白 on 2017/5/15.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMBaseViewController.h"
#import "WMDoctorInformationModel.h"

@interface WMHospitalChooseViewController : WMBaseViewController

@property (nonatomic,strong) WMDoctorInformationModel * save_model;

@property (nonatomic,assign) BOOL isInfo;

@end
