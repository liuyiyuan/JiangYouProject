//
//  WMRCConversationHeaderView.m
//  WMDoctor
//
//  Created by 茭白 on 2017/1/18.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMRCConversationHeaderView.h"

@implementation WMRCConversationHeaderView
- (id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self setupViewWithFrame:frame];
    }
    return self;
}
-(void)setupViewWithFrame:(CGRect)frame{
    UIView  *view=[[UIView alloc]init];
    view.frame=CGRectMake(0, 0, kScreen_width, 36);
    
    [self addSubview:view];
    
    self.healthRecordBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    self.healthRecordBtn.frame=CGRectMake(0, 0, kScreen_width*0.5, 34);
    [self.healthRecordBtn setTitle:@"聊天" forState:UIControlStateNormal];
    self.healthRecordBtn.backgroundColor=[UIColor whiteColor];
    [self.healthRecordBtn setTitleColor:[UIColor colorWithHexString:@"18A2FF"] forState:UIControlStateNormal];
    [self.healthRecordBtn addTarget:self action:@selector(healthRecordClick:) forControlEvents:UIControlEventTouchUpInside];
    self.healthRecordBtn.titleLabel.font=[UIFont systemFontOfSize:14.0];
    [view addSubview:self.healthRecordBtn];
    
    self.chatBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    self.chatBtn.frame=CGRectMake(kScreen_width*0.5, 0, kScreen_width*0.5, 34);
    [self.chatBtn setTitle:@"今日医声" forState:UIControlStateNormal];
    self.chatBtn.backgroundColor=[UIColor whiteColor];
    [self.chatBtn setTitleColor:[UIColor colorWithHexString:@"1a1a1a"] forState:UIControlStateNormal];
    [self.chatBtn addTarget:self action:@selector(chatClick:) forControlEvents:UIControlEventTouchUpInside];
    self.chatBtn.titleLabel.font=[UIFont systemFontOfSize:14.0];
    
    [view addSubview:self.chatBtn];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 35, kScreen_width, 1)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"E5E5E5"];
    [view addSubview:lineView];
    
    self.redLabel=[[UILabel alloc]init];
    self.redLabel.frame=CGRectMake( self.healthRecordBtn.frame.origin.x,34, kScreen_width*0.5, 2);
    
    self.redLabel.backgroundColor=[UIColor colorWithHexString:@"3d94ea"];
    [view addSubview:self.redLabel];
}


-(void)healthRecordClick:(UIButton *)button{
    [self.healthRecordBtn setTitleColor:[UIColor colorWithHexString:@"18A2FF"] forState:UIControlStateNormal];
    [self.chatBtn setTitleColor:[UIColor colorWithHexString:@"1a1a1a"] forState:UIControlStateNormal];
    if (self.delegate &&[self.delegate respondsToSelector:@selector(healthRecordAction:)]) {
        self.redLabel.frame=CGRectMake( button.frame.origin.x,34, kScreen_width*0.5, 2);
        [self.delegate healthRecordAction:button];
    }
}
-(void)chatClick:(UIButton *)button{
    [self.healthRecordBtn setTitleColor:[UIColor colorWithHexString:@"1a1a1a"] forState:UIControlStateNormal];
    [self.chatBtn setTitleColor:[UIColor colorWithHexString:@"18A2FF"] forState:UIControlStateNormal];
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatAction:)]) {
        self.redLabel.frame=CGRectMake( button.frame.origin.x,34, kScreen_width*0.5, 2);
        [self.delegate chatAction:button];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
