//
//  WMBaseUITextField.m
//  WMDoctor
//  目前用于文本框的禁止粘贴、复制等行为
//  Created by JacksonMichael on 2017/1/3.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMBaseUITextField.h"

@implementation WMBaseUITextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


/**
 禁用文本功能选项

 @param action <#action description#>
 @param sender <#sender description#>
 @return <#return value description#>
 */
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    if (menuController) {
        [UIMenuController sharedMenuController].menuVisible = NO;
    }
    return NO;
}

@end
