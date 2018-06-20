//
//  LKCWrapper.h
//  OctobarBaby
//
//  Created by lazy-thuai on 14-6-9.
//  Copyright (c) 2014年 luckcome. All rights reserved.
//

//弹出对话框,如“修改姓名”、“确定吗等”
//应该是列表显示，区别于THWrapedView

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, WrapperMaskType) {
    WrapperMaskTypeTouchEnable,
    WrapperMaskTypeTouchDisable
};

@interface LKCWrapper : UIView

@property (nonatomic, assign) WrapperMaskType maskType;

- (void)showDatePickerView:(UIView *)view;
- (void)dismissDatePickerView:(UIView *)view;

- (void)showChangeNameView:(UIView *)view;
- (void)dismissChangeNameView:(UIView *)view;

- (void)showView:(UIView *)view;
- (void)showView_he:(UIView *)view;
- (void)dismissView:(UIView *)view;

// dismiss self and it's subviews
- (void)dismiss;

- (void)showNewView:(UIView *)newView andDismissOldView:(UIView *)oldView;

- (void)showView:(UIView *)view andDismissDelay:(NSTimeInterval)duration;
- (UIView*)showMessage:(NSString*)message  andDismissDelay:(NSTimeInterval)duration;
//-(void) disptips:(NSString*)text andDismissDelay:(NSTimeInterval)duration;

@end
