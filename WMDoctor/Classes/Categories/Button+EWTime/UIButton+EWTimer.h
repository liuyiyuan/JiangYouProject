//
//  UIButton+EWTimer.h
//  EasyWallet
//
//  Created by GQLEE on 2018/3/7.
//  Copyright © 2018年 GQLEE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (EWTimer)

- (void)startCountDownTime:(int)time withCountDownBlock:(void(^)(void))countDownBlock;

@end
