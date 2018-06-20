//
//  ACOGOneCollectionViewCell.m
//  OctobarGoodBaby
//
//  Created by 莱康宁 on 16/11/22.
//  Copyright © 2016年 luckcome. All rights reserved.
//

#import "ACOGOneCollectionViewCell.h"
#import "masonry.h"

@implementation ACOGOneCollectionViewCell
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self.contentView addSubview:self.titleLable];
        [self.titleLable  mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.centerX.equalTo(@(self.contentView.centerX));
        }];
        
     
    }
    return self;
}
-(UILabel *)titleLable {
    if (!_titleLable) {
        _titleLable = [[UILabel alloc] init];
        _titleLable.text = @"胎心率基线";
        _titleLable.font = [UIFont systemFontOfSize:15];
        _titleLable.textColor = RGBA(64, 64, 64, 1);
        _titleLable.numberOfLines = 0;
    }
    return  _titleLable;
}

@end
