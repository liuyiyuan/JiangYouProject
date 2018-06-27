//
//  JYMeHeaderView.m
//  WMDoctor
//
//  Created by jiangqi on 2018/6/25.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYMeHeaderView.h"

@implementation JYMeHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self configUI];
    }
    return self;
}

- (void)configUI {
    [self addSubview:self.headerImageView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.ageLabel];
    [self addSubview:self.phoneLabel];
    [self addSubview:self.moneyLabel];
    [self addSubview:self.arrowButton];
    
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(20);
        make.width.height.mas_equalTo(40);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headerImageView.mas_right).offset(10);
        make.top.mas_equalTo(self.headerImageView.mas_top).offset(5);
        make.height.mas_equalTo(10);
    }];
    
    [self.ageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel.mas_left);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(5);
        make.height.mas_equalTo(7);
    }];
    
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ageLabel.mas_left);
        make.top.mas_equalTo(self.ageLabel.mas_bottom).offset(5);
        make.height.mas_equalTo(6);
    }];
    
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-20);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-10);
        make.height.mas_equalTo(11);
    }];
    
    [self.arrowButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-20);
        make.width.height.mas_equalTo(17);
        make.top.mas_equalTo(self.mas_top).offset(10);
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
        _nameLabel.textColor = [UIColor whiteColor];
       _nameLabel.font = [UIFont fontWithName:@"MicrosoftYaHei" size:10];
    }
    return _nameLabel;
}
//年龄
-(UILabel *)ageLabel{
    if(!_ageLabel){
        _ageLabel = [[UILabel alloc]init];
        _ageLabel.textColor = [UIColor whiteColor];
        _ageLabel.text = @"年龄:30岁";
        
    }
    return _ageLabel;
}
//手机号
-(UILabel *)phoneLabel{
    if(!_phoneLabel){
        _phoneLabel = [[UILabel alloc]init];
        _phoneLabel.text = @"151 9999 9999";
        _phoneLabel.textColor = [UIColor colorWithHexString:@"#FFF600"];
    }
    return _phoneLabel;
}
//金币
-(UILabel *)moneyLabel{
    if(!_moneyLabel){
        _moneyLabel = [[UILabel alloc]init];
        _moneyLabel.text = @"金币:10000000";
        _moneyLabel.textColor = [UIColor whiteColor];
    }
    return _moneyLabel;
}
//箭头按钮
-(UIButton *)arrowButton{
    if(!_arrowButton){
        _arrowButton = [[UIButton alloc]init];
        [_arrowButton setImage:[UIImage imageNamed:@"arrow_button"] forState:UIControlStateNormal];
    }
    return _arrowButton;
}



@end
