//
//  WMDoctorPriceCell.m
//  WMDoctor
//
//  Created by JacksonMichael on 2016/12/29.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import "WMDoctorPriceCell.h"

@implementation WMDoctorPriceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setCellValue:(NSString *)price{
    _priceLabel.text = (stringIsEmpty(price))?@"图文咨询":[NSString stringWithFormat:@"图文咨询（%@元/次）",price];
    
}


@end
