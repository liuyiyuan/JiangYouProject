//
//  JYHomeRecommendedSinglePictureTableViewCell.m
//  WMDoctor
//
//  Created by zhenYan on 2018/8/12.
//  Copyright © 2018年 Choice. All rights reserved.
//
//左侧单图
#import "JYHomeRecommendedSinglePictureTableViewCell.h"

@implementation JYHomeRecommendedSinglePictureTableViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self configUI];
    }
    return self;
}



-(void)configUI{
    [self.contentView addSubview:self.myImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.fromLabel];
    [self.contentView addSubview:self.topButton];
    [self.contentView addSubview:self.commentsButton];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.lineView];
    
    [self.myImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(pixelValue(20));
        make.left.mas_equalTo(self.contentView.mas_left).offset(pixelValue(20));
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-pixelValue(20));
        make.width.mas_equalTo(pixelValue(280));
        make.height.mas_equalTo(pixelValue(190));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.myImageView.mas_top);
        make.left.mas_equalTo(self.myImageView.mas_right).offset(pixelValue(20));
        make.right.mas_equalTo(self.contentView.mas_right).offset(-pixelValue(20));
    }];
    [self.fromLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(pixelValue(10));
        make.left.mas_equalTo(self.titleLabel.mas_left);
        make.height.mas_equalTo(pixelValue(20));
    }];
    [self.topButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.myImageView.mas_bottom);
        make.left.mas_equalTo(self.titleLabel.mas_left);
        make.height.mas_equalTo(pixelValue(40));
    }];
    [self.commentsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.topButton.mas_bottom);
        make.left.mas_equalTo(self.topButton.mas_right).offset(pixelValue(15));
        make.height.mas_equalTo(self.topButton.mas_height);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.commentsButton.mas_bottom);
        make.left.mas_equalTo(self.commentsButton.mas_right).offset(pixelValue(15));
        make.height.mas_equalTo(self.commentsButton.mas_height);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(pixelValue(20));
        make.right.mas_equalTo(-pixelValue(20));
        make.height.mas_equalTo(pixelValue(1));
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
    
    
}

-(UIImageView *)myImageView{
    if(!_myImageView){
        _myImageView = [[UIImageView alloc]init];
        _myImageView.image = [UIImage imageNamed:@"矩形 14"];
    }
    return _myImageView;
}
//标题
-(UILabel *)titleLabel{
    if(!_titleLabel){
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.text = @"家门口有这几种现象出现，万万要留神了预示越住越穷...";
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
        _fromLabel.font = [UIFont systemFontOfSize:pixelValue(26)];
        _fromLabel.textColor = [UIColor colorWithHexString:@"#909090"];
    }
    return _fromLabel;
}
//置顶按钮
-(UIButton *)topButton{
    if(!_topButton){
        _topButton = [[UIButton alloc]init];
        [_topButton setTitle:@"  置顶  " forState:UIControlStateNormal];
        [_topButton setBackgroundColor:[UIColor colorWithHexString:@"#50B8FB"]];
        [_topButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _topButton.titleLabel.font = [UIFont systemFontOfSize:pixelValue(26)];
        _topButton.layer.cornerRadius = pixelValue(20);
        _topButton.layer.masksToBounds = YES;
    }
    return _topButton;
}
//评论
-(UIButton *)commentsButton{
    if(!_commentsButton){
        _commentsButton = [[UIButton alloc]init];
        [_commentsButton setTitle:@"  2009评论  " forState:UIControlStateNormal];
        [_commentsButton setTitleColor:[UIColor colorWithHexString:@"#909090"] forState:UIControlStateNormal];
        [_commentsButton setBackgroundColor:[UIColor colorWithHexString:@"#F7F7F7"]];
        _commentsButton.titleLabel.font = [UIFont systemFontOfSize:pixelValue(26)];
        _commentsButton.layer.cornerRadius = pixelValue(20);
        _commentsButton.layer.masksToBounds = YES;
    }
    return _commentsButton;
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

//线
-(UIView *)lineView{
    if(!_lineView){
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    }
    return _lineView;
}

@end
