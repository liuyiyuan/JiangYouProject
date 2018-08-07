//
//  JYWelfareCell.m
//  WMDoctor
//
//  Created by xugq on 2018/8/6.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYWelfareCell.h"

@implementation JYWelfareCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView{
    self.contentView.backgroundColor = [UIColor whiteColor];
    UIButton *redPacketBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    redPacketBtn.frame = CGRectMake(10, 10, (kScreenWidth - 40) / 2, 40);
    redPacketBtn.backgroundColor = [UIColor colorWithHexString:@"#FE2C5B"];
    redPacketBtn.layer.masksToBounds = YES;
    redPacketBtn.layer.cornerRadius = 6;
    [redPacketBtn addTarget:self action:@selector(redPacketBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:redPacketBtn];
    
    [redPacketBtn addSubview:[self createImageViewWithName:@"welfareRedpacket"]];
    [redPacketBtn addSubview:[self createLabelWithtext:@"每日领红包"]];
    
    UIButton *couponBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    couponBtn.frame = CGRectMake(kScreenWidth / 2 + 10, 10, (kScreenWidth - 40) / 2, 40);
    couponBtn.backgroundColor = [UIColor colorWithHexString:@"#FE2C5B"];
    couponBtn.layer.masksToBounds = YES;
    couponBtn.layer.cornerRadius = 6;
    [couponBtn addTarget:self action:@selector(couponsBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [couponBtn addSubview:[self createImageViewWithName:@"welfareCoupon"]];
    [couponBtn addSubview:[self createLabelWithtext:@"超值抵扣卷"]];
    [self.contentView addSubview:couponBtn];
    
    
    
}

- (UIImageView *)createImageViewWithName:(NSString *)name{
    UIImageView *redpacketImgView = [[UIImageView alloc] initWithFrame:CGRectMake(25, 5, 36, 31)];
    redpacketImgView.image = [UIImage imageNamed:name];
    return redpacketImgView;
}

- (UILabel *)createLabelWithtext:(NSString *)text{
    UILabel *redpacketLabel = [[UILabel alloc] initWithFrame:CGRectMake(64, 13, 80, 15)];
    redpacketLabel.text = text;
    redpacketLabel.font = [UIFont systemFontOfSize:15];
    redpacketLabel.textColor = [UIColor whiteColor];
    return redpacketLabel;
}

- (void)redPacketBtnClickAction:(UIButton *)button{
    NSLog(@"redpacket");
}

- (void)couponsBtnClickAction:(UIButton *)button{
    NSLog(@"couponse");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
