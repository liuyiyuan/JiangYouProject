//
//  PopUpUtil.h
//  WMDoctor
//
//  Created by choice-ios1 on 16/12/15.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 类声明：弹出框的显示操作类
 */
@interface PopUpUtil : NSObject

/**
 便捷弹出框

 @param message 消息内容
 @param controller 具体的承载页面，传nil会显示到rootViewController页面上
 @param completionHandler 点击回调
 */
+ (void)alertWithMessage:(NSString *)message
        toViewController:(UIViewController*)controller
   withCompletionHandler:(void (^)(void)) completionHandler;


/**
 便捷actionsheet

 @param title 标题
 @param controller 具体的承载页面，传nil会显示到rootViewController页面上
 @param completionHandler 点击回调
 */
+ (void)sheetWithTitle:(NSString*)title
      toViewController:(UIViewController*)controller
 withCompletionHandler:(void (^)(NSInteger buttonIndex)) completionHandler;

/**
 可定义类提示框

 @param title 标题
 @param message 信息内容
 @param controller 具体的承载页面，传nil会显示到rootViewController页面上
 @param buttonTitles 按钮的标题
 @param completionBlock 点击回调
 */
+ (void)confirmWithTitle:(NSString *)title
                 message:(NSString *)message
        toViewController:(UIViewController*)controller
            buttonTitles:(NSArray *)buttonTitles
         completionBlock:(void (^)(NSUInteger buttonIndex)) completionBlock;


//+ (UIViewController*)getRootViewController;

@end
