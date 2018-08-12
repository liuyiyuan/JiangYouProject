//
//  JYHomeRecommendedThreePictureTableViewCell.m
//  WMDoctor
//
//  Created by zhenYan on 2018/8/12.
//  Copyright © 2018年 Choice. All rights reserved.
//
//三张图
#import "JYHomeRecommendedThreePictureTableViewCell.h"

@implementation JYHomeRecommendedThreePictureTableViewCell

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
    [self.contentView addSubview:self.firstImageView];
    [self.contentView addSubview:self.secondImageView];
    [self.contentView addSubview:self.thirdImageView];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.commentsButton];
    [self.contentView addSubview:self.deleteButton];
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
    
    
    [self.firstImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.fromLabel.mas_bottom).offset(pixelValue(20));
        make.left.mas_equalTo(pixelValue(20));
        make.width.height.mas_equalTo((UI_SCREEN_WIDTH - pixelValue(100)) / 3);
    }];
    
    [self.secondImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.firstImageView.mas_top);
        make.left.mas_equalTo(self.firstImageView.mas_right).offset(pixelValue(20));
        make.width.height.mas_equalTo((UI_SCREEN_WIDTH - pixelValue(100)) / 3);
    }];
    
    [self.thirdImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.secondImageView.mas_top);
        make.left.mas_equalTo(self.secondImageView.mas_right).offset(pixelValue(20));
        make.width.height.mas_equalTo((UI_SCREEN_WIDTH - pixelValue(100)) / 3);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.fromLabel.mas_left);
        make.top.mas_equalTo(self.firstImageView.mas_bottom).offset(pixelValue(20));
        make.height.mas_equalTo(pixelValue(40));
    }];
    
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.firstImageView.mas_bottom).offset(pixelValue(20));
        make.right.mas_equalTo(self.contentView.mas_right).offset(-pixelValue(20));
        make.width.height.mas_equalTo(pixelValue(40));
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-pixelValue(20));
    }];
    
    [self.commentsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.deleteButton.mas_top);
        make.right.mas_equalTo(self.deleteButton.mas_left).offset(-pixelValue(20));
        make.height.height.mas_equalTo(self.deleteButton.mas_height);
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

-(UIImageView *)firstImageView{
    if(!_firstImageView){
        _firstImageView = [[UIImageView alloc]init];
        _firstImageView.image = [UIImage imageNamed:@"news_placed"];
    }
    return _firstImageView;
}

-(UIImageView *)secondImageView{
    if(!_secondImageView){
        _secondImageView = [[UIImageView alloc]init];
        _secondImageView.image = [UIImage imageNamed:@"news_placed"];
    }
    return _secondImageView;
}

-(UIImageView *)thirdImageView{
    if(!_thirdImageView){
        _thirdImageView = [[UIImageView alloc]init];
        _thirdImageView.image = [UIImage imageNamed:@"news_placed"];
    }
    return _thirdImageView;
}
//时间
-(UILabel *)timeLabel{
    if(!_timeLabel){
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.text = @"5分钟前";
        _timeLabel.textColor = [UIColor colorWithHexString:@"#909090"];
        _timeLabel.font = [UIFont systemFontOfSize:pixelValue(26)];
    }
    return _timeLabel;
}

//评论
-(UIButton *)commentsButton{
    if(!_commentsButton){
        _commentsButton = [[UIButton alloc]init];
        [_commentsButton setTitle:@"  2009评论  " forState:UIControlStateNormal];
        _commentsButton.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
        [_commentsButton setTitleColor:[UIColor colorWithHexString:@"#909090"] forState:UIControlStateNormal];
        _commentsButton.layer.cornerRadius = pixelValue(20);
        _commentsButton.layer.masksToBounds = YES;
        _commentsButton.titleLabel.font = [UIFont systemFontOfSize:pixelValue(26)];
    }
    return _commentsButton;
}
//删除按钮
-(UIButton *)deleteButton{
    if(!_deleteButton){
        _deleteButton = [[UIButton alloc]init];
//        [_deleteButton setBackgroundImage:[UIImage imageNamed:@"矢量智能对象 副本"] forState:UIControlStateNormal];
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
