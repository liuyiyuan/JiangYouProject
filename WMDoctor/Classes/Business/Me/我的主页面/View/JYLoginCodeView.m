//
//  JYLoginCodeView.m
//  WMDoctor
//
//  Created by jiangqi on 2018/9/3.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYLoginCodeView.h"

@implementation JYLoginCodeView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self configUI];
    }
    return self;
}

-(void)configUI{
    [self addSubview:self.whiteBackView];
    
    [self.whiteBackView addSubview:self.inPutLabel];
    [self.whiteBackView addSubview:self.lineView];
    [self.whiteBackView addSubview:self.codeImageView];
    [self.whiteBackView addSubview:self.codeTextField];
    [self.whiteBackView addSubview:self.clickRefresh];
    [self.whiteBackView addSubview:self.cancelButton];
    [self.whiteBackView addSubview:self.doneButton];
    
    
    [self.whiteBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(pixelValue(490));
        make.height.mas_equalTo(pixelValue(300));
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    [self.inPutLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(pixelValue(15));
        make.left.mas_equalTo(pixelValue(0));
        make.right.mas_equalTo(pixelValue(0));
        make.height.mas_equalTo(pixelValue(30));
    }];
    
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.inPutLabel.mas_bottom).offset(pixelValue(15));
        make.left.mas_equalTo(pixelValue(0));
        make.right.mas_equalTo(pixelValue(0));
        make.height.mas_equalTo(pixelValue(2));
    }];
    
    [self.codeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.lineView.mas_bottom).offset(pixelValue(30));
        make.left.mas_equalTo(pixelValue(40));
        make.width.mas_equalTo(pixelValue(120));
        make.height.mas_equalTo(pixelValue(50));
    }];

    
    [self.codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.codeImageView.mas_top);
        make.left.mas_equalTo(self.codeImageView.mas_right).offset(pixelValue(20));
        make.height.mas_equalTo(self.codeImageView.mas_height);
        make.width.mas_equalTo(pixelValue(270));
    }];
    
    [self.clickRefresh mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.codeImageView.mas_left);
        make.top.mas_equalTo(self.codeImageView.mas_bottom);
        make.height.mas_equalTo(pixelValue(20));
    }];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.clickRefresh.mas_bottom).offset(pixelValue(30));
        make.left.mas_equalTo(pixelValue(90));
        make.width.mas_equalTo(pixelValue(140));
        make.height.mas_equalTo(pixelValue(60));
    }];
    
    [self.doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.cancelButton.mas_top);
        make.left.mas_equalTo(self.cancelButton.mas_right).offset(pixelValue(30));
        make.width.mas_equalTo(self.cancelButton.mas_width);
        make.height.mas_equalTo(self.cancelButton.mas_height);
    }];
    
    
}
//白色背景
-(UIView *)whiteBackView{
    if(!_whiteBackView){
        _whiteBackView = [[UIView alloc]init];
        _whiteBackView.backgroundColor = [UIColor whiteColor];
    }
    return _whiteBackView;
}
//请输入图形验证码
-(UILabel *)inPutLabel{
    if(!_inPutLabel){
        _inPutLabel = [[UILabel alloc]init];
        _inPutLabel.text = @"请输入图形验证码";
        _inPutLabel.textColor = [UIColor blackColor];
        _inPutLabel.font = [UIFont systemFontOfSize:pixelValue(28)];
        _inPutLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _inPutLabel;
}
//线
-(UIView *)lineView{
    if(!_lineView){
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"#F3F3F3"];
    }
    return _lineView;
}
//图形验证码
-(UIImageView *)codeImageView{
    if(!_codeImageView){
        _codeImageView = [[UIImageView alloc]init];
        _codeImageView.userInteractionEnabled = YES;
    }
    return _codeImageView;
}
//输入框
-(UITextField *)codeTextField{
    if(!_codeTextField){
        _codeTextField = [[UITextField alloc]init];
        _codeTextField.layer.borderColor = [UIColor colorWithHexString:@"#F3F3F3"].CGColor;
        _codeTextField.layer.borderWidth = pixelValue(2);
    }
    return _codeTextField;
}
//点击刷新
-(UILabel *)clickRefresh{
    if(!_clickRefresh){
        _clickRefresh = [[UILabel alloc]init];
        _clickRefresh.text = @"点击刷新";
        _clickRefresh.textColor = [UIColor lightGrayColor];
        _clickRefresh.font = [UIFont systemFontOfSize:pixelValue(24)];
    }
    return _clickRefresh;
}
//取消按钮
-(UIButton *)cancelButton{
    if(!_cancelButton){
        _cancelButton = [[UIButton alloc]init];
        [_cancelButton setBackgroundColor:[UIColor colorWithHexString:@"#C2C3C3"]];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:pixelValue(24)];
    }
    return _cancelButton;
}
//确定按钮
-(UIButton *)doneButton{
    if(!_doneButton){
        _doneButton = [[UIButton alloc]init];
        [_doneButton setBackgroundColor:[UIColor colorWithHexString:@"#4DA9FF"]];
        [_doneButton setTitle:@"确定" forState:UIControlStateNormal];
        [_doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _doneButton.titleLabel.font = [UIFont systemFontOfSize:pixelValue(24)];
    }
       return _doneButton;
}

@end
