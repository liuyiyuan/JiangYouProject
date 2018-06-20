//
//  WMMyServiceTableViewController.h
//  WMDoctor
//
//  Created by JacksonMichael on 2016/12/23.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMBaseTableViewController.h"
#import "WMDoctorServiceModel.h"

@interface WMMyServiceTableViewController : WMBaseTableViewController

@property (nonatomic,strong) WMDoctorMyServiceModel * serviceModel;

@end
