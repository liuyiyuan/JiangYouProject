//
//  ACOGThreeCollectionViewCell.m
//  OctobarGoodBaby
//
//  Created by 莱康宁 on 16/11/22.
//  Copyright © 2016年 luckcome. All rights reserved.
//

#import "ACOGThreeCollectionViewCell.h"
#import "masonry.h"

@implementation ACOGThreeCollectionViewCell
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self.contentView addSubview:self.markBtn];
        [self.markBtn  mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.left.equalTo(self.contentView.mas_left).offset(5);
            make.size.equalTo([NSValue valueWithCGSize:CGSizeMake(15, 15)]);
        }];
        
        [self.contentView addSubview:self.tipLable];
        [self.tipLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.markBtn.mas_right).offset(5);
            make.centerY.equalTo(self.markBtn.mas_centerY);
            make.right.equalTo(self.contentView.mas_right).offset(-5);
        }];
        
        [self.contentView addSubview:self.topMarkBtn];
        [self.topMarkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.markBtn.mas_centerY).offset(-20);
            make.left.equalTo(self.contentView.mas_left).offset(5);
            make.size.equalTo([NSValue valueWithCGSize:CGSizeMake(15, 15)]);
        }];
        
        [self.contentView addSubview:self.topLable];
        [self.topLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.topMarkBtn.mas_centerY);
            make.left.equalTo(self.topMarkBtn.mas_right).offset(5);
            make.right.equalTo(self.contentView.mas_right).offset(-5);
            
        }];
        
        [self.contentView addSubview:self.btmMarkBtn];
        [self.btmMarkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.markBtn.mas_centerY).offset(20);
            make.left.equalTo(self.contentView.mas_left).offset(5);
            make.size.equalTo([NSValue valueWithCGSize:CGSizeMake(15, 15)]);
        }];
        
        [self.contentView addSubview:self.btmLable];
        [self.btmLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.btmMarkBtn.mas_centerY);
            make.left.equalTo(self.btmMarkBtn.mas_right).offset(5);
            make.right.equalTo(self.contentView.mas_right).offset(-5);
            
        }];
        
    }
    return self;
}
-(UILabel *) tipLable {
    if (!_tipLable) {
        _tipLable = [[UILabel alloc] init];
        //        _tipLable.text = @"胎动正常";
        _tipLable.font = [UIFont systemFontOfSize:9];
        _tipLable.textColor = RGBA(64, 64, 64, 1);
        _tipLable.numberOfLines = 0;
        [_tipLable setLineBreakMode:NSLineBreakByCharWrapping];

    }
    return  _tipLable;
}
-(UIButton *)markBtn{
    if (!_markBtn ) {
        _markBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.markBtn setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateSelected];
        [self.markBtn setImage:[UIImage imageNamed:@"未选"] forState:UIControlStateNormal];
    }
    return _markBtn;
}
-(UILabel *) topLable {
    if (!_topLable) {
        _topLable = [[UILabel alloc] init];
        //        _topLable.text = @"胎动正常";
        _topLable.font = [UIFont systemFontOfSize:9];
        _topLable.textColor = RGBA(64, 64, 64, 1);
        _topLable.numberOfLines = 0;
        [_topLable setLineBreakMode:NSLineBreakByCharWrapping];

    }
    return  _topLable;
}
-(UIButton *)topMarkBtn{
    if (!_topMarkBtn ) {
        _topMarkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.topMarkBtn setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateSelected];
        [self.topMarkBtn setImage:[UIImage imageNamed:@"未选"] forState:UIControlStateNormal];
    }
    return _topMarkBtn;
}
-(UILabel *)btmLable {
    if (!_btmLable) {
        _btmLable = [[UILabel alloc] init];
        //        _btmLable.text = @"胎动正常";
        _btmLable.font = [UIFont systemFontOfSize:9];
        _btmLable.textColor = RGBA(64, 64, 64, 1);
        _btmLable.numberOfLines = 0;
        [_btmLable setLineBreakMode:NSLineBreakByCharWrapping];

    }
    return  _btmLable;
}
-(UIButton *)btmMarkBtn{
    if (!_btmMarkBtn ) {
        _btmMarkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.btmMarkBtn setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateSelected];
        [self.btmMarkBtn setImage:[UIImage imageNamed:@"未选"] forState:UIControlStateNormal];
    }
    return _btmMarkBtn;
}

@end
