//
//  JYHomeSameCitySecondHeaderView.m
//  WMDoctor
//
//  Created by zhenYan on 2018/8/10.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYHomeSameCitySecondHeaderView.h"

@implementation JYHomeSameCitySecondHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self configUI];
    }
    return self;
}

-(void)configUI{

    
    [self addSubview:self.whiteView];
    [self.whiteView addSubview:self.blueView];
    [self.whiteView addSubview:self.hotLabel];
    [self.whiteView addSubview:self.lineView];
    
    
    
    [self.whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(pixelValue(0));
        make.left.mas_equalTo(pixelValue(0));
        make.right.mas_equalTo(pixelValue(0));
        make.bottom.mas_equalTo(pixelValue(0));
    }];
    
    [self.blueView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(pixelValue(30));
        make.width.mas_equalTo(pixelValue(10));
        make.centerY.mas_equalTo(self.whiteView.mas_centerY);
        make.height.mas_equalTo(pixelValue(30));
    }];
    
    [self.hotLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.blueView.mas_right).offset(pixelValue(20));
        make.height.mas_equalTo(pixelValue(30));
        make.centerY.mas_equalTo(self.whiteView.mas_centerY);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(pixelValue(30));
        make.right.mas_equalTo(pixelValue(-30));
        make.height.mas_equalTo(pixelValue(1));
        make.bottom.mas_equalTo(self.whiteView.mas_bottom);
    }];
}

-(UIView *)whiteView{
    if(!_whiteView){
        _whiteView = [[UIView alloc]init];
        _whiteView.backgroundColor = [UIColor whiteColor];
    }
    return _whiteView;
}

-(UIView *)blueView{
    if(!_blueView){
        _blueView = [[UIView alloc]init];
        _blueView.backgroundColor = [UIColor colorWithHexString:@"#0291FC"];
    }
    return _blueView;
}

-(UILabel *)hotLabel{
    if(!_hotLabel){
        _hotLabel = [[UILabel alloc]init];
        _hotLabel.font = [UIFont systemFontOfSize:pixelValue(32)];
        _hotLabel.textColor = [UIColor colorWithHexString:@"#1A80CC"];
        _hotLabel.text = @"家庭服务";
    }
    return _hotLabel;
}

-(UIView *)lineView{
    if(!_lineView){
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"#C0BEBE"];
    }
    return _lineView;
}


@end
