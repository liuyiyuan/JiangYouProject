//
//  WMProvinceSelectViewController.h
//  WMDoctor
//
//  Created by JacksonMichael on 2017/4/11.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMBaseViewController.h"
#import "WMEducationCustomModel.h"
#import "WMDoctorInformationCustomModel.h"

@interface WMProvinceSelectViewController : WMBaseViewController

@property (nonatomic,strong) WMEducationCustomModel * customModel;
@property (nonatomic,assign) BOOL isArea;
@property (nonatomic,strong) WMDoctorInformationCustomModel * saveModel;

@end
