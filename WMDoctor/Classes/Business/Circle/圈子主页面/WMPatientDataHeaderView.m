//
//  WMDoctorHomepageHeaderView.m
//  Micropulse
//
//  Created by xugq on 2017/7/12.
//  Copyright © 2017年 iChoice. All rights reserved.
//

#import "WMPatientDataHeaderView.h"
#import "UIImageView+WebCache.h"


@interface WMPatientDataHeaderView()



@end

@implementation WMPatientDataHeaderView


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews{
    
    self.backgroundColor = [UIColor whiteColor];
    float headerImageView_w = 50;
    float headerImageView_h = headerImageView_w;
    float headerImageView_x = 15;
    float headerImageView_y = (self.frame.size.height - headerImageView_h) / 2;
    
    _headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(headerImageView_x, headerImageView_y, headerImageView_w, headerImageView_h)];
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:@""]];
    _headerImageView.userInteractionEnabled = YES;
    _headerImageView.layer.masksToBounds = YES;
    _headerImageView.layer.cornerRadius = headerImageView_w / 2;
    [self addSubview:_headerImageView];
    
    _name = [[UILabel alloc] initWithFrame:CGRectMake(80, 24, kScreen_width - 100, 22)];
    _name.textColor = [UIColor colorWithHexString:@"333333"];
    _name.font = [UIFont systemFontOfSize:16];
    [self addSubview:_name];
    
    if (_department) {
        [_department removeFromSuperview];
    }
    _department = [[UILabel alloc] initWithFrame:CGRectMake(80, _name.frame.origin.y + _name.frame.size.height + 4, _name.frame.size.width, 22)];
    _department.textColor = [UIColor colorWithHexString:@"999999"];
    _department.font = [UIFont systemFontOfSize:12];
    [self addSubview:_department];
}


- (void)dealloc{
    NSLog(@"WMDoctorHomepageHeaderViewDealloc");
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
