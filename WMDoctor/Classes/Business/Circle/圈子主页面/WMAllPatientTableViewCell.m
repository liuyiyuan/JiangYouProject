//
//  WMAllPatientTableViewCell.m
//  WMDoctor
//
//  Created by 茭白 on 2017/2/23.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMAllPatientTableViewCell.h"
#import "CommonUtil.h"
@implementation WMAllPatientTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.headImageView.layer.cornerRadius=20;
    self.headImageView.layer.masksToBounds=YES;
    self.VIPFlag.layer.cornerRadius=9;
    self.VIPFlag.layer.masksToBounds=YES;

    // Initialization code
}
-(void)setupViewWithModel:(WMTotalPatientsModel *)totalPatientsDataModel{
    self.VIPFlag.hidden=YES;
    [CommonUtil backgroundColorInView:self.VIPFlag andStartColorStr:@"ff8f8d" andEndColorStr:@"ff5f5c"];
    if (stringIsEmpty(totalPatientsDataModel.headPicture)) {
        if ([totalPatientsDataModel.sex intValue]==1) {
            //男
            self.headImageView.image=[UIImage imageNamed:@"ic_head_male"];
        }
        else if ([totalPatientsDataModel.sex intValue]==2){
            //女
            self.headImageView.image=[UIImage imageNamed:@"ic_head_female"];
        }else{
            self.headImageView.image=[UIImage imageNamed:@"ic_head_wtf"];
        }
    }
    else{
        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:totalPatientsDataModel.headPicture] placeholderImage:[UIImage imageNamed:@"ic_head_wtf"]];
    }
    
    self.nameLable.text=totalPatientsDataModel.name;
    self.dateLable.text=totalPatientsDataModel.focusTime;
    if ([totalPatientsDataModel.vip intValue]==1) {
        self.VIPFlag.hidden=NO;
        self.VIPFlag.text = @"VIP";
    } else if ([totalPatientsDataModel.vip intValue] == 2){
        self.VIPFlag.hidden = NO;
        self.VIPFlag.text = @"妇幼";
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
