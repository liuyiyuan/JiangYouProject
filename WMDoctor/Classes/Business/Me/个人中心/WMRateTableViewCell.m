//
//  WMRateTableViewCell.m
//  WMDoctor
//
//  Created by JacksonMichael on 2016/12/22.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import "WMRateTableViewCell.h"




@implementation WMRateTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.starView = [[WMStarView alloc]initWithFrame:CGRectMake(15, 15, 100, 15)];
    [self addSubview:self.starView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setRateCellValue:(WMDoctorServiceCommentsModel *)model{
    NSLog(@"starrrr=%@",model.star);
    
    [self.starView setStarValue:[model.star floatValue]];
    
    self.layer.borderColor = [UIColor colorWithHexString:@"dedede"].CGColor;
    self.layer.borderWidth = 0.5;
    self.commentContentLabel.text = model.commentContent;
    self.commentDateLabel.text = model.commentDate;
    self.phoneLabel.text = model.phone;
    
    
}


-(void)setLabelArr:(NSArray *)labelArr {
    [self.commentTagView configeWithData:labelArr];
}


@end
