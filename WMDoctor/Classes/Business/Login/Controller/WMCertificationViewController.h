//
//  WMCertificationViewController.h
//  WMDoctor
//
//  Created by 茭白 on 2017/5/16.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMBaseViewController.h"
#import "WMDoctorInformationModel.h"
#import "WMDoctorServiceModel.h"

@interface WMCertificationViewController : WMBaseViewController

/**
 * 第一次登录标志
 */
@property(nonatomic ,assign)BOOL isFirstLogin;


/**
 内存中跟踪的认证状态(by大渺)
 */
@property (nonatomic,strong) WMDoctorInformationModel * save_model; //个人信息
@property (nonatomic,strong) WMDoctorServiceModel * service_model;  //我的服务

@end
