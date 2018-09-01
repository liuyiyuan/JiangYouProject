//
//  JYHomeVideoTableViewCell.m
//  WMDoctor
//
//  Created by zhenYan on 2018/8/8.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYHomeVideoTableViewCell.h"

@implementation JYHomeVideoTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
        [self configUI];
    }
    return self;
}

-(void)configUI{
    [self.contentView addSubview:self.backView];
    [self.backView addSubview:self.backImageView];
    [self.backImageView addSubview:self.contentLabel];
    [self.backView addSubview:self.playButton];
    [self.backView addSubview:self.fromButton];
    [self.backView addSubview:self.commentsButton];
    [self.backView addSubview:self.starButton];
    [self.backView addSubview:self.shareButton];
    [self.backView addSubview:self.deletedButton];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(pixelValue(10));
        make.left.mas_equalTo(self.contentView.mas_left);
        make.right.mas_equalTo(self.contentView.mas_right);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-pixelValue(10));
        make.height.mas_equalTo(pixelValue(370));
    }];
    
    [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.backView.mas_top).offset(pixelValue(20));
        make.left.mas_equalTo(self.backView.mas_left).offset(pixelValue(20));
        make.right.mas_equalTo(self.backView.mas_right).offset(-pixelValue(20));
        make.height.mas_equalTo(pixelValue(274));
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.backImageView.mas_top).offset(pixelValue(20));
        make.left.mas_equalTo(self.backImageView.mas_left).offset(pixelValue(20));
        make.right.mas_equalTo(self.backImageView.mas_right).offset(-pixelValue(20));
    }];
    
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.backImageView.mas_centerX);
        make.centerY.mas_equalTo(self.backImageView.mas_centerY);
        make.width.mas_equalTo(pixelValue(91));
        make.height.mas_equalTo(pixelValue(89));
    }];
    
    [self.fromButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.backImageView.mas_left);
        make.top.mas_equalTo(self.backImageView.mas_bottom).offset(pixelValue(20));
        make.height.mas_equalTo(pixelValue(26));
        make.bottom.mas_equalTo(self.backView.mas_bottom).offset(-pixelValue(20));
    }];
    
    [self.deletedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.backImageView.mas_right);
        make.top.mas_equalTo(self.fromButton.mas_top);
        make.width.height.mas_equalTo(self.fromButton.mas_height);
        
    }];
    
    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.fromButton.mas_top);
        make.height.mas_equalTo(self.fromButton.mas_height);
        make.right.mas_equalTo(self.deletedButton.mas_left).offset(-pixelValue(20));
    }];
    
    [self.starButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.fromButton.mas_top);
        make.height.mas_equalTo(self.fromButton.mas_height);
        make.right.mas_equalTo(self.shareButton.mas_left).offset(-pixelValue(20));
    }];
    
    [self.commentsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.fromButton.mas_top);
        make.height.mas_equalTo(self.fromButton.mas_height);
        make.right.mas_equalTo(self.starButton.mas_left).offset(-pixelValue(20));
    }];
    
   
    
   
    
    
    
}

-(UIView *)backView{
    if(!_backView){
        _backView = [[UIView alloc]init];
        _backView.backgroundColor = [UIColor whiteColor];
    }
    return _backView;
}

//背景图
-(UIImageView *)backImageView{
    if(!_backImageView){
        _backImageView = [[UIImageView alloc]init];
        _backImageView.image = [UIImage imageNamed:@"矩形 15"];
        _backImageView.userInteractionEnabled = YES;
    }
    return _backImageView;
}
//内容
-(UILabel *)contentLabel{
    if(!_contentLabel){
        _contentLabel = [[UILabel alloc]init];
//        _contentLabel.text =@"阿克苏的减肥啦会计师的福利卡机；都是离开房间啊；领导说会计法拉克就是打飞机啊";
        _contentLabel.font = [UIFont systemFontOfSize:pixelValue(26)];
        _contentLabel.textColor = [UIColor whiteColor];
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}
//来源
-(UIButton *)fromButton{
    if(!_fromButton){
        _fromButton = [[UIButton alloc]init];
//        [_fromButton setImage:[UIImage imageNamed:@"椭圆 4"] forState:UIControlStateNormal];
        [_fromButton setTitleColor:[UIColor colorWithHexString:@"#909090"] forState:UIControlStateNormal];
        _fromButton.titleLabel.font = [UIFont systemFontOfSize:pixelValue(24)];
    }
    return _fromButton;
}
//评论按钮
-(UIButton *)commentsButton{
    if(!_commentsButton){
        _commentsButton = [[UIButton alloc]init];
        [_commentsButton setImage:[UIImage imageNamed:@"picture_comments"] forState:UIControlStateNormal];
        [_commentsButton setTitle:@"3003" forState:UIControlStateNormal];
        [_commentsButton setTitleColor:[UIColor colorWithHexString:@"#909090"] forState:UIControlStateNormal];
    }
    return _commentsButton;
}
//星按钮
-(UIButton *)starButton{
    if(!_starButton){
        _starButton = [[UIButton alloc]init];
        [_starButton setImage:[UIImage imageNamed:@"picture_star"] forState:UIControlStateNormal];
        [_starButton setTitle:@"100" forState:UIControlStateNormal];
        [_starButton setTitleColor:[UIColor colorWithHexString:@"#909090"] forState:UIControlStateNormal];
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
//删除按钮
-(UIButton *)deletedButton{
    if(!_deletedButton){
        _deletedButton = [[UIButton alloc]init];
        [_deletedButton setBackgroundImage:[UIImage imageNamed:@"channel_edit_delete"] forState:UIControlStateNormal];
    }
    return _deletedButton;
}

//播放按钮
-(UIButton *)playButton{
    if(!_playButton){
        _playButton = [[UIButton alloc]init];
        [_playButton setBackgroundImage:[UIImage imageNamed:@"button_play"] forState:UIControlStateNormal];
    }
    return _playButton;
}

@end
