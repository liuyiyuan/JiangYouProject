//
//  WMCitySelectViewController.h
//  WMDoctor
//
//  Created by JacksonMichael on 2017/4/12.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMBaseViewController.h"
#import "WMEducationCustomModel.h"
#import "WMCitySelectViewController.h"
#import "WMDoctorInformationCustomModel.h"

@interface WMCitySelectViewController : WMBaseViewController

@property (nonatomic,strong) WMEducationCustomModel * customModel;
@property (nonatomic,copy) NSString * areaStrCode;
@property (nonatomic,copy) NSString * areaStr;
@property (nonatomic,assign) BOOL isArea;
@property (nonatomic,strong) WMDoctorInformationCustomModel * saveModel;
@end
