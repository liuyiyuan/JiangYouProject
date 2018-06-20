//
//  WMServiceListCell.m
//  WMDoctor
//
//  Created by JacksonMichael on 2017/12/7.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMServiceListCell.h"

@implementation WMServiceListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.priceOne.layer.borderColor = [UIColor colorWithHexString:@"dbdbdb"].CGColor;
    self.priceTwo.layer.borderColor = [UIColor colorWithHexString:@"dbdbdb"].CGColor;
    self.priceOne.layer.borderWidth = 0.5;
    self.priceTwo.layer.borderWidth = 0.5;
    self.priceOne.layer.cornerRadius = 4;
    self.priceTwo.layer.cornerRadius = 4;
    self.priceOne.layer.masksToBounds = YES;
    self.priceTwo.layer.masksToBounds = YES;
    self.iconImage.layer.cornerRadius = 25;
    self.iconImage.layer.masksToBounds = YES;
    self.priceOne.hidden = YES;
    self.priceTwo.hidden = YES;
}

- (void)setCellValue:(WMDoctorMyServiceModel *)model{
    self.titleLabel.text = model.name;
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:model.img]];
//    self.discLabel.text = model
    self.openBtn.tag = [model.inquiryType intValue];
    if (model.openService == 0) {       //未开启
        self.discLabel.text = @"尚未提供此服务";
        [self.openBtn setTitle:@"开启" forState:UIControlStateNormal];
        self.discLabel.hidden = NO;
        self.priceOne.hidden = YES;
        self.priceTwo.hidden = YES;
    }else if (model.openService == 1){      //开启
        self.discLabel.hidden = YES;
        [self.openBtn setTitle:@"设置" forState:UIControlStateNormal];
        if (model.prices.count < 2 && model.prices.count > 0) {
            self.priceOne.text = model.prices[0];
            self.priceOne.hidden = NO;
            self.priceTwo.hidden = YES;
        }else if(model.prices.count > 1){
            self.priceOne.text = model.prices[0];
            self.priceTwo.text = model.prices[1];
            self.priceTwo.hidden = NO;
            self.priceOne.hidden = NO;
        }
    }
    
    
    
}

- (IBAction)openClick:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cellClickBtn: andBtn:)]) {
        NSString * btnTitle = ((UIButton *)sender).titleLabel.text;
        [self.delegate cellClickBtn:btnTitle andBtn:sender];
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
