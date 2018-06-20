//
//  WMReportReadCell.m
//  WMDoctor
//
//  Created by JacksonMichael on 2017/7/9.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMReportReadCell.h"

@implementation WMReportReadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCellValue:(WMReportDetailModelDesc *)model{
    self.contentLabel.text = model.advice;
    self.doctorNameLabel.text = [NSString stringWithFormat:@"%@  医生",model.doctor];
}

@end
