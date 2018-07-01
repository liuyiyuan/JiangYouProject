//
//  JYInformationInComeView.m
//  WMDoctor
//
//  Created by zhenYan on 2018/7/1.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYInformationInComeView.h"

@implementation JYInformationInComeView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor whiteColor];
        [self configUI];
    }
    return self;
}

- (void)configUI {
    [self addSubview:self.inComeLabel];
    [self addSubview:self.buttonArrayView];
    [self addSubview:self.inComeTextField];
    
    [self.inComeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(pixelValue(20));
        make.top.mas_equalTo(pixelValue(30));
        make.height.mas_equalTo(pixelValue(80));
        make.width.mas_equalTo(pixelValue(120));
    }];
    
    [self.buttonArrayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.inComeLabel.mas_top);
        make.left.mas_equalTo(self.inComeLabel.mas_right).offset(pixelValue(30));
        make.right.mas_equalTo(-pixelValue(40));
        make.height.mas_equalTo(pixelValue(160));
    }];
    
    [self.inComeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.buttonArrayView.mas_left);
        make.top.mas_equalTo(self.buttonArrayView.mas_bottom).offset(pixelValue(30));
        make.right.mas_equalTo(self.buttonArrayView.mas_right);
        make.height.mas_equalTo(pixelValue(80));
    }];
}

-(UILabel *)inComeLabel{
    if(!_inComeLabel){
        _inComeLabel = [[UILabel alloc]init];
        _inComeLabel.text = @"年收入:";
        _inComeLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _inComeLabel.font = [UIFont systemFontOfSize:pixelValue(30)];
        _inComeLabel.textAlignment = NSTextAlignmentRight;
    }
    return _inComeLabel;
}

-(JYInformationButtonArrayView *)buttonArrayView{
    if(!_buttonArrayView){
        _buttonArrayView = [[JYInformationButtonArrayView alloc]init];
        _buttonArrayView.buttonTitlearray = @[@" 3W一下",@" 3w-5W",@" 5W-10W",@" 10W-20W",@" 20W以上",@" 其他"];
        [_buttonArrayView configUI];
    }
    return _buttonArrayView;
    
}

-(UITextField *)inComeTextField{
    if(!_inComeTextField){
        _inComeTextField = [[UITextField alloc]init];
        _inComeTextField.hidden = YES;
        _inComeTextField.layer.borderColor = [UIColor colorWithHexString:@"#666666"].CGColor;
        _inComeTextField.layer.borderWidth = pixelValue(1);
        _inComeTextField.placeholder = @" 填入您的年收入金额";
    }
    return _inComeTextField;
}



@end
