//
//  JYHomeRecommendedBigPictureTableViewCell.m
//  WMDoctor
//
//  Created by zhenYan on 2018/8/18.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYHomeRecommendedBigPictureTableViewCell.h"

@implementation JYHomeRecommendedBigPictureTableViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self configUI];
    }
    return self;
}

-(void)configUI{
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.fromLabel];
    [self.contentView addSubview:self.myImageView];
    [self.contentView addSubview:self.deleteButton];
    [self.contentView addSubview:self.guangGaoLabel];
    [self.contentView addSubview:self.lineView];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(pixelValue(20));
        make.left.mas_equalTo(self.contentView.mas_left).offset(pixelValue(20));
        make.right.mas_equalTo(self.contentView.mas_right).offset(-pixelValue(20));
    }];
    [self.fromLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_left);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(pixelValue(20));
        make.height.mas_equalTo(pixelValue(30));
    }];
    
    [self.myImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.fromLabel.mas_bottom).offset(pixelValue(20));
        make.left.mas_equalTo(self.contentView.mas_left).offset(pixelValue(20));
        make.right.mas_equalTo(self.contentView.mas_right).offset(-pixelValue(20));
        make.height.mas_equalTo(pixelValue(370));
    }];

    
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.myImageView.mas_bottom).offset(pixelValue(20));
        make.right.mas_equalTo(self.contentView.mas_right).offset(-pixelValue(20));
        make.width.height.mas_equalTo(pixelValue(40));
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-pixelValue(20));
    }];
    
    [self.guangGaoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.myImageView.mas_left);
        make.top.mas_equalTo(self.deleteButton.mas_top);
        make.height.mas_equalTo(pixelValue(40));
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(pixelValue(20));
        make.right.mas_equalTo(-pixelValue(20));
        make.height.mas_equalTo(pixelValue(1));
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
    
}

//标题
-(UILabel *)titleLabel{
    if(!_titleLabel){
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.text = @"领跑阶段，科技实力正处于从量的积累向质的飞跃、点的突破向系统能力提升的重要时期...";
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:pixelValue(30)];
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}
//来源
-(UILabel *)fromLabel{
    if(!_fromLabel){
        _fromLabel = [[UILabel alloc]init];
        _fromLabel.text = @"某某网日报";
        _fromLabel.textColor = [UIColor colorWithHexString:@"#909090"];
        _fromLabel.font = [UIFont systemFontOfSize:pixelValue(26)];
    }
    return _fromLabel;
    
}
//图片
-(UIImageView *)myImageView{
    if(!_myImageView){
        _myImageView = [[UIImageView alloc]init];
        _myImageView.image = [UIImage imageNamed:@"矩形_15"];
    }
    return _myImageView;
}
//广告
-(UILabel *)guangGaoLabel{
    if(!_guangGaoLabel){
        _guangGaoLabel = [[UILabel alloc]init];
        _guangGaoLabel.text = @"广告";
        _guangGaoLabel.textColor = [UIColor colorWithHexString:@"#909090"];
        _guangGaoLabel.font = [UIFont systemFontOfSize:pixelValue(24)];
    }
    return _guangGaoLabel;
}

//删除按钮
-(UIButton *)deleteButton{
    if(!_deleteButton){
        _deleteButton = [[UIButton alloc]init];
        [_deleteButton setTitle:@"x" forState:UIControlStateNormal];
        [_deleteButton setTitleColor:[UIColor colorWithHexString:@"#909090"] forState:UIControlStateNormal];
        [_deleteButton setBackgroundColor:[UIColor colorWithHexString:@"#F7F7F7"]];
        _deleteButton.layer.cornerRadius = pixelValue(20);
    }
    return _deleteButton;
}

//线
-(UIView *)lineView{
    if(!_lineView){
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    }
    return _lineView;
}
@end
