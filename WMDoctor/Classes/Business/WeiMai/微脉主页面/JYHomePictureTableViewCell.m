//
//  JYHomePictureTableViewCell.m
//  WMDoctor
//
//  Created by jiangqi on 2018/8/7.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYHomePictureTableViewCell.h"

@implementation JYHomePictureTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self configUI];
    }
    return self;
}

-(void)configUI{
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.myImageView];
    [self.contentView addSubview:self.likeButton];
    [self.contentView addSubview:self.unLikeButton];
    [self.contentView addSubview:self.commentsButton];
    [self.contentView addSubview:self.starButton];
    [self.contentView addSubview:self.shareButton];
    [self.contentView addSubview:self.lineView];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(pixelValue(30));
        make.left.mas_equalTo(self.contentView.mas_left).offset(pixelValue(30));
        make.right.mas_equalTo(self.contentView.mas_right).offset(-pixelValue(30));
    }];
    
    [self.myImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(pixelValue(20));
        make.left.mas_equalTo(self.titleLabel.mas_left);
        make.width.height.mas_equalTo(UI_SCREEN_WIDTH - pixelValue(60));
    }];
    
    [self.likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.myImageView.mas_bottom).offset(pixelValue(20));
        make.left.mas_equalTo(pixelValue(0));
        make.width.mas_equalTo(UI_SCREEN_WIDTH / 5);
        make.height.mas_equalTo(pixelValue(60));
    }];
    
    [self.unLikeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.likeButton.mas_top);
        make.width.mas_equalTo(self.likeButton.mas_width);
        make.height.mas_equalTo(self.likeButton.mas_height);
        make.left.mas_equalTo(self.likeButton.mas_right);
    }];
    
    [self.commentsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.likeButton.mas_top);
        make.width.mas_equalTo(self.likeButton.mas_width);
        make.height.mas_equalTo(self.likeButton.mas_height);
        make.left.mas_equalTo(self.unLikeButton.mas_right);
    }];
    
    [self.starButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.likeButton.mas_top);
        make.width.mas_equalTo(self.likeButton.mas_width);
        make.height.mas_equalTo(self.likeButton.mas_height);
        make.left.mas_equalTo(self.commentsButton.mas_right);
    }];
    
    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.likeButton.mas_top);
        make.width.mas_equalTo(self.likeButton.mas_width);
        make.height.mas_equalTo(self.likeButton.mas_height);
        make.left.mas_equalTo(self.starButton.mas_right);
    }];

    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.starButton.mas_bottom).offset(pixelValue(10));
        make.left.mas_equalTo(pixelValue(0));
        make.right.mas_equalTo(pixelValue(0));
        make.height.mas_equalTo(pixelValue(1));
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
}
//标题
-(UILabel *)titleLabel{
    if(!_titleLabel){
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.numberOfLines = 0;
        _titleLabel.font = [UIFont systemFontOfSize:pixelValue(30)];
    }
    return _titleLabel;
}
//图片
-(UIImageView *)myImageView{
    if(!_myImageView){
        _myImageView = [[UIImageView alloc]init];
        _myImageView.contentMode = UIViewContentModeScaleAspectFill;
        _myImageView.layer.masksToBounds = YES;
    }
    return _myImageView;
}
//赞
-(UIButton *)likeButton{
    if(!_likeButton){
        _likeButton = [[UIButton alloc]init];
        [_likeButton setImage:[UIImage imageNamed:@"picture_like"] forState:UIControlStateNormal];
        [_likeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _likeButton.titleLabel.font = [UIFont systemFontOfSize:pixelValue(24)];
    }
    return _likeButton;
}
//diss
-(UIButton *)unLikeButton{
    if(!_unLikeButton){
        _unLikeButton = [[UIButton alloc]init];
        [_unLikeButton setImage:[UIImage imageNamed:@"picture_unlike"] forState:UIControlStateNormal];
        [_unLikeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _unLikeButton.titleLabel.font = [UIFont systemFontOfSize:pixelValue(24)];
    }
    return _unLikeButton;
}
//评论
-(UIButton *)commentsButton{
    if(!_commentsButton){
        _commentsButton = [[UIButton alloc]init];
        [_commentsButton setImage:[UIImage imageNamed:@"picture_comments"] forState:UIControlStateNormal];
        [_commentsButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _commentsButton.titleLabel.font = [UIFont systemFontOfSize:pixelValue(24)];
    }
    return _commentsButton;
}
//星星
-(UIButton *)starButton{
    if(!_starButton){
        _starButton = [[UIButton alloc]init];
        [_starButton setImage:[UIImage imageNamed:@"picture_star"] forState:UIControlStateNormal];
        [_starButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _starButton.titleLabel.font = [UIFont systemFontOfSize:pixelValue(24)];
    }
    return _starButton;
}
//分享按钮
-(UIButton *)shareButton{
    if(!_shareButton){
        _shareButton = [[UIButton alloc]init];
        [_shareButton setImage:[UIImage imageNamed:@"picture_share"] forState:UIControlStateNormal];
    }
    return _shareButton;
}

-(UIView *)lineView{
    if(!_lineView){
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"#DCDCDC"];
    }
    return _lineView;
}



@end
