//
//  WMTownSelectViewController.h
//  WMDoctor
//
//  Created by JacksonMichael on 2017/4/13.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMBaseViewController.h"
#import "WMDoctorInformationCustomModel.h"

@interface WMTownSelectViewController : WMBaseViewController

@property (nonatomic,copy) NSString * areaStrCode;
@property (nonatomic,copy) NSString * areaStr;
@property (nonatomic,strong) WMDoctorInformationCustomModel * saveModel;
@end
