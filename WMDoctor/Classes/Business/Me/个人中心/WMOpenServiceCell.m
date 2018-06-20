//
//  WMOpenServiceCell.m
//  WMDoctor
//
//  Created by JacksonMichael on 2017/4/19.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMOpenServiceCell.h"

@implementation WMOpenServiceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)valueChanged:(id)sender {
    if (_cellDelegate&&[_cellDelegate respondsToSelector:@selector(changedSwitchValue:)]) {
        [_cellDelegate changedSwitchValue:self.openServiceSwitch.on];
    }
}

@end
