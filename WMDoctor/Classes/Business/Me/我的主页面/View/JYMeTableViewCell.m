//
//  JYMeTableViewCell.m
//  WMDoctor
//
//  Created by jiangqi on 2018/6/25.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYMeTableViewCell.h"

@implementation JYMeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // cell 的一些设置 布局
        [self setUpSubViews];
    }
    return self;
}

-(void)setUpSubViews{
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.typeLabel];
    [self.contentView addSubview:self.arrowImageView];
    [self.contentView addSubview:self.lineView];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(pixelValue(30));
        make.top.mas_equalTo(pixelValue(28));
        make.width.height.mas_equalTo(pixelValue(44));
    }];
    
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImageView.mas_right).offset(pixelValue(20));
        make.top.mas_equalTo(self.iconImageView.mas_top);
        make.height.mas_equalTo(pixelValue(44));
    }];
    
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-pixelValue(30));
        make.top.mas_equalTo(pixelValue(34));
        make.width.mas_equalTo(pixelValue(19));
        make.height.mas_equalTo(pixelValue(32));
    }];
    
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(pixelValue(0));
        make.right.mas_equalTo(pixelValue(0));
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.height.mas_equalTo(pixelValue(2));
    }];
}

-(UIImageView *)iconImageView{
    if(!_iconImageView){
        _iconImageView = [[UIImageView alloc]init];
        
    }
    return _iconImageView;
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

-(UIView *)lineView{
    if(!_lineView){
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
        _lineView.hidden = YES;
    }
    return _lineView;
}
@end
