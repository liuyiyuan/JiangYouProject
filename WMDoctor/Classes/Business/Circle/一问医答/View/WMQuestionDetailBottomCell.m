//
//  WMQuestionDetailBottomCell.m
//  WMDoctor
//
//  Created by JacksonMichael on 2017/11/27.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMQuestionDetailBottomCell.h"
#import "UIimageView+WebCache.h"

@implementation WMQuestionDetailBottomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setCellValue:(WMQuestionDetailInfoModel *)model{
    self.doctorName.text = model.doctorName;
    self.doctorTitle.text = model.title;
    
    [self.doctorImage sd_setImageWithURL:[NSURL URLWithString:model.doctorImage]];
    self.doctorAnswer.text = model.answerContent;
    self.departmentName.text = [NSString stringWithFormat:@"%@/%@",model.departmentName,model.organizationName];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
