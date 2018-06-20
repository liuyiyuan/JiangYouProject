//
//  WMHealthRecordCell.m
//  WMDoctor
//
//  Created by 茭白 on 2016/12/22.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import "WMHealthRecordCell.h"

@implementation WMHealthRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setupView];
    // Initialization code
}
-(void)setupView{
    self.backgroundColor=[UIColor colorWithHexString:@"f4f4f4"];
    self.bgView.layer.cornerRadius=5;
    self.bgView.layer.masksToBounds=YES;
}
-(void)setupViewWithDetailModel:(WMPatientsHealthDetailModel *)patientsHealthDetailModel{
    
    self.casetypeLable.text=patientsHealthDetailModel.zhenduanmc;
    self.timeLabel.text=patientsHealthDetailModel.jiuzhensj;
    self.sectionLabel.text=patientsHealthDetailModel.keshimc;
    self.hospitalLabel.text=patientsHealthDetailModel.yiyuanmc;
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
