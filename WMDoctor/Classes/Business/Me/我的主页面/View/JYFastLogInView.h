//
//  JYFastLogInView.h
//  WMDoctor
//
//  Created by jiangqi on 2018/7/5.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYFastLogInView : UIView

@property(nonatomic,strong)UIImageView *phoneNumberImageView;//手机号图片

@property(nonatomic,strong)PPTextfield *phoneNumberTextField;//手机号输入框

@property(nonatomic,strong)UIImageView *codeImageView;//验证码图片

@property(nonatomic,strong)UITextField *codeTextField;//验证码输入框

@property(nonatomic,strong)UIButton *getCodeBtn;//获取验证码按钮

@property (nonatomic, strong) UILabel *warringLabel;//说明label

@property(nonatomic,strong)UIButton *loginBtn;//登录按钮

@end
