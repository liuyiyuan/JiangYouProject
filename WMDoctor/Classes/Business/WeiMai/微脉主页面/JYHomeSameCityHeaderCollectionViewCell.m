//
//  JYHomeSameCityHeaderCollectionViewCell.m
//  WMDoctor
//
//  Created by zhenYan on 2018/8/10.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYHomeSameCityHeaderCollectionViewCell.h"

@implementation JYHomeSameCityHeaderCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
        [self configUI];
    }
    return self;
}

-(void)configUI{
    [self.contentView addSubview:self.myImageView];
    [self.contentView addSubview:self.myLabel];
    
    [self.myImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(pixelValue(20));
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.width.height.mas_equalTo(pixelValue(70));
    }];
    
    [self.myLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.myImageView.mas_bottom);
        make.left.mas_equalTo(pixelValue(0));
        make.right.mas_equalTo(pixelValue(0));
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
}

-(UIImageView *)myImageView{
    if(!_myImageView){
        _myImageView = [[UIImageView alloc]init];
    }
    return _myImageView;
}

-(UILabel *)myLabel{
    if(!_myLabel){
        _myLabel = [[UILabel alloc]init];
        _myLabel.textColor = [UIColor blackColor];
        _myLabel.textAlignment = NSTextAlignmentCenter;
        _myLabel.font = [UIFont systemFontOfSize:pixelValue(28)];
    }
    return _myLabel;
}
@end
