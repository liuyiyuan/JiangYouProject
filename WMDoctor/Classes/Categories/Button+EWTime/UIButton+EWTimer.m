//
//  UIButton+EWTimer.m
//  EasyWallet
//
//  Created by GQLEE on 2018/3/7.
//  Copyright © 2018年 GQLEE. All rights reserved.
//

#import "UIButton+EWTimer.h"

static NSString *eWTempText;

@implementation UIButton (EWTimer)

- (void)startCountDownTime:(int)time withCountDownBlock:(void(^)(void))countDownBlock{
    
    [self initButtonData];
    
    [self startTime:time];
    
    if (countDownBlock) {
        countDownBlock();
    }
}

- (void)initButtonData{
    
    eWTempText = @"重新获取";
//    [NSString stringWithFormat:@"%@",self.titleLabel.text];
    
}

- (void)startTime:(int)time{
    
    __block int timeout = time;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0 * NSEC_PER_SEC, 0);
    
    WS(weakSelf)
    dispatch_source_set_event_handler(_timer, ^{
        
        //倒计时结束
        if(timeout <= 0){
            
            dispatch_source_cancel(_timer);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [weakSelf setTitle:eWTempText forState:UIControlStateNormal];
                weakSelf.userInteractionEnabled = YES;
                [weakSelf setTitleColor:[UIColor colorWithHexString:@"#138CFF"] forState:UIControlStateNormal];
            });
            
        }else{
            NSString *text = [NSString stringWithFormat:@"%02ds",timeout];
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.userInteractionEnabled = NO;
                [weakSelf setTitle:text forState:UIControlStateNormal];
                [weakSelf setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [weakSelf setBackgroundColor:[UIColor colorWithHexString:@"#cccccc"]];
            });
            
            timeout --;
            
        }
        
    });
    
    dispatch_resume(_timer);
    
}
@end
