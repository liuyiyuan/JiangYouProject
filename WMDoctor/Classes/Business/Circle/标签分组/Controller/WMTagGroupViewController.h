//
//  WMTagGroupViewController.h
//  WMDoctor
//
//  Created by JacksonMichael on 2018/5/14.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "WMBaseViewController.h"
#import "WMTagGroupCollectionViewCell.h"
#import "WMTagGroupSelectCollectionViewCell.h"
#import "WMPatientReportedModel.h"

@interface WMTagGroupViewController : WMBaseViewController
@property (nonatomic,copy) NSString * weimaihao;
@property (nonatomic,strong) WMPatientDataModel * patientData;
@property (nonatomic, strong) NSMutableArray *tagGroups;

@end
