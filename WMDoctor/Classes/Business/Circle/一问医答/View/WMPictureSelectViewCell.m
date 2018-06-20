//
//  WMPictureSelectViewCell.m
//  Micropulse
//
//  Created by 茭白 on 2017/7/4.
//  Copyright © 2017年 iChoice. All rights reserved.
//

#import "WMPictureSelectViewCell.h"

@implementation WMPictureSelectViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.deleteButton setBackgroundImage:[UIImage imageNamed:@"im_shangchuan_close"] forState:UIControlStateNormal];
    self.showImageView.contentMode=UIViewContentModeScaleAspectFill;
    // Initialization code
    self.showImageView.layer.cornerRadius=4;
    self.showImageView.layer.masksToBounds=YES;
}
- (IBAction)deleteAction:(id)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(removeAction:)]) {
        [self.delegate removeAction:sender];
    }
}

@end
