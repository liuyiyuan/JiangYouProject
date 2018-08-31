//
//  JYHomeNewsCollectionViewCell.m
//  WMDoctor
//
//  Created by zhenYan on 2018/8/31.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYHomeNewsCollectionViewCell.h"

@implementation JYHomeNewsCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self configUI];
    }
    return self;
}


-(void)configUI{
    [self.contentView addSubview:self.myImageView];
    
    [self.myImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(pixelValue(0));
        make.left.mas_equalTo(pixelValue(0));
        make.right.mas_equalTo(-pixelValue(0));
        make.bottom.mas_equalTo(-pixelValue(0));
    }];
}

-(UIImageView *)myImageView{
    if(!_myImageView){
        _myImageView = [[UIImageView alloc]init];
    }
    return _myImageView;
}

@end
