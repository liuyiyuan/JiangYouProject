//
//  WMRecommendDocCell.m
//  WMDoctor
//
//  Created by 茭白 on 2017/3/21.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMRecommendDocCell.h"

@implementation WMRecommendDocCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.headImageVew.layer.cornerRadius=20;
    self.headImageVew.contentMode=UIViewContentModeScaleAspectFill;
    self.headImageVew.layer.masksToBounds=YES;
    // Initialization code
}
-(void)setupViewWithModel:(WMDoctorCardDetailModel *)doctorCardDetailModel{
    self.nameLabel.text=doctorCardDetailModel.doctorName;
    self.jobLable.text=doctorCardDetailModel.title;
    self.hospitalLabel.text=doctorCardDetailModel.orgName;
    [self.headImageVew sd_setImageWithURL:[NSURL URLWithString:doctorCardDetailModel.photo] placeholderImage:[UIImage imageNamed:@"ic_head_doc"]];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
