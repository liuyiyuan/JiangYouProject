//
//  JYLoginCodeView.h
//  WMDoctor
//
//  Created by jiangqi on 2018/9/3.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYLoginCodeView : UIView

@property (nonatomic, strong) UIView *whiteBackView;//白色背景

@property (nonatomic, strong) UILabel *inPutLabel;//请输入图形验证码

@property (nonatomic, strong) UIView *lineView;//线

@property (nonatomic, strong) UIImageView *codeImageView;//图形验证码

@property (nonatomic, strong) UITextField *codeTextField;//输入框

@property (nonatomic, strong) UILabel *clickRefresh;//点击刷新

@property (nonatomic, strong) UIButton *cancelButton;//取消按钮

@property (nonatomic, strong) UIButton *doneButton;//确定按钮

@end
