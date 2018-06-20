//
//  WMNormalMessageCell.m
//  WMDoctor
//
//  Created by 茭白 on 2016/12/20.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import "WMNormalMessageCell.h"

@implementation WMNormalMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupView];
    // Initialization code
}
-(void)setupView{
    self.backgroundColor=[UIColor colorWithHexString:@"f4f4f4"];
    self.bgView.layer.cornerRadius=4;
    self.bgView.layer.masksToBounds=YES;
    self.dateLable.layer.cornerRadius=4;
    self.dateLable.layer.masksToBounds=YES;
}

-(void)setupViewWithModel:(WMMessageListDetailModel *)messageDetailModel{
    
    self.flogImageView.hidden=YES;
    if ([messageDetailModel.skipTag intValue]==0) {
        
    }
    else{
        self.flogImageView.hidden=NO;
    }
    self.dateLable.text=messageDetailModel.messageDate;
    self.titleLable.text=messageDetailModel.messageTitle;
    self.detailLable.text=messageDetailModel.messageSummary;
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
