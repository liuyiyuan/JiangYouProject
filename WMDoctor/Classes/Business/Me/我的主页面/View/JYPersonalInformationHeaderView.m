//
//  JYPersonalInformationHeaderView.m
//  WMDoctor
//
//  Created by jiangqi on 2018/6/27.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYPersonalInformationHeaderView.h"

@implementation JYPersonalInformationHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor whiteColor];
        [self configUI];
    }
    return self;
}

- (void)configUI {
//    [self addSubview:self.backView];
    [self addSubview:self.imageButton];
    [self addSubview:self.changeLabel];
    [self addSubview:self.lineView];
//    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.mas_equalTo(self.mas_centerX);
//        make.top.mas_equalTo(pixelValue(30));
//        make.width.height.mas_equalTo(82);
//    }];
    
    [self.imageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(pixelValue(30));
        make.width.height.mas_equalTo(82);
    }];
    
    [self.changeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.imageButton.mas_bottom).offset(pixelValue(30));
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(pixelValue(30));
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(pixelValue(0));
        make.height.mas_equalTo(pixelValue(4));
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
}


-(UIView *)backView{
    if(!_backView){
        _backView = [[UIView alloc]init];
        _backView.backgroundColor = [UIColor colorWithHexString:@"#D1D1D1"];
        _backView.layer.cornerRadius = 41;
        _backView.layer.masksToBounds = YES;
    }
    return _backView;
}
-(UIButton *)imageButton{
    if(!_imageButton){
        _imageButton = [[UIButton alloc]init];
        _imageButton.backgroundColor = [UIColor colorWithHexString:@"#D1D1D1"];
        [_imageButton setImage:[UIImage imageNamed:@"header_choose"] forState:UIControlStateNormal];
        _imageButton.layer.cornerRadius = 41;
        _imageButton.layer.masksToBounds = YES;
    }
    return _imageButton;
}

-(UILabel *)changeLabel{
    if(!_changeLabel){
        _changeLabel = [[UILabel alloc]init];
        _changeLabel.text = @"修改头像";
        _changeLabel.textColor = [UIColor blackColor];
        _changeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _changeLabel;
}

-(UIView *)lineView{
    if(!_lineView){
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    }
    return _lineView;
}
@end
