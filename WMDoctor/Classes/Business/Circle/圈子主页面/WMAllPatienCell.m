//
//  WMAllPatienCell.m
//  WMDoctor
//
//  Created by 茭白 on 2017/2/21.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMAllPatienCell.h"

@implementation WMAllPatienCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupCellView];
}

-(void)setupCellView{
    
    
    
    
}

-(void)setupViewWithModel:(WMPatientReportedModel *)patientReportedModel withTag:(NSInteger )cellIndex {
    
    if (stringIsEmpty(patientReportedModel.headPicture)) {
        if ([patientReportedModel.sex intValue]==1) {
            //男
            self.headImageView.image=[UIImage imageNamed:@"ic_head_male"];
        }
        else if ([patientReportedModel.sex intValue]==2){
            //女
            self.headImageView.image=[UIImage imageNamed:@"ic_head_female"];
        }else{
            self.headImageView.image=[UIImage imageNamed:@"ic_head_wtf"];
        }
    }
    else{
        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:patientReportedModel.headPicture] placeholderImage:[UIImage imageNamed:@"ic_head_wtf"]];
    }
    self.nameLable.text=patientReportedModel.name;
    NSString *tagStr = @"";
    for (WMPatientTagModel *objTag in patientReportedModel.tagGroups) {
        tagStr = [tagStr stringByAppendingString:objTag.tagName];
        tagStr = [tagStr stringByAppendingString:@","];
    }
    if (tagStr.length > 1) {
        tagStr = [tagStr substringToIndex:tagStr.length - 1];
    }
    self.dateLable.text = tagStr;
    
    NSString *sexStr = @"";
    if ([patientReportedModel.sex intValue] == 1) {
        sexStr = @"男";
    } else if ([patientReportedModel.sex intValue] == 2){
        sexStr = @"女";
    }
    self.symptomsLable.text = [NSString stringWithFormat:@"%@  %@岁", sexStr, patientReportedModel.age];

    self.acceptButton.tag=cellIndex+200;
    //self.phoneLable.text=[self replaceWithPhoneNumber:patientReportedModel.phone];
}
-(NSString *)replaceWithPhoneNumber:(NSString *)string{
    
    NSString *shadowStr = [string stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    return shadowStr;
    
}
- (IBAction)acceptAction:(id)sender {
    UIButton *butotn=sender;
    
    if (self.delegate &&[self.delegate respondsToSelector:@selector(acceptPatientReportAction:)] ) {
        [self.delegate acceptPatientReportAction:butotn];
    }
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
