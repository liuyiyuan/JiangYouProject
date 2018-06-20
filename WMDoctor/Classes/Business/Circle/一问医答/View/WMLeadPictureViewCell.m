//
//  WMLeadPictureViewCell.m
//  Micropulse
//
//  Created by 茭白 on 2017/7/5.
//  Copyright © 2017年 iChoice. All rights reserved.
//

#import "WMLeadPictureViewCell.h"

@implementation WMLeadPictureViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.bgView.layer.borderWidth=0.68;
    self.bgView.layer.borderColor=[[UIColor colorWithHexString:@"CCCCCC"] CGColor];

    // Initialization code
}

@end
