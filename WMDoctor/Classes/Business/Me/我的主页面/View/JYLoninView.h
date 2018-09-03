//
//  JYLoninView.h
//  WMDoctor
//
//  Created by jiangqi on 2018/7/5.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYLoninView : UIView

@property (nonatomic, strong) UIImageView *iconImageView;//icon

@property (nonatomic, strong) UIImageView *phoneNumberImageView;//手机号图片

@property (nonatomic, strong) UITextField *phoneNumberTextField;//手机号输入框

@property (nonatomic, strong) UIImageView *passWordImageViwe;//密码图片

@property (nonatomic, strong) UITextField *passWordTextField;//密码输入框

@property (nonatomic, strong) UIButton *eyeButton;//眼睛

@property (nonatomic, strong) UIButton *loginButton;//登录按钮

@property (nonatomic, strong) UIButton *forgetPassWordButton;//忘记密码按钮

//@property (nonatomic, strong) UIButton *firstLoginButton;//首次登录按钮

@property (nonatomic, strong) UIButton *smsFastLoginButton;//短信快捷登录按钮

@property (nonatomic, strong) UIButton *weChatButton;//微信按钮

@property (nonatomic, strong) UIButton *qqButton;//qq按钮

@end
