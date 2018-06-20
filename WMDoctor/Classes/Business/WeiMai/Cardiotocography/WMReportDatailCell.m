//
//  WMReportDatailCell.m
//  WMDoctor
//
//  Created by JacksonMichael on 2017/7/8.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMReportDatailCell.h"

@implementation WMReportDatailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setValueCell:(WMReportDetailModelData *)model{
    self.scoreLabel.text = [NSString stringWithFormat:@"系统评分：%@分",model.score];
    self.nameLabel.text = model.name;
    self.otherLabel.text = [NSString stringWithFormat:@"%@岁 / %@ / %@",model.age,model.expectedDate,model.phone];
//    self.detailLabel.text = @"";
    self.timeLabel.text = model.sendTime;
    
    self.diseaseLabel.text = [NSString stringWithFormat:@"疾病史：%@",stringIsEmpty(model.medicalhistory)?@"暂无":model.medicalhistory];
    
//    if ([model.score intValue] < 8) {
//        self.scoreLabel.textColor = [UIColor colorWithHexString:@"ff5f5c"];
//    }else{
//        self.scoreLabel.textColor = [UIColor colorWithHexString:@"2cd7aa"];
//    }
}

@end
