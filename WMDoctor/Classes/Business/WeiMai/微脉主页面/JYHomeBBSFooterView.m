//
//  JYHomeBBSFooterView.m
//  WMDoctor
//
//  Created by zhenYan on 2018/8/9.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYHomeBBSFooterView.h"

@implementation JYHomeBBSFooterView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self configUI];
    }
    return self;
}

-(void)configUI{
    [self addSubview:self.findMoreButton];
    
    [self.findMoreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(pixelValue(0));
        make.right.mas_equalTo(pixelValue(0));
        make.bottom.mas_equalTo(self.mas_bottom);
        make.height.mas_equalTo(pixelValue(90));
    }];
}
//发现更多
-(UIButton *)findMoreButton{
    if(!_findMoreButton){
        _findMoreButton = [[UIButton alloc]init];
        [_findMoreButton setTitle:@"发现更多" forState:UIControlStateNormal];
        [_findMoreButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _findMoreButton.backgroundColor = [UIColor colorWithHexString:@"#32ADF1"];
    }
    return _findMoreButton;
}

@end
