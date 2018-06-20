//
//  ZCBaseViewController.h
//  SZCEvolution
//
//  Created by choice-ios1 on 16/9/29.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WMBaseViewController : UIViewController

//设置页面的键盘取消响应事件 需要在子类的[super viewDidLoad];方法之前设置
@property (nonatomic,assign) BOOL dismissKeyBoard;

/**
 *  基于导航下，设置返回到指定的controller
 */
@property (nonatomic,copy) NSString *backController;


/**
 *  基于导航下，设置返回按钮的标题，默认为"返回"
 */
@property (nonatomic,copy) NSString *backTitle;

/**
 *  用于友盟统计对应页面的标题
 *  一般的viewController或者tableViewController在本地化里面都已经映射过，不需要设置
 *  主要是为web页面开放使用，尤其是复用的web页面，必须设置该参数
 */
@property (nonatomic,copy) NSString * pageTitle;


/**
 *  基于导航下，重写返回按钮function
 *
 */
- (void)backButtonAction:(UIBarButtonItem*)item;

@end
