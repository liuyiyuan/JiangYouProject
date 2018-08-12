//
//  JYHomeRecommendedUnPictureTableViewCell.m
//  WMDoctor
//
//  Created by zhenYan on 2018/8/12.
//  Copyright © 2018年 Choice. All rights reserved.
//
//无图
#import "JYHomeRecommendedUnPictureTableViewCell.h"

@implementation JYHomeRecommendedUnPictureTableViewCell

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
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.commentsButton];
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
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.fromLabel.mas_left);
        make.top.mas_equalTo(self.fromLabel.mas_bottom).offset(pixelValue(40));
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-pixelValue(20));
        make.height.mas_equalTo(pixelValue(40));
    }];
    [self.commentsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-pixelValue(20));
        make.top.mas_equalTo(self.timeLabel.mas_top);
        make.height.mas_equalTo(self.timeLabel.mas_height);
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
        _titleLabel.text = @"党的十八大以来，我们总结我国科技事业发展实践，观察大势，谋划全局，深化改革，全面发力...";
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
        _commentsButton.layer.cornerRadius = pixelValue(15);
        _commentsButton.layer.masksToBounds = YES;
        _commentsButton.titleLabel.font = [UIFont systemFontOfSize:pixelValue(26)];
    }
    return _commentsButton;
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
