//
//  WMInfoTransitionViewController.h
//  WMDoctor
//
//  Created by JacksonMichael on 2017/5/24.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMBaseViewController.h"
#import "WMDoctorInformationModel.h"

@interface WMInfoTransitionViewController : WMBaseViewController


@property (nonatomic,copy) NSString * typeStr;

@property (nonatomic,strong) WMDoctorInformationModel * save_model;

@end
