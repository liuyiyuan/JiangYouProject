//
//  JYFindPassWordView.m
//  WMDoctor
//
//  Created by zhenYan on 2018/7/1.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYFastLogInView.h"

@implementation JYFastLogInView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor whiteColor];
        [self configUI];
    }
    return self;
}

- (void)configUI {
    [self addSubview:self.phoneNumberImageView];
    [self addSubview:self.phoneNumberTextField];
    [self addSubview:self.codeImageView];
    [self addSubview:self.codeTextField];
    [self addSubview:self.getCodeBtn];
    [self addSubview:self.warringLabel];
    [self addSubview:self.loginBtn];
    
    [self.phoneNumberImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(pixelValue(50));
        make.left.mas_equalTo(pixelValue(40));
        make.width.height.mas_equalTo(pixelValue(40));
    }];
    
    [self.phoneNumberTextField mas_makeConstraints:^(MASConstraintMaker *make) {
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
    
    [self.getCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.codeImageView.mas_top).offset(-pixelValue(20));
        make.height.mas_equalTo(pixelValue(80));
        make.right.mas_equalTo(-pixelValue(70));
        make.width.mas_equalTo(pixelValue(200));
    }];
    
    [self.codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.getCodeBtn.mas_top);
        make.left.mas_equalTo(self.codeImageView.mas_right).offset(pixelValue(30));
        make.height.mas_equalTo(self.getCodeBtn.mas_height);
        make.right.mas_equalTo(self.getCodeBtn.mas_left).offset(-pixelValue(10));
    }];
    
    
    
    [self.warringLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.codeTextField.mas_left);
        make.top.mas_equalTo(self.codeTextField.mas_bottom).offset(pixelValue(10));
        make.height.mas_equalTo(pixelValue(30));
    }];

    
    
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(pixelValue(70));
        make.top.mas_equalTo(self.warringLabel.mas_bottom).offset(pixelValue(80));
        make.right.mas_equalTo(-pixelValue(70));
        make.height.mas_equalTo(pixelValue(88));
    }];
}

//手机号图片
-(UIImageView *)phoneNumberImageView{
    if(!_phoneNumberImageView){
        _phoneNumberImageView = [[UIImageView alloc]init];
        _phoneNumberImageView.image = [UIImage imageNamed:@"find_passWord_phone"];
    }
    return _phoneNumberImageView;
}

//手机号输入框
-(PPTextfield *)phoneNumberTextField{
    if(!_phoneNumberTextField){
        _phoneNumberTextField = [[PPTextfield alloc]init];
        _phoneNumberTextField.backgroundColor = [UIColor whiteColor];
        _phoneNumberTextField.placeholder = @"  您的手机号";
        _phoneNumberTextField.isOnlyNumber = YES;
        _phoneNumberTextField.maxNumberCount = 11;
    }
    return _phoneNumberTextField;
}
//验证码图片
-(UIImageView *)codeImageView{
    if(!_codeImageView){
        _codeImageView = [[UIImageView alloc]init];
        _codeImageView.image = [UIImage imageNamed:@"find_passWord_code"];
        
    }
    return _codeImageView;
}
//验证码输入框
-(UITextField *)codeTextField{
    if(!_codeTextField){
        _codeTextField = [[UITextField alloc]init];
        _codeTextField.backgroundColor = [UIColor whiteColor];
        _codeTextField.placeholder = @"  验证码";
    }
    return _codeTextField;
}
//获取验证码按钮
-(UIButton *)getCodeBtn{
    if(!_getCodeBtn){
        _getCodeBtn = [[UIButton alloc]init];
        [_getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_getCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_getCodeBtn setBackgroundColor:[UIColor colorWithHexString:@"#138CFF"]];
        _getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:pixelValue(26)];
    }
    return _getCodeBtn;
}

//密码输入框
-(UILabel *)warringLabel{
    if(!_warringLabel){
        _warringLabel = [[UILabel alloc]init];
        _warringLabel.textColor = [UIColor colorWithHexString:@"#615F5F"];
        _warringLabel.text = @"(用户使用条款)注册视为同意";
        _warringLabel.font = [UIFont systemFontOfSize:pixelValue(24)];
    }
    return _warringLabel;
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
