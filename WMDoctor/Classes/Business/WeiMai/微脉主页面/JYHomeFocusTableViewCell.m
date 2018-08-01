//
//  JYHomeFocusTableViewCell.m
//  WMDoctor
//
//  Created by zhenYan on 2018/8/1.
//  Copyright © 2018年 Choice. All rights reserved.
//
//首页  关注
#import "JYHomeFocusTableViewCell.h"

@implementation JYHomeFocusTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        
    }
    return self;
}

-(void)configUI{
    [self.contentView addSubview:self.headerImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.focusButton];//关注按钮
    [self.contentView addSubview:self.deleteButton];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.firstImageView];
    [self.contentView addSubview:self.secondImageView];
    [self.contentView addSubview:self.thirdImageView];
    [self.contentView addSubview:self.addressButton];
    [self.contentView addSubview:self.readCountLabel];
    [self.contentView addSubview:self.forwardingButton];
    [self.contentView addSubview:self.commentsButton];
    [self.contentView addSubview:self.likedButton];
    
    
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(pixelValue(30));
        make.left.mas_equalTo(pixelValue(30));
        make.width.height.mas_equalTo(pixelValue(50));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
    }];
    
    [self.focusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
    }];
    
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
    }];
    
    [self.firstImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
    }];
    
    [self.secondImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
    }];
    
    [self.thirdImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
    }];
    
    [self.addressButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
    }];
    
    [self.readCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
    }];
    
    [self.forwardingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
    }];
    
    [self.commentsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
    }];
    
    [self.likedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
    }];
}
//头像
-(UIImageView *)headerImageView{
    if(!_headerImageView){
        
    }
    return _headerImageView;
}
//名称label
-(UILabel *)nameLabel{
    if(!_nameLabel){
        
    }
    return _nameLabel;
}
//时间label
-(UILabel *)timeLabel{
    if(!_timeLabel){
        
    }
    return _timeLabel;
}
//关注按钮
-(UIButton *)focusButton{
    if(!_focusButton){
        
    }
    return _focusButton;
}
//删除按钮
-(UIButton *)deleteButton{
    if(!_deleteButton){
        
    }
    return _deleteButton;
}
//内容label
-(UILabel *)contentLabel{
    if(!_contentLabel){
        
    }
    return _contentLabel;
}
//第一张图
-(UIImageView *)firstImageView{
    if(!_firstImageView){
        
    }
    return _firstImageView;
}
//第二张图
-(UIImageView *)secondImageView{
    if(!_secondImageView){
        
    }
    return _secondImageView;
}
//第三张图
-(UIImageView *)thirdImageView{
    if(!_thirdImageView){
        
    }
    return _thirdImageView;
}
//地址
-(UIButton *)addressButton{
    if(!_addressButton){
        
    }
    return _addressButton;
}
//阅读数
-(UILabel *)readCountLabel{
    if(!_readCountLabel){
        
    }
    return _readCountLabel;
}
//转发
-(UIButton *)forwardingButton{
    if(!_forwardingButton){
        
    }
    return _forwardingButton;
    
}
//评论
-(UIButton *)commentsButton{
    if(!_commentsButton){
        
    }
    return _commentsButton;
}
//赞
-(UIButton *)likedButton{
    if(!_likedButton){
        
    }
    return _likedButton;
}

@end
