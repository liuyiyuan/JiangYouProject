//
//  WMSearchPatientCell.h
//  WMDoctor
//
//  Created by xugq on 2018/5/11.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMTotalPatientsDataModel.h"
#import "WMVPIPatientsModel.h"

@interface WMSearchPatientCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *sex;
@property (weak, nonatomic) IBOutlet UILabel *illness;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *orderTag;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeToTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tagToTop;

//搜索列表根据患者赋值
- (void)searchPaitentVCSetValueWithWMPatientModel:(WMPatientModel *)patient andSearchKeyWord:(NSString *)keyword;
//标签分组患者列表添加数据
- (void)tagPatientVCSetValueWithWMPatientModel:(WMPatientModel *)patient;
//患者报道列表加数据
- (void)patientReportedVCSetValueWithWMPatientReportedModel:(WMPatientReportedModel *)patient;
//所有患者列表添加数据
- (void)allPatientVCSetValueWithWMTotalPatientsModel:(WMTotalPatientsModel *)patient;
//VIP患者列表添加数据
- (void)vipPatientVCSetValueWithWMVPIPatientsDetailModel:(WMVPIPatientsDetailModel *)patient;
@end
