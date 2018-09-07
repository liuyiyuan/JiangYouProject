//
//  WMIndexQuestionsCell.m
//  WMDoctor
//
//  Created by JacksonMichael on 2018/2/1.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "WMIndexQuestionsCell.h"

@implementation WMIndexQuestionsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.theView.layer.shadowOffset = CGSizeMake(0, 0.5);
    self.theView.layer.shadowColor = [UIColor colorWithHexString:@"d0d0d0"].CGColor;
    self.theView.layer.shadowOpacity = 0.3;
    
    self.theView.layer.shadowRadius = 2;
    
    self.theView.layer.cornerRadius = 4;
    
    self.theView.clipsToBounds = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



- (IBAction)anwerBtn:(id)sender {
    
}

@end
