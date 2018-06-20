//
//  WMPatientDataViewController.h
//  WMDoctor
//
//  Created by xugq on 2017/8/10.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMBaseViewController.h"
#import "WMTotalPatientsDataModel.h"
#import "WMPatientReportedModel.h"
#import "WMVPIPatientsModel.h"

@interface WMPatientDataViewController : WMBaseViewController

@property(nonatomic, strong)NSString *userId;
@property(nonatomic, strong)NSString *groupId;
@property(nonatomic, strong)WMTotalPatientsModel *totalPatientModel;
@property(nonatomic, strong)WMPatientReportedModel *patientReportedModel;
@property(nonatomic, strong)WMVPIPatientsDetailModel *vipPatientModel;
@property(nonatomic, strong)WMPatientModel *tagPatientModel;


@end
