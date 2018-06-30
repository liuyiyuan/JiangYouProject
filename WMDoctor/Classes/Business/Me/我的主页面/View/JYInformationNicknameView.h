//
//  JYInformationNicknameView.h
//  WMDoctor
//
//  Created by zhenYan on 2018/6/30.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYInformationNicknameView : UIView

@property(nonatomic,strong)UILabel *nickNameLabel;//昵称

@property(nonatomic,strong)UITextField *nickNameTextField;//昵称输入框

@property(nonatomic,strong)UILabel *genderLabel;//性别

@property(nonatomic,strong)UIButton *manButton;//男

@property(nonatomic,strong)UIButton *womanButton;//女

@property(nonatomic,strong)UILabel *IntroductionLabel;//简介

@property(nonatomic,strong)UITextView *IntroductionTextView;//简介输入框

@end
