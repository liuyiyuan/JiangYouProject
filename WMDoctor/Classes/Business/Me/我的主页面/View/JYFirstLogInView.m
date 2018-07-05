//
//  JYFindPassWordView.m
//  WMDoctor
//
//  Created by zhenYan on 2018/7/1.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYFirstLogInView.h"

@implementation JYFirstLogInView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
        [self configUI];
    }
    return self;
}

- (void)configUI {
    [self addSubview:self.phoneNumberImageView];
    [self addSubview:self.phoneNumberLabel];
    [self addSubview:self.codeImageView];
    [self addSubview:self.codeTextField];
    [self addSubview:self.passWordImageView];
    [self addSubview:self.passWordTextField];
    [self addSubview:self.loginBtn];
    
    [self.phoneNumberImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(pixelValue(50));
        make.left.mas_equalTo(pixelValue(40));
        make.width.height.mas_equalTo(pixelValue(40));
    }];
    
    [self.phoneNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.phoneNumberImageView.mas_right).offset(pixelValue(30));
        make.right.mas_equalTo(-pixelValue(70));
        make.height.mas_equalTo(pixelValue(80));
        make.top.mas_equalTo(self.phoneNumberImageView.mas_top).offset(-pixelValue(20));
    }];
    
    [self.codeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.phoneNumberImageView.mas_left);
        make.top.mas_equalTo(self.phoneNumberImageView.mas_bottom).offset(pixelValue(80));
        make.width.mas_equalTo(pixelValue(40));
        make.height.mas_equalTo(pixelValue(40));
    }];
    

    
    [self.codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.codeImageView.mas_top).offset(-pixelValue(20));
        make.left.mas_equalTo(self.codeImageView.mas_right).offset(pixelValue(30));
        make.height.mas_equalTo(pixelValue(80));
        make.right.mas_equalTo(self.phoneNumberLabel.mas_right);
    }];
    
    
    
    [self.passWordImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.codeImageView.mas_bottom).offset(pixelValue(80));
        make.left.mas_equalTo(self.codeImageView.mas_left);
        make.width.mas_equalTo(pixelValue(40));
        make.height.mas_equalTo(pixelValue(40));
    }];
    
    [self.passWordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.phoneNumberLabel.mas_left);
        make.top.mas_equalTo(self.passWordImageView.mas_top).offset(-pixelValue(20));
        make.right.mas_equalTo(self.phoneNumberLabel.mas_right);
        make.height.mas_equalTo(self.codeTextField.mas_height);
    }];
    
    
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(pixelValue(70));
        make.top.mas_equalTo(self.passWordTextField.mas_bottom).offset(pixelValue(80));
        make.right.mas_equalTo(-pixelValue(70));
        make.height.mas_equalTo(pixelValue(88));
    }];
}

//手机号图片
-(UIImageView *)phoneNumberImageView{
    if(!_phoneNumberImageView){
        _phoneNumberImageView = [[UIImageView alloc]init];
        _phoneNumberImageView.image = [UIImage imageNamed:@"login_people"];
    }
    return _phoneNumberImageView;
}

//手机号输入框
-(UILabel *)phoneNumberLabel{
    if(!_phoneNumberLabel){
        _phoneNumberLabel = [[UILabel alloc]init];
        _phoneNumberLabel.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
        _phoneNumberLabel.textColor = [UIColor blackColor];
        _phoneNumberLabel.text = @"151 4555 5390";

    }
    return _phoneNumberLabel;
}
//验证码图片
-(UIImageView *)codeImageView{
    if(!_codeImageView){
        _codeImageView = [[UIImageView alloc]init];
        _codeImageView.image = [UIImage imageNamed:@"login_lock"];
        
    }
    return _codeImageView;
}
//验证码输入框
-(PPTextfield *)codeTextField{
    if(!_codeTextField){
        _codeTextField = [[PPTextfield alloc]init];
        _codeTextField.backgroundColor = [UIColor whiteColor];
        _codeTextField.placeholder = @"  输入密码";
        _codeTextField.isOnlyNumber = YES;
        _codeTextField.maxNumberCount = 6;
    }
    return _codeTextField;
}

//密码图片
-(UIImageView *)passWordImageView{
    if(!_passWordImageView){
        _passWordImageView = [[UIImageView alloc]init];
        _passWordImageView.image = [UIImage imageNamed:@"login_lock"];
    }
    return _passWordImageView;
}
//密码输入框
-(UITextField *)passWordTextField{
    if(!_passWordTextField){
        _passWordTextField = [[UITextField alloc]init];
        _passWordTextField.backgroundColor = [UIColor whiteColor];
        _passWordTextField.placeholder = @"  确认密码";
        
        _passWordTextField.keyboardType = UIKeyboardTypeDefault;
    }
    return _passWordTextField;
}
//登录按钮
-(UIButton *)loginBtn{
    if(!_loginBtn){
        _loginBtn = [[UIButton alloc]init];
        [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_loginBtn setBackgroundColor:[UIColor colorWithHexString:@"#138CFF"]];
    }
    return _loginBtn;
}
@end
