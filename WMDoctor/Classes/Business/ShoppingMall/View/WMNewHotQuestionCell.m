//
//  WMNewHotQuestionCell.m
//  Micropulse
//
//  Created by 王攀登 on 2018/3/22.
//  Copyright © 2018年 iChoice. All rights reserved.
//

#import "WMNewHotQuestionCell.h"

#import <Masonry.h>

@interface WMNewHotQuestionCell ()

@property (nonatomic, strong) UILabel *topLogoLabel;
@property (nonatomic, strong) UILabel *bottomLogoLabel;
@property (nonatomic, strong) UILabel *topContentLabel;
@property (nonatomic, strong) UILabel *bottomContentLabel;

@end

@implementation WMNewHotQuestionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews
{
    self.contentView.backgroundColor = [UIColor clearColor];
    
    self.topLogoLabel          = [UILabel new];
    self.topLogoLabel.backgroundColor = [UIColor colorWithHexString:@"FFF7F1"];
    self.topLogoLabel.font            = [UIFont systemFontOfSize:10.f];
    self.topLogoLabel.textAlignment   = NSTextAlignmentCenter;
    self.topLogoLabel.layer.masksToBounds = YES;
    self.topLogoLabel.layer.cornerRadius  = 2;
    self.topLogoLabel.layer.borderWidth = 0.5;
    self.topLogoLabel.layer.borderColor = [[UIColor colorWithHexString:@"FF8633"] CGColor];
    self.topLogoLabel.textColor         = [UIColor colorWithHexString:@"FF8633"];
    self.topLogoLabel.text              = @"热文";
    [self.contentView addSubview:self.topLogoLabel];
    self.bottomLogoLabel       = [UILabel new];
    self.bottomLogoLabel.backgroundColor = [UIColor colorWithHexString:@"FFF7F1"];
    self.bottomLogoLabel.font            = [UIFont systemFontOfSize:10.f];
    self.bottomLogoLabel.textAlignment   = NSTextAlignmentCenter;
    self.bottomLogoLabel.layer.masksToBounds = YES;
    self.bottomLogoLabel.layer.cornerRadius  = 2;
    self.bottomLogoLabel.layer.borderWidth = 0.5;
    self.bottomLogoLabel.layer.borderColor = [[UIColor colorWithHexString:@"FF8633"] CGColor];
    self.bottomLogoLabel.textColor         = [UIColor colorWithHexString:@"FF8633"];
    self.bottomLogoLabel.text              = @"最新";
    [self.contentView addSubview:self.bottomLogoLabel];
    
    self.topContentLabel                 = [UILabel new];
    self.topContentLabel.font            = [UIFont systemFontOfSize:13.f];
    self.topContentLabel.textColor       = [UIColor colorWithHexString:@"666666"];
    [self.contentView addSubview:self.topContentLabel];
    self.bottomContentLabel                 = [UILabel new];
    self.bottomContentLabel.font            = [UIFont systemFontOfSize:13.f];
    self.bottomContentLabel.textColor       = [UIColor colorWithHexString:@"666666"];
    [self.contentView addSubview:self.bottomContentLabel];
}

// 问答
- (void)configHotQaNum:(NSString *)qaNum content:(NSString *)content {
    self.topContentLabel.text = qaNum;
    self.bottomContentLabel.text = content;
}

// 热门咨询
- (void)configHotTopContent:(NSString *)topContent bottomContent:(NSString *)bottomContent {
    self.topContentLabel.text = topContent;
    self.bottomContentLabel.text = bottomContent;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.isHotQa) {
        self.topContentLabel.textColor = [UIColor orangeColor];
        [self.topLogoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(0.0f, 0.0f));
        }];
        [self.bottomLogoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(0.0f, 0.0f));
        }];
        [self.topContentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10.0f);
            make.top.offset(4.0f);
            make.right.equalTo(self.contentView.mas_right).offset(-10.0f);
        }];
        [self.bottomContentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.topContentLabel);
            make.top.equalTo(self.topContentLabel.mas_bottom).offset(2.0f);
            make.right.equalTo(self.topContentLabel.mas_right);
        }];
    }else {
        self.topContentLabel.textColor = [UIColor colorWithHexString:@"666666"];
        [self.topLogoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10.0f);
            make.top.offset(4.0f);
            make.size.mas_equalTo(CGSizeMake(24.0f, 13.0f));
        }];
        [self.bottomLogoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10.0f);
            make.top.equalTo(self.topLogoLabel.mas_bottom).offset(7.0f);
            make.size.equalTo(self.topLogoLabel);
        }];
        [self.topContentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.topLogoLabel.mas_right).offset(4.0f);
            make.centerY.equalTo(self.topLogoLabel);
            make.right.equalTo(self.contentView.mas_right).offset(-10.0f);
        }];
        [self.bottomContentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.topContentLabel);
            make.centerY.equalTo(self.bottomLogoLabel);
            make.right.equalTo(self.topContentLabel.mas_right);
        }];
    }
}

@end
