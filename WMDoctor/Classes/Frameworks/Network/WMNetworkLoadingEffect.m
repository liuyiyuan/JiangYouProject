//
//  WMNetworkLoadingEffect.m
//  Micropulse
//
//  Created by zhangchaojie on 16/4/1.
//  Copyright © 2016年 ENJOYOR. All rights reserved.
//

#import "WMNetworkLoadingEffect.h"

@implementation WMNetworkLoadingEffect

- (void)addLoadingEffectWith:(LoadingEffertType)type
{
    switch (type) {
        case LoadingEffertTypeNone:
            
            break;
        case LoadingEffertTypeDefault:
        {
            UIViewController *vc = [[UIApplication sharedApplication] keyWindow].rootViewController;
            UIViewController *currentVC = [self findBestViewController:vc];
            [WMHUDUntil showWhiteLoadingToView:currentVC.view];
        }
            break;
        case LoadingEffertTypeCustom:
            //TODO: 添加自定义加载动画
            break;
            
        default:
            break;
    }
}

- (void)removeLoadingEffectWith:(LoadingEffertType)type
{
    
    switch (type) {
        case LoadingEffertTypeNone:
            
            break;
        case LoadingEffertTypeDefault:
        {
            UIViewController *vc = [[UIApplication sharedApplication] keyWindow].rootViewController;
            UIViewController *currentVC = [self findBestViewController:vc];
            [WMHUDUntil hideHUDForView:currentVC.view];
        }
            break;
        case LoadingEffertTypeCustom:
            //TODO: 添加自定义加载动画
            break;
            
        default:
            break;
    }
}


#pragma mark - private method
- (UIViewController*) findBestViewController:(UIViewController*)vc {
    
    if (vc.presentedViewController) {
        
        // Return presented view controller
        return [self findBestViewController:vc.presentedViewController];
        
    } else if ([vc isKindOfClass:[UISplitViewController class]]) {
        
        // Return right hand side
        UISplitViewController* svc = (UISplitViewController*) vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.viewControllers.lastObject];
        else
            return vc;
        
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        
        // Return top view
        UINavigationController* svc = (UINavigationController*) vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.topViewController];
        else
            return vc;
        
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        
        // Return visible view
        UITabBarController* svc = (UITabBarController*) vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.selectedViewController];
        else
            return vc;
        
    } else {
        
        // Unknown view controller type, return last child view controller
        return vc;
        
    }
    
}

@end
