//
//  WMDoctorInfoCell.h
//  WMDoctor
//
//  Created by JacksonMichael on 2016/12/29.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMPersonalInfoModel.h"
#import "WMStarView.h"

@interface WMDoctorInfoCell : UITableViewCell

/**
 医生头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *doctorHeadImageView;

/**
 医生姓名
 */
@property (weak, nonatomic) IBOutlet UILabel *doctorNameLabel;

/**
 医生职称
 */
@property (weak, nonatomic) IBOutlet UILabel *doctorLevelLabel;

/**
 医生职位
 */
@property (weak, nonatomic) IBOutlet UILabel *doctorPositionLabel;

@property (nonatomic,strong) WMStarView * starView;

- (void)setDoctorCellValue:(WMDoctorDetailModel *)model;

@end
