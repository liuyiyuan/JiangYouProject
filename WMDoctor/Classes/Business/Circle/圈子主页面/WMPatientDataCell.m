//
//  WMPatientDataCell.m
//  WMDoctor
//
//  Created by xugq on 2017/8/10.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMPatientDataCell.h"

@implementation WMPatientDataCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setValueWithPatientHealthModel:(WMPatientHealthModel *)health{
    self.disease.text = health.zhenduanmc;
    self.sectionName.text = health.keshimc;
    self.hospitalName.text = health.yiyuanmc;
    self.interrogationTime.text = health.jiuzhensj;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
