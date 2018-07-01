//
//  JYFindPassWordView.h
//  WMDoctor
//
//  Created by zhenYan on 2018/7/1.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYFindPassWordView : UIView

@property(nonatomic,strong)UIImageView *phoneNumberImageView;//手机号图片

@property(nonatomic,strong)PPTextfield *phoneNumberTextField;//手机号输入框

@property(nonatomic,strong)UIImageView *codeImageView;//验证码图片

@property(nonatomic,strong)PPTextfield *codeTextField;//验证码输入框

@property(nonatomic,strong)UIButton *getCodeBtn;//获取验证码按钮

@property(nonatomic,strong)UIImageView *passWordImageView;//密码图片

@property(nonatomic,strong)UITextField *passWordTextField;//密码输入框

@property(nonatomic,strong)UIButton *loginBtn;//登录按钮

@end
