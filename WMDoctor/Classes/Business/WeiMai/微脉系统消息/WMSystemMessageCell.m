//
//  WMSystemMessageCell.m
//  WMDoctor
//
//  Created by 茭白 on 2016/12/20.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import "WMSystemMessageCell.h"

@implementation WMSystemMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setSeparatorInset:UIEdgeInsetsMake(0,80,0,0)];
    [self setupView];
   
}
-(void)setupView{
    self.headImageView.layer.cornerRadius=4;
    self.headImageView.layer.masksToBounds=YES;
    self.numberLabel.layer.cornerRadius=8;
    self.numberLabel.layer.masksToBounds=YES;
    self.dateLable.layer.cornerRadius=4;
    self.dateLable.layer.masksToBounds=YES;
}
//模拟一下数据

-(void)setupViewWithModel:(WMMessageDetailModel *)messageDetailModel{
    
    
    self.numberLabel.hidden=YES;
    self.nameLabel.text=messageDetailModel.name;
    self.detailLabe.text=messageDetailModel.summary;
    
    [self selectheadImageWithModel:messageDetailModel];
    //未读数
    if ([messageDetailModel.noread intValue]>99) {
        self.numberLabel.hidden=NO;
        [self.numberLabel updateViewContraint:NSLayoutAttributeWidth value:25];
        self.numberLabel.text = @"99+";
    }
    else if([messageDetailModel.noread intValue]<99 &&[messageDetailModel.noread intValue]>0){
        self.numberLabel.hidden=NO;
        [self.numberLabel updateViewContraint:NSLayoutAttributeWidth value:16];
        self.numberLabel.text = [NSString stringWithFormat:@"%@",messageDetailModel.noread];
    }
    
    self.dateLable.text=messageDetailModel.messageDate;
    
    
}
-(void)selectheadImageWithModel:(WMMessageDetailModel *)messageDetailModel{
    /*
      //1002:通知消息 1003:交易消息 1005:推荐资讯
     */
    if ([messageDetailModel.type intValue]==1002) {
       self.headImageView.image=[UIImage imageNamed:@"wm_message_infor"];
        
    }else if ([messageDetailModel.type intValue]==1003){
        
        self.headImageView.image=[UIImage imageNamed:@"wm_message_pay"];
    }
    else if ([messageDetailModel.type intValue]==1005){
        
        self.headImageView.image=[UIImage imageNamed:@"wm_message_news"];
    } else if ([messageDetailModel.type intValue] == 1006){
        
        self.headImageView.image = [UIImage imageNamed:@"wm_message_zixun"];
    }
    else{
        self.headImageView.image=[UIImage imageNamed:@"wm_message_default"];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
