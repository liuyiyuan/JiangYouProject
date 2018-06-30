//
//  JYInformaitonHeaderView.m
//  WMDoctor
//
//  Created by zhenYan on 2018/6/30.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYInformaitonHeaderView.h"

@implementation JYInformaitonHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor whiteColor];
        [self configUI];
    }
    return self;
}

- (void)configUI {
    [self addSubview:self.headerImageView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.ageLabel];
    [self addSubview:self.phoneLabel];

    
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(pixelValue(20));
        make.width.height.mas_equalTo(80);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headerImageView.mas_right).offset(10);
        make.top.mas_equalTo(self.headerImageView.mas_top).offset(10);
        make.height.mas_equalTo(20);
    }];
    
    [self.ageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel.mas_left);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(14);
    }];
    
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ageLabel.mas_left);
        make.top.mas_equalTo(self.ageLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(14);
    }];

    
}
//头像
-(UIImageView *)headerImageView{
    if(!_headerImageView){
        _headerImageView = [[UIImageView alloc]init];
        _headerImageView.image = [UIImage imageNamed:@"ic_gouxuan"];
        _headerImageView.layer.cornerRadius = 20;
        _headerImageView.layer.masksToBounds = YES;
    }
    return _headerImageView;
}
//姓名
-(UILabel *)nameLabel{
    if(!_nameLabel){
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.text = @"昵称:放屁的怪咖";
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.font = [UIFont fontWithName:@"MicrosoftYaHei" size:10];
    }
    return _nameLabel;
}
//年龄
-(UILabel *)ageLabel{
    if(!_ageLabel){
        _ageLabel = [[UILabel alloc]init];
        _ageLabel.textColor = [UIColor blackColor];
        _ageLabel.text = @"年龄:30岁";
        
    }
    return _ageLabel;
}
//手机号
-(UILabel *)phoneLabel{
    if(!_phoneLabel){
        _phoneLabel = [[UILabel alloc]init];
        _phoneLabel.text = @"151 9999 9999";
        _phoneLabel.textColor = [UIColor blackColor];
    }
    return _phoneLabel;
}

@end
