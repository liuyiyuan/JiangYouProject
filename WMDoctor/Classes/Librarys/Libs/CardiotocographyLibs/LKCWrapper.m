//
//  LKCWrapper.m
//  OctobarBaby
//
//  Created by lazy-thuai on 14-6-9.
//  Copyright (c) 2014年 luckcome. All rights reserved.
//

#import "LKCWrapper.h"

@interface LKCWrapper ()

@property (nonatomic) BOOL showChangeNameView;
@property (nonatomic) BOOL isKeyboardShow;

@end

#define UserDefaults                        [NSUserDefaults standardUserDefaults]
#define NotificationCenter                  [NSNotificationCenter defaultCenter]

@implementation LKCWrapper

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        [NotificationCenter addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
        [NotificationCenter addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
    [NotificationCenter removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [NotificationCenter removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}

//showView调用，设置弹出对话框的大小
- (void)layoutSubviews
{
    [super layoutSubviews];
    NSArray *subViews = [self subviews];
    for (UIView *subView in subViews) {
        CGFloat centerX = ceil(self.bounds.size.width / 2);
        CGFloat centerY = ceil(self.bounds.size.height / 2) - 10;
        subView.center = CGPointMake(centerX, centerY);
    }
}

//showView_he调用，设置弹出对话框的大小//历史界面批量删除用
- (void)layoutSubviews_he
{
    [super layoutSubviews];
    NSArray *subViews = [self subviews];
    for (UIView *subView in subViews) {
        CGFloat centerX = ceil(self.bounds.size.width / 2);
        CGFloat centerY = ceil(self.bounds.size.height - 25);
        subView.center = CGPointMake(centerX, centerY);
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    if (self.maskType == WrapperMaskTypeTouchDisable) {
        return;
    }
    
    if (self.showChangeNameView && self.isKeyboardShow) {
        [self endEditing:YES];
        return;
    }
    
    // remove subview from super view when touch begin
    NSArray *subViews = [self subviews];
    for (UIView *subView in subViews) {
        [subView removeFromSuperview];
    }
    self.hidden = YES;
}

- (void)showDatePickerView:(UIView *)view
{
    self.maskType = WrapperMaskTypeTouchEnable;
    [self showView:view];
}

- (void)dismissDatePickerView:(UIView *)view
{
    [self dismissView:view];
}

//点击姓名时调用
- (void)showChangeNameView:(UIView *)view
{
    self.maskType = WrapperMaskTypeTouchEnable;
    self.showChangeNameView = YES;
    [self showView:view];
}

- (void)dismissChangeNameView:(UIView *)view
{
    [self dismissView:view];
}

//showDatePickerView、showChangeNameView调用
- (void)showView:(UIView *)view
{
    [self addSubview:view];
    view.hidden = NO;
    self.hidden = NO;
    [self layoutSubviews];
}
//历史界面中批量删除用
- (void)showView_he:(UIView *)view
{
    [self addSubview:view];
    view.hidden = NO;
    self.hidden = NO;
    [self layoutSubviews_he];
}

- (void)dismissView:(UIView *)view
{
    [view removeFromSuperview];
    self.hidden = YES;
}

//退出弹出窗口
- (void)dismiss
{
    NSArray *subViews = self.subviews;
    for (UIView *subView in subViews) {
        [subView removeFromSuperview];
    }
    self.hidden = YES;
}

- (void)showNewView:(UIView *)newView andDismissOldView:(UIView *)oldView
{
    [oldView removeFromSuperview];
    
    [self addSubview:newView];
    [self layoutSubviews];
}

#pragma mark - Keyboard Show or Hide Notification

- (void)keyboardDidShow:(NSNotification *)notice
{
    self.isKeyboardShow = YES;
}

- (void)keyboardDidHide:(NSNotification *)notice
{
    self.isKeyboardShow = NO;
}

- (void)showView:(UIView *)view andDismissDelay:(NSTimeInterval)duration
{
    view.alpha= 0;
    [self addSubview:view];
    [UIView animateWithDuration:0.5 animations:^{
        self.hidden = NO;//动画的执行效果
   //     view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed: @"弹框"]];
   //     view.frame = CGRectMake(0, 0, 282, 191);
        view.backgroundColor = [UIColor whiteColor];
        view.layer.cornerRadius = 10.0;
        view.layer.masksToBounds = YES;
        view.alpha = 1;//0.5s后变为可见
        
    }
    completion:^(BOOL finished) {//动画结束后执行的代码
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.5 animations:^{
                view.alpha = 0;
                self.hidden = YES;
            }
    completion:^(BOOL finished) {
                [view removeFromSuperview];
            }];
        });
    }];
}

- (UIView*)showMessage:(NSString*)message  andDismissDelay:(NSTimeInterval)duration
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 246, 60)];
    label.backgroundColor = [UIColor colorWithRed:187/255.0 green:182/255.0 blue:214/255.0 alpha:1];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = message;
    [self showView:label andDismissDelay:duration];
    return label;

}

@end
