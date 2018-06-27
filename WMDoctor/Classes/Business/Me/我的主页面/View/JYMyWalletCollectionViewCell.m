//
//  JYMyWalletCollectionViewCell.m
//  WMDoctor
//
//  Created by jiangqi on 2018/6/27.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYMyWalletCollectionViewCell.h"

@implementation JYMyWalletCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        for (id subView in self.contentView.subviews) {
            [subView removeFromSuperview];
        }
        [self.contentView addSubview:self.picImg];
        [self.contentView addSubview:self.nameLab];
        
        [self autoLayoutMas];
    }
    return self;
}
- (void)autoLayoutMas{
    [self.picImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.centerY.mas_equalTo(self.contentView.mas_centerY).offset(-pixelValue(10));
        make.width.mas_equalTo(34);
        make.height.mas_equalTo(30);
    }];
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.picImg.mas_bottom).offset(pixelValue(10));
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(pixelValue(44));
    }];
 
    
    
}
- (UIImageView *)picImg {
    if (!_picImg) {
        _picImg = [[UIImageView alloc] init];
    }
    return _picImg;
}
- (UILabel *)nameLab {
    if (!_nameLab) {
        _nameLab = [[UILabel alloc] init];
        _nameLab.textColor = [UIColor blackColor];
        _nameLab.font = [UIFont systemFontOfSize:pixelValue(28)];
        _nameLab.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLab;
}


@end
