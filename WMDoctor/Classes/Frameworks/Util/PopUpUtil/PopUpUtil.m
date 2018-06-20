//
//  PopUpUtil.m
//  WMDoctor
//
//  Created by choice-ios1 on 16/12/15.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import "PopUpUtil.h"
#import <UIKit/UIKit.h>

@implementation PopUpUtil

+ (void)alertWithMessage:(NSString *)message
        toViewController:(UIViewController*)controller
   withCompletionHandler:(void (^)(void)) completionHandler
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        if (completionHandler) {
            completionHandler();
        }
    }]];
    if (!controller) {
        controller = [self getRootViewController];
    }
    [controller presentViewController:alertController animated:YES completion:NULL];
}

+ (void)sheetWithTitle:(NSString*)title
      toViewController:(UIViewController*)controller
 withCompletionHandler:(void (^)(NSInteger buttonIndex)) completionHandler
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        if (completionHandler) {
            completionHandler(0);
        }
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        if (completionHandler) {
            completionHandler(1);
        }
    }]];
    if (!controller) {
        controller = [self getRootViewController];
    }
    [controller presentViewController:alertController animated:YES completion:NULL];
}

+ (void)confirmWithTitle:(NSString *)title
                 message:(NSString *)message
        toViewController:(UIViewController*)controller
            buttonTitles:(NSArray *)buttonTitles
         completionBlock:(void (^)(NSUInteger buttonIndex)) completionBlock
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    for (NSString *buttonTitle in buttonTitles) {
        NSInteger alertActionStyle = 0;
        if ([buttonTitle isEqualToString:@"退出"]||[buttonTitle isEqualToString:@"删除"]) {
            alertActionStyle = UIAlertActionStyleDestructive;
        }else{
            alertActionStyle = UIAlertActionStyleDefault;
        }
        [alertController addAction:[UIAlertAction actionWithTitle:buttonTitle
                                                  style:alertActionStyle
                                                handler:^(UIAlertAction *action) {
                                                    completionBlock([buttonTitles indexOfObject:buttonTitle]);
                                                }]];
    }
    if (!controller) {
        controller = [self getRootViewController];
    }
    [controller presentViewController:alertController animated:YES completion:NULL];
}
#pragma -mark Pr
+ (UIViewController*)getRootViewController
{
    return  [[[UIApplication sharedApplication] keyWindow] rootViewController];
}
@end
