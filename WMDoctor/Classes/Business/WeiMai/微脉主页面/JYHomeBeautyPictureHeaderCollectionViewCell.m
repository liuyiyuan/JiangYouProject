//
//  JYHomeBeautyPictureHeaderCollectionViewCell.m
//  WMDoctor
//
//  Created by zhenYan on 2018/8/7.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYHomeBeautyPictureHeaderCollectionViewCell.h"

@implementation JYHomeBeautyPictureHeaderCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self configUI];
    }
    return self;
}


-(void)configUI{
    [self.contentView addSubview:self.myImageView];
    
    [self.myImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(pixelValue(10));
        make.left.mas_equalTo(pixelValue(10));
        make.right.mas_equalTo(-pixelValue(10));
        make.bottom.mas_equalTo(-pixelValue(10));
    }];
}

-(UIImageView *)myImageView{
    if(!_myImageView){
        _myImageView = [[UIImageView alloc]init];
        _myImageView.image = [UIImage imageNamed:@"圆角矩形 9"];
    }
    return _myImageView;
}

@end
