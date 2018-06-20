//
//  MBProgressHUDGIOFixed.m
//  WMDoctor
//
//  Created by JacksonMichael on 2017/8/23.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>


@implementation UIButton (Growing_MBP_Fixed)

+(void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class clazz = NSClassFromString(@"MBProgressHUDRoundedButton");
        
        SEL originalSelector = @selector(intrinsicContentSize);
        SEL swizzledSelector = @selector(grow_intrinsicContentSize);
        
        Method originalMethod = class_getInstanceMethod(clazz, originalSelector);
        Method swizzledMethod = class_getInstanceMethod([self class], swizzledSelector);
        
        BOOL didAddMethod =
        class_addMethod(clazz,
                        originalSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));
        
        if (didAddMethod) {
            class_replaceMethod(clazz,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (CGSize)grow_intrinsicContentSize {
    // Only show if we have associated control events
    if (self.allControlEvents == 0) return CGSizeZero;
    if ([self.allTargets count] == 1 && [NSStringFromClass([[self.allTargets anyObject] class])  isEqual: @"GrowingUIControlObserver"]){
        return CGSizeZero;
    }
    
    CGSize size = [super intrinsicContentSize];
    size.width += 20.f;
    return size;
    
    
}

@end
