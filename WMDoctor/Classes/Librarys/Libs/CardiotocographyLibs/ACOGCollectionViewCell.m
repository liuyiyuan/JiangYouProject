//
//  ACOGCollectionViewCell.m
//  OctobarGoodBaby
//
//  Created by 莱康宁 on 16/11/21.
//  Copyright © 2016年 luckcome. All rights reserved.
//

#import "ACOGCollectionViewCell.h"
#import "masonry.h"

@implementation ACOGCollectionViewCell
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
        
              
    }
       return self;
}
-(void)setMarkbtnWithSelectedState:(BOOL)seleected{
    
}

-(UILabel *) tipLable {
    if (!_tipLable) {
        _tipLable = [[UILabel alloc] init];
//        _tipLable.text = @"胎动正常";
        _tipLable.font = [UIFont systemFontOfSize:8];
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
@end
