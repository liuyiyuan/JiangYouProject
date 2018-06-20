//
//  WMOrderCountCell.m
//  WMDoctor
//
//  Created by JacksonMichael on 2017/1/3.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMOrderCountCell.h"

@implementation WMOrderCountCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setValueForCell:(NSString *)price{
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@",price];
}

@end
