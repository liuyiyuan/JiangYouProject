//
//  WMNewPatienReportCell.m
//  WMDoctor
//
//  Created by 茭白 on 2016/12/19.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import "WMNewPatienReportCell.h"

@implementation WMNewPatienReportCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupView];
    // Initialization code
}
-(void)setupView{
     [self setSeparatorInset:UIEdgeInsetsMake(0,80,0,0)];
    self.headImageView.layer.cornerRadius=25;
    self.headImageView.layer.masksToBounds=YES;
    self.flagImageiew.layer.cornerRadius=4;
    self.flagImageiew.layer.masksToBounds=YES;
    
    
}
-(void)setupViewWithModel:(WMPatientReportedModel *)patientReportedModel {
    
    if (stringIsEmpty(patientReportedModel.headPicture)) {
        if ([patientReportedModel.sex intValue]==1) {
            //男
            self.headImageView.image=[UIImage imageNamed:@"ic_head_male"];
        }
        else if ([patientReportedModel.sex intValue]==2){
            //女
             self.headImageView.image=[UIImage imageNamed:@"ic_head_female"];
        }else{
             self.headImageView.image=[UIImage imageNamed:@"ic_head_wtf"];
        }
    }
    else{
        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:patientReportedModel.headPicture] placeholderImage:[UIImage imageNamed:@"ic_head_wtf"]];
    }
    self.nameLable.text=patientReportedModel.name;
    self.dateLable.text=patientReportedModel.focusTime;
    self.phoneLable.text=[self replaceWithPhoneNumber:patientReportedModel.phone];
}
-(NSString *)replaceWithPhoneNumber:(NSString *)string{
    
    NSString *shadowStr = [string stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    return shadowStr;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
