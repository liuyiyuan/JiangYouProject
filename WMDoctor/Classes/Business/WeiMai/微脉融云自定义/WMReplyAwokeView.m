//
//  WMReplyAwokeView.m
//  WMDoctor
//
//  Created by xugq on 2018/3/23.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "WMReplyAwokeView.h"
#import "WMReplyMessage.h"


@interface WMReplyAwokeView()



@end


@implementation WMReplyAwokeView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView{
    UIView *bottom = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    bottom.backgroundColor = [UIColor colorWithHexString:@"f7f7f7"];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(41, 12, 1, 34)];
    line.backgroundColor = [UIColor colorWithHexString:@"CCCCCC"];
    [bottom addSubview:line];
    
    self.nameLab = [[UILabel alloc] initWithFrame:CGRectMake(line.right + 5, 8, 200, 17)];
    self.nameLab.textColor = [UIColor colorWithHexString:@"999999"];
    self.nameLab.font = [UIFont systemFontOfSize:12];
    self.nameLab.textAlignment = NSTextAlignmentLeft;
    self.nameLab.text = @"王涛";//self.name;
    [bottom addSubview:self.nameLab];
    
    self.contentLab = [[UILabel alloc] initWithFrame:CGRectMake(line.right + 5, self.nameLab.bottom + 3, kScreen_width - self.nameLab.left - 70, 20)];
    self.contentLab.textColor = [UIColor colorWithHexString:@"333333"];
    self.contentLab.font = [UIFont systemFontOfSize:14];
    self.contentLab.textAlignment = NSTextAlignmentLeft;
    self.contentLab.text = @"大家每天要多喝水，不要乱吃…";//self.content;
    [bottom addSubview:self.contentLab];
    
    [self addSubview:bottom];
}

- (void)setValueWithModel:(RCMessageModel *)model{
    self.nameLab.text = model.userInfo.name;
    RCTextMessage *message = (RCTextMessage*)model.content;
    if ([model.content isKindOfClass:[WMReplyMessage class]]) {
        WMReplyMessage *replyMessage = (WMReplyMessage *)model.content;
        self.contentLab.text = replyMessage.replyMessage;
        return;
    }
    self.contentLab.text = message.content;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
