//
//  JYLoninView.m
//  WMDoctor
//
//  Created by jiangqi on 2018/7/5.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYLoninView.h"

@implementation JYLoninView


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
        [self configUI];
    }
    return self;
}

- (void)configUI {
    [self addSubview:self.iconImageView];
    [self addSubview:self.phoneNumberImageView];
    [self addSubview:self.phoneNumberTextField];
    [self addSubview:self.passWordImageViwe];
    [self addSubview:self.passWordTextField];
    [self addSubview:self.loginButton];
    [self addSubview:self.forgetPassWordButton];
    [self addSubview:self.firstLoginButton];
    [self addSubview:self.smsFastLoginButton];
    [self addSubview:self.weChatButton];
    [self addSubview:self.qqButton];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.width.mas_equalTo(pixelValue(285));
        make.height.mas_equalTo(pixelValue(177));
        make.top.mas_equalTo(pixelValue(80));
    }];
    
    [self.phoneNumberImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(pixelValue(60));
        make.top.mas_equalTo(self.iconImageView.mas_bottom).offset(pixelValue(80));
        make.width.mas_equalTo(pixelValue(30));
        make.height.mas_equalTo(pixelValue(40));
    }];
    
    [self.phoneNumberTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.phoneNumberImageView.mas_right).offset(pixelValue(pixelValue(40)));
        make.right.mas_equalTo(self.mas_right).offset(-pixelValue(60));
        make.height.mas_equalTo(pixelValue(80));
        make.top.mas_equalTo(self.phoneNumberImageView.mas_top).offset(-pixelValue(20));
    }];
    
    [self.passWordImageViwe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.phoneNumberImageView.mas_left);
        make.top.mas_equalTo(self.phoneNumberImageView.mas_bottom).offset(pixelValue(80));
        make.width.mas_equalTo(pixelValue(30));
        make.height.mas_equalTo(pixelValue(40));
    }];
    
    [self.passWordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.phoneNumberTextField.mas_left);
        make.right.mas_equalTo(self.phoneNumberTextField.mas_right);
        make.top.mas_equalTo(self.phoneNumberTextField.mas_bottom).offset(pixelValue(40));
        make.height.mas_equalTo(pixelValue(80));
    }];
    
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(pixelValue(60));
        make.top.mas_equalTo(self.passWordTextField.mas_bottom).offset(pixelValue(100));
        make.right.mas_equalTo(-pixelValue(60));
        make.height.mas_equalTo(pixelValue(88));
    }];
    
    [self.forgetPassWordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.loginButton.mas_left);
        make.top.mas_equalTo(self.loginButton.mas_bottom).offset(pixelValue(80));
        make.height.mas_equalTo(pixelValue(60));
    }];
    
    [self.firstLoginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.forgetPassWordButton.mas_top);
        make.height.mas_equalTo(self.forgetPassWordButton.mas_height);
    }];
    
    [self.smsFastLoginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.loginButton.mas_right);
        make.top.mas_equalTo(self.firstLoginButton.mas_top);
        make.height.mas_equalTo(self.firstLoginButton.mas_height);
    }];
    
    [self.weChatButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(pixelValue(120));
        make.bottom.mas_equalTo(self.mas_bottom).offset(-pixelValue(60));
        make.height.mas_equalTo(pixelValue(100));
    }];
    
    [self.qqButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-pixelValue(120));
        make.top.mas_equalTo(self.weChatButton.mas_top);
        make.height.mas_equalTo(self.weChatButton.mas_height);
    }];
    
}

//icon
-(UIImageView *)iconImageView{
    if(!_iconImageView){
        _iconImageView = [[UIImageView alloc]init];
        _iconImageView.image = [UIImage imageNamed:@"login_icon"];
    }
    return _iconImageView;
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
-(UITextField *)phoneNumberTextField{
    if(!_phoneNumberTextField){
        _phoneNumberTextField = [[UITextField alloc]init];
        _phoneNumberTextField.backgroundColor = [UIColor whiteColor];
        _phoneNumberTextField.placeholder = @"  手机号或用户名";
    }
    return _phoneNumberTextField;
}
//密码图片
-(UIImageView *)passWordImageViwe{
    if(!_passWordImageViwe){
        _passWordImageViwe = [[UIImageView alloc]init];
        _passWordImageViwe.image = [UIImage imageNamed:@"login_lock"];
    }
    return _passWordImageViwe;
}
//密码输入框
-(UITextField *)passWordTextField{
    if(!_passWordTextField){
        _passWordTextField = [[UITextField alloc]init];
        _passWordTextField.backgroundColor = [UIColor whiteColor];
        _passWordTextField.placeholder = @"  密码";
        _passWordTextField.secureTextEntry = YES;
        UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, pixelValue(80), pixelValue(80))];
        _eyeButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, pixelValue(80), pixelValue(80))];
        [_eyeButton setImage:[UIImage imageNamed:@"login_close_eye"] forState:UIControlStateNormal];
        [rightView addSubview:_eyeButton];
        _passWordTextField.rightView = rightView;
        _passWordTextField.rightViewMode = UITextFieldViewModeAlways;
    }
    return _passWordTextField;
}
//登录按钮
-(UIButton *)loginButton{
    if(!_loginButton){
        _loginButton = [[UIButton alloc]init];
        [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
        [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_loginButton setBackgroundColor:[UIColor colorWithHexString:@"#138CFF"]];
    }
    return _loginButton;
}
//忘记密码按钮
-(UIButton *)forgetPassWordButton{
    if(!_forgetPassWordButton){
        _forgetPassWordButton = [[UIButton alloc]init];
        [_forgetPassWordButton setTitle:@"忘记密码" forState:UIControlStateNormal];
        [_forgetPassWordButton setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        _forgetPassWordButton.titleLabel.font = [UIFont systemFontOfSize:pixelValue(26)];
    }
    return _forgetPassWordButton;
}
//首次登录按钮
-(UIButton *)firstLoginButton{
    if(!_firstLoginButton){
        _firstLoginButton = [[UIButton alloc]init];
        [_firstLoginButton setTitle:@"首次登录" forState:UIControlStateNormal];
        [_firstLoginButton setTitleColor:[UIColor colorWithHexString:@"#138CFF"] forState:UIControlStateNormal];
        _smsFastLoginButton.titleLabel.font = [UIFont systemFontOfSize:pixelValue(28)];
    }
    return _firstLoginButton;
}
//短信快捷登录按钮
-(UIButton *)smsFastLoginButton{
    if(!_smsFastLoginButton){
        _smsFastLoginButton = [[UIButton alloc]init];
        [_smsFastLoginButton setTitle:@"短信快捷登录" forState:UIControlStateNormal];
        [_smsFastLoginButton setTitleColor:[UIColor colorWithHexString:@"#138CFF"] forState:UIControlStateNormal];
        _smsFastLoginButton.titleLabel.font = [UIFont systemFontOfSize:pixelValue(26)];
    }
    return _smsFastLoginButton;
}
//微信按钮
-(UIButton *)weChatButton{
    if(!_weChatButton){
        _weChatButton = [[UIButton alloc]init];
        [_weChatButton setImage:[UIImage imageNamed:@"login_wechat"] forState:UIControlStateNormal];
        [_weChatButton setTitle:@" 微信登录" forState:UIControlStateNormal];
        [_weChatButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _weChatButton.titleLabel.font = [UIFont systemFontOfSize:pixelValue(32)];
    }
    return _weChatButton;
}
//qq按钮
-(UIButton *)qqButton{
    if(!_qqButton){
        _qqButton = [[UIButton alloc]init];
        [_qqButton setImage:[UIImage imageNamed:@"login_qq"] forState:UIControlStateNormal];
        [_qqButton setTitle:@" qq登录" forState:UIControlStateNormal];
        [_qqButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _qqButton.titleLabel.font = [UIFont systemFontOfSize:pixelValue(32)];
    }
    return _qqButton;
}

@end
