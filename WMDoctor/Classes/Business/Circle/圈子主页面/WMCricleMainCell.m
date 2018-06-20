//
//  WMCricleMainCell.m
//  WMDoctor
//
//  Created by 茭白 on 2016/12/14.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import "WMCricleMainCell.h"

@implementation WMCricleMainCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setSeparatorInset:UIEdgeInsetsMake(0,70,0,0)];
    self.headImageView.layer.cornerRadius=20;
    self.headImageView.layer.masksToBounds=YES;
    self.unreadLable.layer.cornerRadius=10;
    self.unreadLable.layer.masksToBounds=YES;
    // Initialization code
}
-(void)setupViewWithModel:(WMCricleGroupModel *)circleGroupModel{
    
    self.numberLable.hidden=NO;
    self.unreadLable.hidden=YES;
    /*
    if ([circleGroupModel.groupType intValue]==1) {
        self.unreadLable.hidden=NO;
        if ([circleGroupModel.number intValue]>0) {
            self.unreadLable.backgroundColor=[UIColor colorWithHexString:@"FF0000"];
            self.unreadLable.text=circleGroupModel.number;
            
        }else
        {
            self.unreadLable.backgroundColor=[UIColor clearColor];
        }

        
    }else{
        self.numberLable.hidden=NO;
        self.numberLable.text=circleGroupModel.number;
    } */
    if (stringIsEmpty(circleGroupModel.groupPicture)) {
        self.nameLabelLeft.constant = -40;
        self.headImageView.hidden = YES;
    } else{
        self.nameLabelLeft.constant = 15;
        self.headImageView.hidden = NO;
        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:circleGroupModel.groupPicture] placeholderImage:[UIImage imageNamed:@"ic_head_wtf"]];
    }
   
    self.nameLable.text=circleGroupModel.groupName;
    if ([circleGroupModel.groupType intValue] == 5) {
        self.numberLable.textAlignment = NSTextAlignmentCenter;
    } else{
        self.numberLable.textAlignment = NSTextAlignmentRight;
    }
    if ([circleGroupModel.number intValue] > 99999) {
        self.numberLable.text = @"99999+";
    }else{
        self.numberLable.text = circleGroupModel.number;
    }
}

- (void)medicalCircleVCSetupValueWithModel:(WMCricleGroupModel *)circleGroupModel{
    self.numberLable.hidden=NO;
    self.unreadLable.hidden=YES;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:circleGroupModel.groupPicture] placeholderImage:[UIImage imageNamed:@"ic_head_wtf"]];
    self.nameLable.text=circleGroupModel.groupName;
    if ([circleGroupModel.groupType intValue] == 5) {
        self.numberLable.textAlignment = NSTextAlignmentCenter;
    } else{
        self.numberLable.textAlignment = NSTextAlignmentRight;
    }
    if ([circleGroupModel.number intValue] > 99999) {
        self.numberLable.text = @"99999+";
    }else{
        self.numberLable.text = circleGroupModel.number;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
