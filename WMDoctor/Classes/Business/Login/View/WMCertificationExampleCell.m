//
//  WMCertificationExampleCell.m
//  WMDoctor
//
//  Created by 茭白 on 2017/5/16.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMCertificationExampleCell.h"

@implementation WMCertificationExampleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.pictureImageView.contentMode=UIViewContentModeScaleAspectFit;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
