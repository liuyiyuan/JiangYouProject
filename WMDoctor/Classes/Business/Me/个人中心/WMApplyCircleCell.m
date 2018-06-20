//
//  WMApplyCircleCell.m
//  WMDoctor
//
//  Created by JacksonMichael on 2017/12/12.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMApplyCircleCell.h"

@implementation WMApplyCircleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)goApply:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(goCircle)]) {
        [self.delegate goCircle];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
