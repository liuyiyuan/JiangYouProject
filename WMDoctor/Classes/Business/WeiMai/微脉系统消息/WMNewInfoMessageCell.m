//
//  WMNewInfoMessageCell.m
//  WMDoctor
//
//  Created by 茭白 on 2016/12/20.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import "WMNewInfoMessageCell.h"

@implementation WMNewInfoMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    //[self setupData];
    [self setupView];
    // Initialization code
}
-(void)setupView{
    self.backgroundColor=[UIColor colorWithHexString:@"f4f4f4"];
    self.bgView.layer.cornerRadius=4;
    self.bgView.layer.masksToBounds=YES;
    self.showImageView.layer.cornerRadius=2;
    self.showImageView.layer.masksToBounds=YES;
    self.showImageView.contentMode=UIViewContentModeScaleAspectFill;
    self.dateLable.layer.cornerRadius=4;
    self.dateLable.layer.masksToBounds=YES;
}

-(void)setupViewWithModel:(WMMessageListDetailModel *)messageDetailModel{
    
    
    self.dateLable.text=messageDetailModel.messageDate;
    self.titleLable.text=messageDetailModel.messageTitle;
    self.detailLable.text=messageDetailModel.messageSummary;
    
    [self.showImageView sd_setImageWithURL:[NSURL URLWithString:messageDetailModel.messageImg] placeholderImage:[UIImage imageNamed:@"wm_mess_default"]];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
