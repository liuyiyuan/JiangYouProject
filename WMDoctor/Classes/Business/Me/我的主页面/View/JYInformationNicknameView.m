//
//  JYInformationNicknameView.m
//  WMDoctor
//
//  Created by zhenYan on 2018/6/30.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYInformationNicknameView.h"

@implementation JYInformationNicknameView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor whiteColor];
        [self configUI];
    }
    return self;
}

- (void)configUI {
    [self addSubview:self.nickNameLabel];
    [self addSubview:self.nickNameTextField];
    [self addSubview:self.genderLabel];
    [self addSubview:self.manButton];
    [self addSubview:self.womanButton];
    [self addSubview:self.IntroductionLabel];
    [self addSubview:self.IntroductionTextView];
    
    [self.nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(pixelValue(80));
        make.top.mas_equalTo(pixelValue(40));
        make.height.mas_equalTo(pixelValue(80));
        make.width.mas_equalTo(pixelValue(70));
    }];
    
    
    [self.nickNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nickNameLabel.mas_top);
        make.left.mas_equalTo(self.nickNameLabel.mas_right).offset(pixelValue(30));
        make.height.mas_equalTo(self.nickNameLabel.mas_height);
        make.right.mas_equalTo(-pixelValue(40));
    }];
    
    [self.genderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nickNameLabel.mas_left);
        make.top.mas_equalTo(self.nickNameLabel.mas_bottom).offset(pixelValue(20));
        make.height.mas_equalTo(self.nickNameLabel.mas_height);
    }];
    
    [self.manButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.genderLabel.mas_right).offset(pixelValue(30));
        make.top.mas_equalTo(self.genderLabel.mas_top);
        make.height.mas_equalTo(self.genderLabel.mas_height);
    }];
    
    [self.womanButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.manButton.mas_right).offset(pixelValue(30));
        make.top.mas_equalTo(self.manButton.mas_top);
        make.height.mas_equalTo(self.manButton.mas_height);
    }];
    
    [self.IntroductionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.genderLabel.mas_bottom).offset(pixelValue(20));
        make.left.mas_equalTo(self.genderLabel.mas_left);
        make.height.mas_equalTo(self.genderLabel.mas_height);
    }];
    
    [self.IntroductionTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.IntroductionLabel.mas_right).offset(pixelValue(30));
        make.top.mas_equalTo(self.IntroductionLabel.mas_top);
        make.right.mas_equalTo(-pixelValue(40));
        make.height.mas_equalTo(pixelValue(pixelValue(400)));
    }];
    
}

-(UILabel *)nickNameLabel{
    if(!_nickNameLabel){
        _nickNameLabel = [[UILabel alloc]init];
        _nickNameLabel.text = @"昵称:";
        _nickNameLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _nickNameLabel.font = [UIFont systemFontOfSize:pixelValue(30)];
    }
    return _nickNameLabel;
}

-(UITextField *)nickNameTextField{
    if(!_nickNameTextField){
        _nickNameTextField = [[UITextField alloc]init];
        _nickNameTextField.layer.borderColor = [UIColor colorWithHexString:@"#666666"].CGColor;
        _nickNameTextField.layer.borderWidth = pixelValue(1);
    }
    return _nickNameTextField;
}

-(UILabel *)genderLabel{
    if(!_genderLabel){
        _genderLabel = [[UILabel alloc]init];
        _genderLabel.text = @"性别:";
        _genderLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _genderLabel.font = [UIFont systemFontOfSize:pixelValue(30)];
    }
    return _genderLabel;
}

-(UIButton *)manButton{
    if(!_manButton){
        _manButton = [[UIButton alloc]init];
        [_manButton setTitle:@" 男" forState:UIControlStateNormal];
        [_manButton setImage:[UIImage imageNamed:@"information_btn_normal"] forState:UIControlStateNormal];
        [_manButton setImage:[UIImage imageNamed:@"information_btn_selected"] forState:UIControlStateSelected];
        _manButton.titleLabel.font = [UIFont systemFontOfSize:pixelValue(28)];
        [_manButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _manButton.selected = YES;
        [_manButton addTarget:self action:@selector(click_manButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _manButton;
}

-(UIButton *)womanButton{
    if(!_womanButton){
        _womanButton = [[UIButton alloc]init];
        [_womanButton setTitle:@" 女" forState:UIControlStateNormal];
        [_womanButton setImage:[UIImage imageNamed:@"information_btn_normal"] forState:UIControlStateNormal];
        [_womanButton setImage:[UIImage imageNamed:@"information_btn_selected"] forState:UIControlStateSelected];
        _womanButton.titleLabel.font = [UIFont systemFontOfSize:pixelValue(30)];
        [_womanButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _womanButton.selected = NO;
        [_womanButton addTarget:self action:@selector(click_womanButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _womanButton;
}

-(UILabel *)IntroductionLabel{
    if(!_IntroductionLabel){
        _IntroductionLabel = [[UILabel alloc]init];
        _IntroductionLabel.text = @"简介:";
        _IntroductionLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _IntroductionLabel.font = [UIFont systemFontOfSize:pixelValue(30)];
    }
    return _IntroductionLabel;
}

-(UITextView *)IntroductionTextView{
    if(!_IntroductionTextView){
        _IntroductionTextView = [[UITextView alloc]init];
        _IntroductionTextView.layer.borderColor = [UIColor colorWithHexString:@"#666666"].CGColor;
        _IntroductionTextView.layer.borderWidth = pixelValue(1);
    }
    return _IntroductionTextView;
}

#pragma mark - 男点击
-(void)click_manButton:(UIButton *)btn{
    if(btn.selected == YES){
        return;
    }else{
        btn.selected = YES;
        self.womanButton.selected = NO;
        if([self.delegate respondsToSelector:@selector(genderSelect:)]){
            [self.delegate genderSelect:1];
        }
    }

   
    
}
#pragma mark - 女点击
-(void)click_womanButton:(UIButton *)btn{
    if(btn.selected == YES){
        return;
    }else{
        btn.selected = YES;
        self.manButton.selected = NO;
        if([self.delegate respondsToSelector:@selector(genderSelect:)]){
            [self.delegate genderSelect:2];
        }
    }

   
    
}

@end
