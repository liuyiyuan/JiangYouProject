//
//  JYHomeNewsHeaderView.m
//  WMDoctor
//
//  Created by zhenYan on 2018/9/1.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYHomeNewsHeaderView.h"

@implementation JYHomeNewsHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor colorWithHexString:@"#EBEBEB"];
        [self configUI];
    }
    return self;
}

-(void)configUI{
    [self addSubview:self.whiteView];
    [self.whiteView addSubview:self.searchImageView];
    [self.whiteView addSubview:self.textField];
    [self addSubview:self.searchButton];
    
    [self.searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-pixelValue(30));
        make.height.mas_equalTo(pixelValue(60));
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    
    [self.whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(pixelValue(30));
        make.centerY.mas_equalTo(self.centerY);
        make.right.mas_equalTo(self.searchButton.mas_left).offset(-pixelValue(30));
        make.height.mas_equalTo(pixelValue(60));
    }];
    
    [self.searchImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(pixelValue(20));
        make.width.height.mas_equalTo(pixelValue(30));
        make.centerY.mas_equalTo(self.whiteView.mas_centerY);
    }];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.searchImageView.mas_right).offset(pixelValue(20));
        make.right.mas_equalTo(-pixelValue(20));
        make.height.mas_equalTo(pixelValue(60));
        make.centerY.mas_equalTo(self.searchImageView.mas_centerY);
    }];
    
    
}
//白色背景
-(UIView *)whiteView{
    if(!_whiteView){
        _whiteView = [[UIView alloc]init];
        _whiteView.backgroundColor = [UIColor whiteColor];
        _whiteView.layer.cornerRadius = pixelValue(30);
        _whiteView.layer.masksToBounds = YES;
    }
    return _whiteView;
}
//放大镜
-(UIImageView *)searchImageView{
    if(!_searchImageView){
        _searchImageView = [[UIImageView alloc]init];
        _searchImageView.image = [UIImage imageNamed:@"Search"];
    }
    return _searchImageView;
}
//搜索框
-(UITextField *)textField{
    if(!_textField){
        _textField = [[UITextField alloc]init];
        _textField.placeholder = @"输入关键字";
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _textField;
}

//搜索按钮
-(UIButton *)searchButton{
    if(!_searchButton){
        _searchButton = [[UIButton alloc]init];
        [_searchButton setTitle:@"搜索" forState:UIControlStateNormal];
        [_searchButton setTitleColor:[UIColor colorWithHexString:@"#A7A6A6"] forState:UIControlStateNormal];
        _searchButton.titleLabel.font = [UIFont systemFontOfSize:pixelValue(26)];
    }
    return _searchButton;
   
    
}

@end
