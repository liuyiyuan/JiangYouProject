//
//  WMVIPPatientTableViewCell.m
//  WMDoctor
//
//  Created by 茭白 on 2017/3/16.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMVIPPatientTableViewCell.h"
#import "UIImage+Generate.h"
@implementation WMVIPPatientTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.typeLable.layer.cornerRadius=9;
    self.typeLable.layer.masksToBounds=YES;
    self.headImageView.layer.cornerRadius=20;
    self.headImageView.layer.masksToBounds=YES;
    // Initialization code
}
-(void)setViewWithModel:(WMVPIPatientsDetailModel *)patientsDetailModel {
    [CommonUtil backgroundColorInView:self.typeLable andStartColorStr:@"ff8f8d" andEndColorStr:@"ff5f5c"];

    if (stringIsEmpty(patientsDetailModel.avator)) {
        if ([patientsDetailModel.sex intValue]==1) {
            //男
            self.headImageView.image=[UIImage imageNamed:@"ic_head_male"];
        }
        else if ([patientsDetailModel.sex intValue]==2){
            //女
            self.headImageView.image=[UIImage imageNamed:@"ic_head_female"];
        }else{
            self.headImageView.image=[UIImage imageNamed:@"ic_head_wtf"];
        }
    }
    else{
        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:patientsDetailModel.avator] placeholderImage:[UIImage imageNamed:@"ic_head_wtf"]];
    }

    self.dateLable.text=patientsDetailModel.visitDate;
    self.nameLabel.text=patientsDetailModel.name;
    self.typeLable.text=patientsDetailModel.tag;
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
