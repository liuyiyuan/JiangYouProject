//
//  WMAskADoctorAwokeView.m
//  WMDoctor
//
//  Created by xugq on 2017/11/20.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMAskADoctorAwokeView.h"
#import "WMTabBarController.h"
#import "WMNavgationController.h"


@implementation WMAskADoctorAwokeView



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView{
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_width, SafeAreaTopHeight)];
    self.topView.backgroundColor = [UIColor blackColor];
    self.topView.alpha = 0.7;
    [[UIApplication sharedApplication].keyWindow addSubview:self.topView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreen_width, self.height)];
    NSLog(@"图片高：%f", imageView.top);
    imageView.image = [UIImage imageNamed:@"awokeDoctorNew"];
    imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tag = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDismiss)];
    [imageView addGestureRecognizer:tag];
    [self addSubview:imageView];
}

- (void)imageViewDismiss
{
    if ([self.window.rootViewController isKindOfClass:[WMTabBarController class]]){
        
    }
    [self removeFromSuperview];
    if (self.topView) {
        [self.topView removeFromSuperview];
    }
    [[RCIMClient sharedRCIMClient] clearMessagesUnreadStatus:ConversationType_PRIVATE targetId:self.model.targetId];
}

- (void)dealloc{
    NSLog(@"WMAskADoctorAwokeView dealloc");
}

@end
