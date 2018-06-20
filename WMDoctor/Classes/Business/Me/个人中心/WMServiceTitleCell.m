//
//  WMServiceTitleCell.m
//  WMDoctor
//
//  Created by JacksonMichael on 2017/4/19.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMServiceTitleCell.h"

@implementation WMServiceTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setCellValue:(NSString *)notingStr andPrice:(NSString *)priceStr{
    self.nothingLabel.text = notingStr;
    self.priceLabel.text = priceStr;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
