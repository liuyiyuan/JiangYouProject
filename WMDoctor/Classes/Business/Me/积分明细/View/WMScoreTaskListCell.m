//
//  WMScoreTaskListCell.m
//  WMDoctor
//
//  Created by JacksonMichael on 2017/11/28.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMScoreTaskListCell.h"

@implementation WMScoreTaskListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.taskBtn.layer.cornerRadius = 5;
    // Initialization code
}

- (void)setCellValue:(WMScoreTaskDetailModel *)model{
    self.allModel = model;
    self.taskName.text = model.taskName;
    self.taskDesc.text = model.taskDesc;
    self.taskScore.text = [NSString stringWithFormat:@"+%@",model.score];
    if ([model.taskCode isEqualToString:@"1000"]) {     //签到
        self.finishLabel.text = [NSString stringWithFormat:@"已连续%@天",model.finishNum];
    }else{
        self.finishLabel.text = @"";
    }
    
    if (stringIsEmpty(model.buttonText)) {
        self.taskBtn.hidden = YES;
    }else{
        self.taskBtn.hidden = NO;
    }
    
    
    [self.taskBtn setTitle:model.buttonText forState:UIControlStateNormal];
    if ([model.status isEqualToString:@"0"]) {  //未完成
        [self.taskBtn setTitleColor:[UIColor colorWithHexString:@"18a2ff"] forState:UIControlStateNormal];
        self.taskBtn.layer.borderWidth = 0.5;
        self.taskBtn.layer.borderColor = [UIColor colorWithHexString:@"18a2ff"].CGColor;
        [self.taskBtn setBackgroundColor:[UIColor colorWithHexString:@"ffffff"]];
        self.taskBtn.userInteractionEnabled = YES;
    }else{
        [self.taskBtn setTitleColor:[UIColor colorWithHexString:@"bbbbbb"] forState:UIControlStateNormal];
        self.taskBtn.layer.borderWidth = 0;
        self.taskBtn.layer.borderColor = nil;
        [self.taskBtn setBackgroundColor:[UIColor colorWithHexString:@"dedede"]];
        self.taskBtn.userInteractionEnabled = NO;
    }
    
}
- (IBAction)btnClick:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(cellBtnClick:)]) {
        [self.delegate cellBtnClick:self.allModel.taskCode];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
