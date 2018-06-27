//
//  JYAboutUsHeaderView.m
//  WMDoctor
//
//  Created by jiangqi on 2018/6/27.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYAboutUsHeaderView.h"

@implementation JYAboutUsHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
        [self configUI];
    }
    return self;
}

- (void)configUI {
    [self addSubview:self.logoImageView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.englishNameLabel];
    
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(pixelValue(80));
        make.width.height.mas_equalTo(104);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.logoImageView.mas_bottom).offset(pixelValue(40));
        make.left.right.mas_equalTo(pixelValue(0));
        make.height.mas_equalTo(pixelValue(40));
    }];
    [self.englishNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(pixelValue(20));
        make.right.left.mas_equalTo(pixelValue(0));
        make.height.mas_equalTo(pixelValue(30));
    }];
}

-(UIImageView *)logoImageView{
    if(!_logoImageView){
        _logoImageView = [[UIImageView alloc]init];
        _logoImageView.image = [UIImage imageNamed:@"jy_logo"];
    }
    return _logoImageView;
}

-(UILabel *)nameLabel{
    if(!_nameLabel){
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.text = @"江油全搜索";
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.font = [UIFont systemFontOfSize:15.0];
    }
    return _nameLabel;;
}

-(UILabel *)englishNameLabel{
    if(!_englishNameLabel){
        _englishNameLabel = [[UILabel alloc]init];
        _englishNameLabel.textColor = [UIColor colorWithHexString:@"#9A9A9A"];
        _englishNameLabel.text = @"Jiangyou circle search";
        _englishNameLabel.textAlignment = NSTextAlignmentCenter;
        _englishNameLabel.font = [UIFont systemFontOfSize:12.0];
    }
    return _englishNameLabel;
    
}

@end
