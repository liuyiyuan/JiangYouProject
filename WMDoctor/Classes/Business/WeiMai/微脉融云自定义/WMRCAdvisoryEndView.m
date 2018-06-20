//
//  WMRCAdvisoryEndView.m
//  WMDoctor
//
//  Created by 茭白 on 2017/1/10.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMRCAdvisoryEndView.h"
@implementation WMRCAdvisoryEndView

- (id)initWithFrame:(CGRect)frame withType:(WMRCAdvisoryEndViewType)type{
    self=[super initWithFrame:frame];
    if (self) {
        
        switch (type) {
            case WMRCAdvisoryEndViewTypeFollowUp:{
                [self setupFollowUp];
            }
                break;
            case WMRCAdvisoryEndViewTypeSayHello:{
                 [self setupSayHelloView];
            }
            default:
                break;
        }
        
       
        
    }
    return self;
}
//- (id)init
//{
//    self = [super init];
//    if (self) {
//        [self setupFollowUp];
//    }
//    return self;
//}
-(void)setupFollowUp{
    //创建挡板
    self.followUpButton=[UIButton buttonWithType:UIButtonTypeCustom];
    
    self.followUpButton.frame=CGRectMake(0,0,kScreen_width,50);
    [self.followUpButton setTitle:@"随访" forState:UIControlStateNormal];
    self.followUpButton.backgroundColor=[UIColor colorWithHexString:@"3d94ea"];
    [self.followUpButton addTarget:self action:@selector(followUpAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_followUpButton];

}
-(void)setupSayHelloView{
    //创建挡板
    self.sayHelloButton=[UIButton buttonWithType:UIButtonTypeCustom];
    
    self.sayHelloButton.frame=CGRectMake(0,0,kScreen_width,50);
    [self.sayHelloButton setTitle:@"联系TA" forState:UIControlStateNormal];
    self.sayHelloButton.backgroundColor=[UIColor colorWithHexString:@"3d94ea"];
    [self.sayHelloButton addTarget:self action:@selector(sayHelloAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.sayHelloButton];
}
-(void)followUpAction:(UIButton *)button{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(followUpWithButton:)]) {
        //self.hidden=YES;
        [self.delegate followUpWithButton:button];
    }
}
-(void)sayHelloAction:(UIButton *)button{
    if (self.delegate && [self.delegate respondsToSelector:@selector(sayHelloWithButton:)]) {
        //self.hidden=YES;
        [self.delegate sayHelloWithButton:button];
    }

}
- (void)hiddenView
{
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [self removeFromSuperview];
}

@end
