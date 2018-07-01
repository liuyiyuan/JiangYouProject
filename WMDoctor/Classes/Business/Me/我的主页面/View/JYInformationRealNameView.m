//
//  JYInformationRealNameView.m
//  WMDoctor
//
//  Created by zhenYan on 2018/6/30.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYInformationRealNameView.h"

@implementation JYInformationRealNameView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor whiteColor];
        [self configUI];
    }
    return self;
}

- (void)configUI {
    [self addSubview:self.doneLabel];
    [self addSubview:self.realNameLabel];
    [self addSubview:self.lineView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.nameTextField];
    [self addSubview:self.idNumberLabel];
    [self addSubview:self.idNumberTextField];
    [self addSubview:self.industryLabel];
    [self addSubview:self.buttonArrayView];
    [self addSubview:self.workTextFidle];
    [self addSubview:self.secondLineView];
    [self.doneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(pixelValue(20));
        make.left.mas_equalTo(pixelValue(20));
        make.height.mas_equalTo(pixelValue(30));
    }];
    
    [self.realNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-pixelValue(20));
        make.top.mas_equalTo(self.doneLabel.mas_top);
        make.height.mas_equalTo(self.doneLabel.mas_height);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(pixelValue(20));
        make.right.mas_equalTo(-pixelValue(20));
        make.top.mas_equalTo(self.doneLabel.mas_bottom).offset(pixelValue(20));
        make.height.mas_equalTo(pixelValue(4));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(pixelValue(20));
        make.top.mas_equalTo(self.lineView.mas_bottom).offset(pixelValue(30));
        make.height.mas_equalTo(pixelValue(80));
        make.width.mas_equalTo(pixelValue(120));
    }];
    
    [self.nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLabel.mas_top);
        make.left.mas_equalTo(self.nameLabel.mas_right).offset(pixelValue(30));
        make.height.mas_equalTo(self.nameLabel.mas_height);
        make.right.mas_equalTo(-pixelValue(40));
    }];
    
    [self.idNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel.mas_left);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(pixelValue(30));
        make.height.mas_equalTo(self.nameLabel.mas_height);
    }];
    
    [self.idNumberTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.idNumberLabel.mas_top);
        make.left.mas_equalTo(self.nameTextField.mas_left);
        make.height.mas_equalTo(self.nameTextField.mas_height);
        make.right.mas_equalTo(self.nameTextField.mas_right);
    }];
    
    [self.industryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.idNumberLabel.mas_left);
        make.top.mas_equalTo(self.idNumberLabel.mas_bottom).offset(pixelValue(30));
        make.height.mas_equalTo(self.idNumberLabel.mas_height);
    }];
    
    
    [self.buttonArrayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.industryLabel.mas_top);
        make.left.mas_equalTo(self.idNumberTextField.mas_left);
        make.right.mas_equalTo(self.idNumberTextField.mas_right);
        make.height.mas_equalTo(pixelValue(160));
    }];
   
    [self.workTextFidle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.idNumberTextField.mas_left);
        make.top.mas_equalTo(self.buttonArrayView.mas_bottom).offset(pixelValue(30));
        make.right.mas_equalTo(self.idNumberTextField.mas_right);
        make.height.mas_equalTo(self.idNumberTextField.mas_height);
    }];
    
    [self.secondLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.lineView.mas_left);
        make.right.mas_equalTo(self.lineView.mas_right);
        make.height.mas_equalTo(pixelValue(4));
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
}

-(UILabel *)doneLabel{
    if(!_doneLabel){
        _doneLabel = [[UILabel alloc]init];
        _doneLabel.text = @"完成实名认证获得更多红利";
        _doneLabel.textColor = [UIColor blackColor];
        _doneLabel.font = [UIFont systemFontOfSize:pixelValue(32)];
    }
    return _doneLabel;
}

-(UILabel *)realNameLabel{
    if(!_realNameLabel){
        _realNameLabel = [[UILabel alloc]init];
        _realNameLabel.textColor = [UIColor colorWithHexString:@"#5AC862"];
        _realNameLabel.text = @"实名认证";
        _realNameLabel.font = [UIFont systemFontOfSize:pixelValue(32)];
    }
    return _realNameLabel;
}

-(UIView *)lineView{
    if(!_lineView){
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
    }
    return _lineView;
}

-(UILabel *)nameLabel{
    if(!_nameLabel){
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.text = @"姓名:";
        _nameLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _nameLabel.font = [UIFont systemFontOfSize:pixelValue(30)];
        _nameLabel.textAlignment = NSTextAlignmentRight;
    }
    return _nameLabel;
}

-(UITextField *)nameTextField{
    if(!_nameTextField){
        _nameTextField = [[UITextField alloc]init];
        _nameTextField.layer.borderColor = [UIColor colorWithHexString:@"#666666"].CGColor;
        _nameTextField.layer.borderWidth = pixelValue(1);
    }
    return _nameTextField;
}

-(UILabel *)idNumberLabel{
    if(!_idNumberLabel){
        _idNumberLabel = [[UILabel alloc]init];
        _idNumberLabel.text = @"身份证号:";
        _idNumberLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _idNumberLabel.font = [UIFont systemFontOfSize:pixelValue(30)];
        _idNumberLabel.textAlignment = NSTextAlignmentRight;
    }
    return _idNumberLabel;
    
}

-(UITextField *)idNumberTextField{
    if(!_idNumberTextField){
        _idNumberTextField = [[UITextField alloc]init];
        _idNumberTextField.layer.borderColor = [UIColor colorWithHexString:@"#666666"].CGColor;
        _idNumberTextField.layer.borderWidth = pixelValue(1);
    }
    return _idNumberTextField;
}
-(UILabel *)industryLabel{
    if(!_industryLabel){
        _industryLabel = [[UILabel alloc]init];
        _industryLabel.text = @"从事行业:";
        _industryLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _industryLabel.font = [UIFont systemFontOfSize:pixelValue(30)];
        _industryLabel.textAlignment = NSTextAlignmentRight;
    }
    return _industryLabel;
}


-(JYInformationButtonArrayView *)buttonArrayView{
    if(!_buttonArrayView){
        _buttonArrayView = [[JYInformationButtonArrayView alloc]init];
        _buttonArrayView.buttonTitlearray = @[@" 软件产业",@" 服务业",@" 公务员",@" 广告业",@" 在校学生",@" 其他"];
        [_buttonArrayView configUI];
    }
    
    return _buttonArrayView;
}

-(UITextField *)workTextFidle{
    if(!_workTextFidle){
        _workTextFidle = [[UITextField alloc]init];
        _workTextFidle.hidden = YES;
        _workTextFidle.layer.borderColor = [UIColor colorWithHexString:@"#666666"].CGColor;
        _workTextFidle.layer.borderWidth = pixelValue(1);
        _workTextFidle.placeholder = @" 填入您的行业";
    }
    return _workTextFidle;
}

-(UIView *)secondLineView{
    if(!_secondLineView){
        _secondLineView = [[UIView alloc]init];
        _secondLineView.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
    }
    return _secondLineView;
}
@end
