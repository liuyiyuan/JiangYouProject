//
//  ACOGTwoCollectionViewCell.m
//  OctobarGoodBaby
//
//  Created by 莱康宁 on 16/11/22.
//  Copyright © 2016年 luckcome. All rights reserved.
//

#import "ACOGTwoCollectionViewCell.h"
#import "masonry.h"

@implementation ACOGTwoCollectionViewCell
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        [self.contentView addSubview:self.topMarkBtn];
        [self.topMarkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView.mas_centerY).offset(-10);
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
            make.top.equalTo(self.contentView.mas_centerY).offset(10);
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
