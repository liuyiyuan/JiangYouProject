//
//  WMDoctorInfoCell.m
//  WMDoctor
//  个人中心里医生信息的CELL
//  Created by JacksonMichael on 2016/12/29.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import "WMDoctorInfoCell.h"

@implementation WMDoctorInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.starView = [[WMStarView alloc]initWithFrame:CGRectMake(88, 100 - 35, 100, 15)];
    self.doctorHeadImageView.layer.masksToBounds = YES;
//    self.doctorHeadImageView.backgroundColor = [UIColor colorWithHexString:@"f0f0f0"];
    self.doctorHeadImageView.layer.cornerRadius = 30;
    [self addSubview:self.starView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDoctorCellValue:(WMDoctorDetailModel *)model{
    self.doctorNameLabel.text = model.doctorName;
    self.doctorLevelLabel.text = model.title;
    self.doctorPositionLabel.text = model.keshiName;
    [self.doctorHeadImageView sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:[UIImage imageNamed:@"ic_head_doc"]];
    
    //星星
    self.starView.openValue = YES;
    [self.starView setStarValue:[model.star floatValue]];
    
    
    
}

@end
