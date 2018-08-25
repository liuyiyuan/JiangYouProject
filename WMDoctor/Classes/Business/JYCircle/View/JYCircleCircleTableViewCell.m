//
//  JYCircleCircleTableViewCell.m
//  WMDoctor
//
//  Created by zhenYan on 2018/8/25.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYCircleCircleTableViewCell.h"

@implementation JYCircleCircleTableViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self configUI];
    }
    return self;
}

-(void)configUI{
    
    CGFloat margin = (UI_SCREEN_WIDTH - pixelValue(171) * 4) / 5;
    
    [self.contentView addSubview:self.headerView];
    [self.contentView addSubview:self.crownImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.countLabel];
    [self.contentView addSubview:self.focusButton];
    [self.contentView addSubview:self.firstImagView];
    [self.contentView addSubview:self.secondImagView];
    [self.contentView addSubview:self.thirdImagView];
    [self.contentView addSubview:self.fourthImagView];
    [self.contentView addSubview:self.lineView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(pixelValue(30));
        make.left.mas_equalTo(pixelValue(30));
        make.width.height.mas_equalTo(pixelValue(80));
    }];
    [self.crownImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headerView.mas_top).offset(-pixelValue(10));
        make.left.mas_equalTo(self.headerView.mas_left).offset(-pixelValue(10));
        make.width.height.mas_equalTo(pixelValue(30));
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headerView.mas_top);
        make.left.mas_equalTo(self.headerView.mas_right).offset(pixelValue(20));
        make.height.mas_equalTo(pixelValue(30));
    }];
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.headerView.mas_bottom);
        make.left.mas_equalTo(self.nameLabel.mas_left);
        make.height.mas_equalTo(pixelValue(30));
    }];
    [self.focusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-pixelValue(30));
        make.centerY.mas_equalTo(self.headerView.mas_centerY);
        make.width.mas_equalTo(pixelValue(116));
        make.height.mas_equalTo(pixelValue(51));
    }];
    [self.firstImagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headerView.mas_bottom).offset(pixelValue(20));
        make.left.mas_equalTo(margin);
        make.width.height.mas_equalTo(pixelValue(171));
    }];
    [self.secondImagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.firstImagView.mas_top);
        make.left.mas_equalTo(self.firstImagView.mas_right).offset(margin);
        make.width.height.mas_equalTo(pixelValue(171));
    }];
    [self.thirdImagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.firstImagView.mas_top);
        make.left.mas_equalTo(self.secondImagView.mas_right).offset(margin);
        make.width.height.mas_equalTo(pixelValue(171));
    }];
    [self.fourthImagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.firstImagView.mas_top);
        make.left.mas_equalTo(self.thirdImagView.mas_right).offset(margin);
        make.width.height.mas_equalTo(pixelValue(171));
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.firstImagView.mas_bottom).offset(pixelValue(20));
        make.left.mas_equalTo(pixelValue(0));
        make.right.mas_equalTo(pixelValue(0));
        make.height.mas_equalTo(pixelValue(pixelValue(20)));
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
    
}

//头像
-(UIImageView *)headerView{
    if(!_headerView){
        _headerView = [[UIImageView alloc]init];
        _headerView.image = [UIImage imageNamed:@"矩形 211"];
        _headerView.layer.cornerRadius = pixelValue(40);
        _headerView.layer.masksToBounds = YES;
    }
    return _headerView;
}
//皇冠
-(UIImageView *)crownImageView{
    if(!_crownImageView){
        _crownImageView = [[UIImageView alloc]init];
        _crownImageView.image = [UIImage imageNamed:@"图层 18"];
    }
    return _crownImageView;
}

//昵称
-(UILabel *)nameLabel{
    if(!_nameLabel){
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.text = @"向日葵";
        _nameLabel.textColor = [UIColor colorWithHexString:@"#4DA9FF"];
        _nameLabel.font = [UIFont systemFontOfSize:pixelValue(28)];
    }
    return _nameLabel;
}
//被赞多少次
-(UILabel *)countLabel{
    if(!_countLabel){
        _countLabel = [[UILabel alloc]init];
        _countLabel.text = @"被赞37次 | 1452张图片";
        _countLabel.font = [UIFont systemFontOfSize:pixelValue(26)];
        _countLabel.textColor = [UIColor colorWithHexString:@"#ABA9A9"];
    }
    return _countLabel;
}
//关注按钮
-(UIButton *)focusButton{
    if(!_focusButton){
        _focusButton = [[UIButton alloc]init];
        [_focusButton setTitle:@"关注" forState:UIControlStateNormal];
        [_focusButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_focusButton setBackgroundColor:[UIColor colorWithHexString:@"#33AEF3"]];
        _focusButton.layer.cornerRadius = pixelValue(8);
        _focusButton.layer.masksToBounds = YES;
        _focusButton.titleLabel.font = [UIFont systemFontOfSize:pixelValue(28)];
    }
    return _focusButton;
}
//第一张图
-(UIImageView *)firstImagView{
    if(!_firstImagView){
        _firstImagView = [[UIImageView alloc]init];
        _firstImagView.image = [UIImage imageNamed:@"矩形 211"];
    }
    return _firstImagView;
}
//第二张图
-(UIImageView *)secondImagView{
    if(!_secondImagView){
        _secondImagView = [[UIImageView alloc]init];
        _secondImagView.image = [UIImage imageNamed:@"矩形 211"];
    }
    return _secondImagView;
}
//第三张图
-(UIImageView *)thirdImagView{
    if(!_thirdImagView){
        _thirdImagView = [[UIImageView alloc]init];
        _thirdImagView.image = [UIImage imageNamed:@"矩形 211"];
    }
    return _thirdImagView;
}
//第四张图
-(UIImageView *)fourthImagView{
    if(!_fourthImagView){
        _fourthImagView = [[UIImageView alloc]init];
        _fourthImagView.image = [UIImage imageNamed:@"矩形 211"];
    }
    return _fourthImagView;
}

-(UIView *)lineView{
    if(!_lineView){
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    }
    return _lineView;
}

@end
