//
//  UISearchBar+WMLeftPlaceholder.m
//  WMDoctor
//
//  Created by xugq on 2018/5/11.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "UISearchBar+WMLeftPlaceholder.h"

@implementation UISearchBar (WMLeftPlaceholder)

- (void)setLeftPlaceholder:(NSString *)placeholder{
    self.placeholder = placeholder;
    
    SEL centerSelector = NSSelectorFromString([NSString stringWithFormat:@"%@%@", @"setCenter", @"Placeholder:"]);
    if ([self respondsToSelector:centerSelector]) {
        NSMethodSignature *signature = [[UISearchBar class] instanceMethodSignatureForSelector:centerSelector];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setTarget:self];
        [invocation setSelector:centerSelector];
        [invocation invoke];
    }
}

@end
