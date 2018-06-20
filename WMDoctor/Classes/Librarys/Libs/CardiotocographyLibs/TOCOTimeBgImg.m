//
//  TOCOTimeBgImg.m
//  OctobarGoodBaby
//
//  Created by 莱康宁 on 16/4/22.
//  Copyright © 2016年 luckcome. All rights reserved.
//

#import "TOCOTimeBgImg.h"
#import "Masonry.h"

@implementation TOCOTimeBgImg
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _timeLable = [[UILabel alloc] init];
        _timeLable.font = [UIFont systemFontOfSize:8];
        // _timeLable.backgroundColor = [UIColor redColor];
        //        _timeLable.textAlignment = NSTextAlignmentCenter;
        [self  addSubview:_timeLable];
        [_timeLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right);
            make.bottom.equalTo(self.mas_bottom).offset(-73);
            //            make.size.equalTo(CGSizeMake(10, 10));
        }];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
