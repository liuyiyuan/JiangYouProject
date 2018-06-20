//
//  WMFasterReplyCell.m
//  Micropulse
//
//  Created by 茭白 on 2016/12/20.
//  Copyright © 2016年 iChoice. All rights reserved.
//

#import "WMFasterReplyCell.h"

@implementation WMFasterReplyCell

- (void)awakeFromNib {
    [super awakeFromNib];
   [self setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
