//
//  WMSixFunctionView.m
//  WMDoctor
//
//  Created by JacksonMichael on 2018/2/2.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "WMSixFunctionView.h"

@interface WMSixFunctionView ()
{
    NSArray *_array;
}

@end

@implementation WMSixFunctionView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //do something
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)sixViewMakeViewWithArray:(NSArray *)modelArray{
    _array = [NSArray arrayWithArray:modelArray];
    self.backgroundColor = [UIColor whiteColor];
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    LoginModel * loginModel = [WMLoginCache getMemoryLoginModel];
//    for (NSInteger i = 0; i<modelArray.count; i++) {
    for (NSInteger i = 0; i<6; i++) {        //解决UI边框问题
        if (i >= modelArray.count) {
            UIView * sixView = [[UIView alloc]initWithFrame:CGRectMake((i%3)*(kScreen_width/3), (i<3)?0:92, kScreen_width/3, 92)];
            sixView.layer.borderColor = [UIColor colorWithHexString:@"f0f0f0"].CGColor;
            sixView.layer.borderWidth = 0.5f;
            [self addSubview:sixView];
            break;
        }
        WMFunctionEntries * entriesModel = modelArray[i];
        UIView * sixView = [[UIView alloc]initWithFrame:CGRectMake((i%3)*(kScreen_width/3), (i<3)?0:92, kScreen_width/3, 92)];
        sixView.layer.borderColor = [UIColor colorWithHexString:@"f0f0f0"].CGColor;
        sixView.layer.borderWidth = 0.5f;
        
        
        //icon
        UIImageView * iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 24, 24)];
        iconImage.center = CGPointMake((kScreen_width/3)/2, 23+12);
        [iconImage sd_setImageWithURL:[NSURL URLWithString:entriesModel.icon]];
        
        //label
        UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 22)];
        titleLabel.center = CGPointMake(kScreen_width/3/2, 92-15-10);
        titleLabel.textColor = [UIColor colorWithHexString:@"666666"];
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = entriesModel.name;
        
        [sixView addSubview:titleLabel];
        [sixView addSubview:iconImage];
        
        
        //暂不显示hot
//        if ([entriesModel.hot isEqualToString:@"1"]) {
//            UIImageView * hotImage = [[UIImageView alloc]initWithFrame:CGRectMake(kScreen_width/3/2+12, 10, 26, 13)];
//            hotImage.image = [UIImage imageNamed:@"ic_hot"];
//
//            [sixView addSubview:hotImage];
//        }
        
        BOOL redPoint = [[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"functionCode%@%@",entriesModel.code,loginModel.phone]];
        NSLog(@"code:%@",entriesModel.code);
        
        if (redPoint) {
            UIImageView * redImage = [[UIImageView alloc]initWithFrame:CGRectMake(kScreen_width/3/2+12, 15, 8, 8)];
            redImage.image = [UIImage imageNamed:@"ic_xiaoxitishi"];
            
            [sixView addSubview:redImage];
        }
        
        
        
        [self addSubview:sixView];
        
//        if ([entriesModel.openFlag isEqualToString:@"1"]) {       //此处为了给出提示。
            //btn
            UIButton * btn = [[UIButton alloc]initWithFrame:sixView.frame];
            btn.backgroundColor = [UIColor clearColor];
            btn.tag = i;
            [btn addTarget:self action:@selector(clickSixEntran:) forControlEvents:UIControlEventTouchUpInside];
        
            btn.adjustsImageWhenHighlighted = NO;
            [self addSubview:btn];
//        }
        
        
    }
}


- (void)clickSixEntran:(UIButton *)button{
    
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        button.enabled = YES;
    });
    
    WMFunctionEntries *model = _array[button.tag];
    if (_delegate&&[_delegate respondsToSelector:@selector(clickSixEntran:)]) {
        [self.delegate clickSixEntran:model];
        button.enabled = NO;
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
