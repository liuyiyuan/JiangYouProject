//
//  JYAboutUsTableViewCell.m
//  WMDoctor
//
//  Created by jiangqi on 2018/6/27.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYAboutUsTableViewCell.h"

@implementation JYAboutUsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        // cell 的一些设置 布局
        [self setUpSubViews];
    }
    return self;
}

-(void)setUpSubViews{
    [self.contentView addSubview:self.typeLabel];
    [self.contentView addSubview:self.arrowImageView];
    [self.contentView addSubview:self.versionLabel];
    [self.contentView addSubview:self.lineView];
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(pixelValue(20));
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(pixelValue(44));
    }];
    
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-pixelValue(30));
        make.top.mas_equalTo(pixelValue(34));
        make.width.mas_equalTo(pixelValue(19));
        make.height.mas_equalTo(pixelValue(32));
    }];
    
    [self.versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.right.mas_equalTo(self.arrowImageView.mas_left).offset(-pixelValue(15));
        make.height.mas_equalTo(pixelValue(30));
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(pixelValue(0));
        make.height.mas_equalTo(pixelValue(4));
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
    
}


-(UILabel *)typeLabel{
    if(!_typeLabel){
        _typeLabel = [[UILabel alloc]init];
        _typeLabel.font = [UIFont systemFontOfSize:pixelValue(30)];
        _typeLabel.textColor = [UIColor blackColor];
    }
    return _typeLabel;
}
-(UIImageView *)arrowImageView{
    if(!_arrowImageView){
        _arrowImageView = [[UIImageView alloc]init];
        _arrowImageView.image = [UIImage imageNamed:@"table_arrow"];
    }
    return _arrowImageView;
}

-(UILabel *)versionLabel{
    if(!_versionLabel){
        _versionLabel = [[UILabel alloc]init];
        _versionLabel.text = @"V1.0.0";
        _versionLabel.textColor = [UIColor blackColor];
    }
    return _versionLabel;
}

-(UIView *)lineView{
    if(!_lineView){
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    }
    return _lineView;
}


@end
