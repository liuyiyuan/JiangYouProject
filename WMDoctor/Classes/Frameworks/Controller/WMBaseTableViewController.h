//
//  ZCBaseTableViewController.h
//  SZCEvolution
//
//  Created by choice-ios1 on 16/9/29.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WMBaseTableViewController : UITableViewController

//设置页面的键盘取消响应事件 需要在子类的[super viewDidLoad];方法之前设置
@property (nonatomic,assign) BOOL dismissKeyBoard;
/**
 *  基于导航下，设置返回到指定的controller
 */
@property (nonatomic,copy) NSString *backController;

/**
 *  基于导航下，设置返回按钮的标题
 */
@property (nonatomic,copy) NSString *backTitle;

/**
 *  基于导航下，重写返回按钮function
 *
 */
- (void)backButtonAction:(UIBarButtonItem*)item;
@end
