//
//  WMReportReadCell.h
//  WMDoctor
//
//  Created by JacksonMichael on 2017/7/9.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMReportDetailModel.h"

@interface WMReportReadCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *doctorNameLabel;

-(void)setCellValue:(WMReportDetailModelDesc *)model;
@end
