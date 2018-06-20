//
//  WMGroupMemberViewCell.m
//  Micropulse
//
//  Created by 茭白 on 2017/7/20.
//  Copyright © 2017年 iChoice. All rights reserved.
//

#import "WMGroupMemberViewCell.h"
#import <UIImageView+WebCache.h>
@implementation WMGroupMemberViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.headImageView.layer.cornerRadius=25;
    self.headImageView.layer.masksToBounds=YES;
    // Initialization code
}
-(void)setupViewWithModel:(WMOneMemberModel *)model{
   
//    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.pictureUrl] placeholderImage:[UIImage imageNamed:@"im_head_male"]];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.pictureUrl] placeholderImage:[UIImage imageNamed:@"im_head_male"] options:SDWebImageAllowInvalidSSLCertificates];//医生站位图 ic_head_doc 患者占位图 im_head_male
    self.nameLabel.text = model.userName;
    self.userTypeImageView.hidden = NO;
    if ([model.userType intValue] == 1) {
        self.userTypeImageView.image = [UIImage imageNamed:@"type_doctor"];
    } else if ([model.userType intValue] == 2){
        self.userTypeImageView.image = [UIImage imageNamed:@"type_assistant"];
    } else{
        self.userTypeImageView.hidden = YES;
    }
    
}
@end
