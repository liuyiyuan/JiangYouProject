//
//  WMPatientRemarkViewController.h
//  WMDoctor
//
//  Created by JacksonMichael on 2018/5/28.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "WMBaseViewController.h"
#import "WMPatientReportedModel.h"
@interface WMPatientRemarkViewController : WMBaseViewController

@property (nonatomic,copy) NSString * weimaihao;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic,strong) WMPatientDataModel * patientData;
@property (nonatomic, strong) NSString *remark;

@end
