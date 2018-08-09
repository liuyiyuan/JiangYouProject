//
//  JYHomeBBSTableViewCell.m
//  WMDoctor
//
//  Created by zhenYan on 2018/8/9.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYHomeBBSTableViewCell.h"

@implementation JYHomeBBSTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self configUI];
        
    }
    return self;
}

-(void)configUI{
    [self.contentView addSubview:self.myImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.hasAddLabel];
    [self.contentView addSubview:self.addButton];
    [self.contentView addSubview:self.lineView];
    [self.myImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(pixelValue(30));
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.width.height.mas_equalTo(pixelValue(70));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.myImageView.mas_top);
        make.left.mas_equalTo(self.myImageView.mas_right).offset(pixelValue(20));
        make.height.mas_equalTo(pixelValue(35));
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_left);
        make.bottom.mas_equalTo(self.myImageView.mas_bottom);
        make.height.mas_equalTo(pixelValue(15));
    }];
    
    [self.hasAddLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-pixelValue(30));
        make.height.mas_equalTo(pixelValue(30));
    }];
    
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-pixelValue(30));
        make.width.height.mas_equalTo(pixelValue(60));
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(pixelValue(0));
        make.right.mas_equalTo(pixelValue(0));
        make.height.mas_equalTo(pixelValue(1));
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
}
//图片
-(UIImageView *)myImageView{
    if(!_myImageView){
        _myImageView = [[UIImageView alloc]init];
    }
    return _myImageView;
}
//标题
-(UILabel *)titleLabel{
    if(!_titleLabel){
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:pixelValue(28)];
    }
    return _titleLabel;
}
//内容
-(UILabel *)contentLabel{
    if(!_contentLabel){
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.textColor = [UIColor colorWithHexString:@"#9D9C9D"];
        _contentLabel.font = [UIFont systemFontOfSize:pixelValue(24)];
    }
    return _contentLabel;
}
//已关注
-(UILabel *)hasAddLabel{
    if(!_hasAddLabel){
        _hasAddLabel = [[UILabel alloc]init];
        _hasAddLabel.textColor = [UIColor colorWithHexString:@"#9D9C9D"];
        _hasAddLabel.font = [UIFont systemFontOfSize:pixelValue(24)];
        _hasAddLabel.text = @"已关注";
    }
    return _hasAddLabel;
}
//关注按钮
-(UIButton *)addButton{
    if(!_addButton){
        _addButton = [[UIButton alloc]init];
        [_addButton setBackgroundImage:[UIImage imageNamed:@"JY_BBS_add"] forState:UIControlStateNormal];
    }
    return _addButton;
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
