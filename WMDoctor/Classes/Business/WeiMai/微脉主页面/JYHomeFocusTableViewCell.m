//
//  JYHomeFocusTableViewCell.m
//  WMDoctor
//
//  Created by zhenYan on 2018/8/1.
//  Copyright © 2018年 Choice. All rights reserved.
//
//首页  关注
#import "JYHomeFocusTableViewCell.h"

@implementation JYHomeFocusTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self configUI];
    }
    return self;
}

-(void)configUI{
    [self.contentView addSubview:self.headerImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.focusButton];
    [self.contentView addSubview:self.deleteButton];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.firstImageView];
    [self.contentView addSubview:self.secondImageView];
    [self.contentView addSubview:self.thirdImageView];
    [self.contentView addSubview:self.addressButton];
    [self.contentView addSubview:self.readCountLabel];
    [self.contentView addSubview:self.forwardingButton];
    [self.contentView addSubview:self.commentsButton];
    [self.contentView addSubview:self.likedButton];
    [self.contentView addSubview:self.lineView];
    
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(pixelValue(30));
        make.left.mas_equalTo(self.contentView.mas_left).offset(pixelValue(30));
        make.width.height.mas_equalTo(pixelValue(50));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headerImageView.mas_right).offset(pixelValue(20));
        make.centerY.mas_equalTo(self.headerImageView.mas_centerY);
        make.height.mas_equalTo(pixelValue(30));
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headerImageView.mas_left);
        make.top.mas_equalTo(self.headerImageView.mas_bottom).offset(pixelValue(20));
        make.height.mas_equalTo(pixelValue(20));
    }];
    
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.headerImageView.mas_centerY);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-pixelValue(30));
        make.width.mas_equalTo(pixelValue(44));
        make.height.mas_equalTo(pixelValue(32));
    }];
    
    [self.focusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.deleteButton.mas_centerY);
        make.right.mas_equalTo(self.deleteButton.mas_left).offset(-pixelValue(30));
        make.height.mas_equalTo(pixelValue(40));
    }];
    
    
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.timeLabel.mas_bottom).offset(pixelValue(30));
        make.left.mas_equalTo(pixelValue(30));
        make.right.mas_equalTo(-pixelValue(30));
    }];
    
    [self.firstImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentLabel.mas_bottom).offset(pixelValue(20));
        make.left.mas_equalTo(pixelValue(30));
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
    
    [self.addressButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.firstImageView.mas_bottom).offset(pixelValue(20));
        make.left.mas_equalTo(self.firstImageView.mas_left);
        make.height.mas_equalTo(pixelValue(30));
    }];
    
    [self.readCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.addressButton.mas_top);
        make.left.mas_equalTo(self.addressButton.mas_right).offset(pixelValue(20));
        make.height.mas_equalTo(pixelValue(30));
    }];
    
    [self.forwardingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.addressButton.mas_bottom).offset(pixelValue(20));
        make.left.mas_equalTo(self.contentView.mas_left);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-pixelValue(2));
        make.width.mas_equalTo(UI_SCREEN_WIDTH / 3);
        make.height.mas_equalTo(pixelValue(60));
    }];
    
    [self.commentsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.forwardingButton.mas_top);
        make.left.mas_equalTo(self.forwardingButton.mas_right);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.width.mas_equalTo(self.forwardingButton.mas_width);
        make.height.mas_equalTo(pixelValue(60));
    }];
    
    [self.likedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.forwardingButton.mas_top);
        make.left.mas_equalTo(self.commentsButton.mas_right);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.width.mas_equalTo(self.forwardingButton.mas_width);
        make.height.mas_equalTo(pixelValue(60));
    }];
    
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.height.mas_equalTo(pixelValue(1));
        make.left.mas_equalTo(pixelValue(0));
        make.right.mas_equalTo(pixelValue(0));
    }];
    
    
    
}

-(UIImageView *)headerImageView{
    if(!_headerImageView){
        _headerImageView = [[UIImageView alloc]init];
        _headerImageView.image = [UIImage imageNamed:@"news_placed"];
    }
    return _headerImageView;
}

-(UILabel *)nameLabel{
    if(!_nameLabel){
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.text = @"放屁的怪咖";
    }
    return _nameLabel;
}

-(UILabel *)timeLabel{
    if(!_timeLabel){
        _timeLabel = [[UILabel alloc]init];
//        _timeLabel.text = @"12小时前";
        _timeLabel.textColor = [UIColor colorWithHexString:@"#ABA9A9"];
    }
    return _timeLabel;
}

-(UIButton *)focusButton{
    if(!_focusButton){
        _focusButton = [[UIButton alloc]init];
        [_focusButton setTitle:@"关注" forState:UIControlStateNormal];
        [_focusButton setTitleColor:[UIColor colorWithHexString:@"#50B8FB"] forState:UIControlStateNormal];
        _focusButton.titleLabel.font = [UIFont systemFontOfSize:pixelValue(26)];
    }
    return _focusButton;
}

-(UIButton *)deleteButton{
    if(!_deleteButton){
        _deleteButton = [[UIButton alloc]init];
        [_deleteButton setBackgroundImage:[UIImage imageNamed:@"new_deleted"] forState:UIControlStateNormal];
    }
    return _deleteButton;
}

-(UILabel *)contentLabel{
    if(!_contentLabel){
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.numberOfLines = 0;
//        _contentLabel.text = @"我是一个22岁的小伙,今年开始学的吉他,虽然平时很忙事情很多,但只要一有空就会拿起吉他练习;我经常在寝室静静地听喜欢的音乐,后来我做了一个决定:以后每次在网易云听到喜欢的音乐就留此言,天南海北的朋友如果你觉得跟我一样,回复我或私信我,我们一定有很多共同的话题。";
    }
    return _contentLabel;
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

-(UIButton *)addressButton{
    if(!_addressButton){
        _addressButton = [[UIButton alloc]init];
        [_addressButton setTitle:@"  黑龙江省 哈尔滨市" forState:UIControlStateNormal];
        [_addressButton setTitleColor:[UIColor colorWithHexString:@"#ABA9A9"] forState:UIControlStateNormal];
        [_addressButton setImage:[UIImage imageNamed:@"news_address"] forState:UIControlStateNormal];
    }
    return _addressButton;
}

-(UILabel *)readCountLabel{
    if(!_readCountLabel){
        _readCountLabel = [[UILabel alloc]init];
//        _readCountLabel.text = @"35万";
        _readCountLabel.textColor = [UIColor colorWithHexString:@"#ABA9A9"];
    }
    return _readCountLabel;
}


-(UIButton *)forwardingButton{
    if(!_forwardingButton){
        _forwardingButton = [[UIButton alloc]init];
//        [_forwardingButton setTitle:@"转发" forState:UIControlStateNormal];
        [_forwardingButton setTitleColor:[UIColor colorWithHexString:@"#ABA9A9"] forState:UIControlStateNormal];
        [_forwardingButton setImage:[UIImage imageNamed:@"new_forwarding"] forState:UIControlStateNormal];
    }
    return _forwardingButton;
}

-(UIButton *)commentsButton{
    if(!_commentsButton){
        _commentsButton = [[UIButton alloc]init];
//        [_commentsButton setTitle:@"评论" forState:UIControlStateNormal];
        [_commentsButton setTitleColor:[UIColor colorWithHexString:@"#ABA9A9"] forState:UIControlStateNormal];
        [_commentsButton setImage:[UIImage imageNamed:@"news_comment"] forState:UIControlStateNormal];
    }
    return _commentsButton;
}

-(UIButton *)likedButton{
    if(!_likedButton){
        _likedButton = [[UIButton alloc]init];
//        [_likedButton setTitle:@"赞" forState:UIControlStateNormal];
        [_likedButton setTitleColor:[UIColor colorWithHexString:@"#ABA9A9"] forState:UIControlStateNormal];
        [_likedButton setImage:[UIImage imageNamed:@"nwes_liked"] forState:UIControlStateNormal];
    }
    return _likedButton;
}


-(UIView *)lineView{
    if(!_lineView){
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"#DCDCDC"];
    }
    return _lineView;
}
@end
