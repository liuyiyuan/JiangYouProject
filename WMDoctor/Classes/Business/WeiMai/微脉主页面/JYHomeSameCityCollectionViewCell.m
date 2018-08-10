//
//  JYHomeSameCityCollectionViewCell.m
//  WMDoctor
//
//  Created by zhenYan on 2018/8/10.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYHomeSameCityCollectionViewCell.h"

@implementation JYHomeSameCityCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self configUI];
    }
    return self;
}

-(void)configUI{
    [self.contentView addSubview:self.myLabel];
    [self.contentView addSubview:self.lineView];
    
    [self.myLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(pixelValue(0));
        make.left.mas_equalTo(pixelValue(0));
        make.bottom.mas_equalTo(pixelValue(0));
        make.right.mas_equalTo(-pixelValue(2));
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(pixelValue(20));
        make.bottom.mas_equalTo(-pixelValue(20));
        make.right.mas_equalTo(pixelValue(0));
        make.width.mas_equalTo(pixelValue(0.6));
    }];
}

-(UILabel *)myLabel{
    if(!_myLabel){
        _myLabel = [[UILabel alloc]init];
        _myLabel.textColor = [UIColor colorWithHexString:@"#757575"];
        _myLabel.font = [UIFont systemFontOfSize:pixelValue(28)];
        _myLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _myLabel;
}

-(UIView *)lineView{
    if(!_lineView){
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"#757575"];
    }
    return _lineView;
}

@end
