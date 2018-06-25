//
//  WMUNReadReportTableViewCell.m
//  WMDoctor
//
//  Created by JacksonMichael on 2017/7/8.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMUNReadReportTableViewCell.h"

@implementation WMUNReadReportTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCellValue:(WMAllReportListModelItems *)model{
    self.nameLabel.text = model.tname;
    self.scoreLabel.text = [NSString stringWithFormat:@"系统评分：%@分",model.score];
    self.timeLabel.text = model.udate;
    NSString * minStr;
    int min = [model.tlong intValue]/60;
    if (min < 10) {
        minStr = [NSString stringWithFormat:@"0%d",min];
    }else{
        minStr = [NSString stringWithFormat:@"%d",min];
    }
    NSString * secondStr;
    int second = [model.tlong intValue]%60;
    if (second < 10) {
        secondStr = [NSString stringWithFormat:@"0%d",second];
    }else{
        secondStr = [NSString stringWithFormat:@"%d",second];
    }
    
    self.longLabel.text = [NSString stringWithFormat:@"%@:%@",minStr,secondStr];
    
    if ([model.score intValue] < 8) {
        self.scoreLabel.textColor = [UIColor colorWithHexString:@"ff5f5c"];
    }else{
        self.scoreLabel.textColor = [UIColor colorWithHexString:@"2cd7aa"];
    }
}

@end