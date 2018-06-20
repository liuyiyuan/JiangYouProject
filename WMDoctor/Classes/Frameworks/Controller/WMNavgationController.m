//
//  WMNavgationController.m
//  WMDoctor
//
//  Created by choice-ios1 on 16/12/14.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import "WMNavgationController.h"
#import "WMNavigationBar.h"
#import "UIColor+Hex.h"
#import "UINavigationBar+Awesome.h"

@interface WMNavgationController ()

@end

@implementation WMNavgationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setValue:[[WMNavigationBar alloc]init] forKeyPath:@"navigationBar"];
    
    //navigationBar的背景颜色
    self.navigationBar.barTintColor = [UIColor whiteColor];
    
    //左右按钮 字体 颜色  [UIColor colorWithHexString:@"3d94ea"]
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                
                                [UIColor colorWithHexString:@"3d94ea"],
                                NSForegroundColorAttributeName,
                                
                                [UIFont systemFontOfSize:14],
                                NSFontAttributeName,
                                nil];
    
    [[UIBarButtonItem appearance] setTitleTextAttributes: attributes
                                                forState: UIControlStateNormal];
    
    //navigationBar的渲染颜色
//    self.navigationBar.tintColor = [UIColor colorWithHexString:@"18a2ff"];
    self.navigationBar.barTintColor = [UIColor colorWithHexString:@"18a2ff"];
    self.navigationBar.translucent = NO;        //使用真实颜色
    
    //自定义一个NaVIgationBar
    [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    //消除阴影
    self.navigationBar.shadowImage = [UIImage new];
    
    //navigationBar渐变背景
//    [self.navigationBar setShadowImage:[UIImage new]];
//    [self.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
//    [self.navigationBar.layer addSublayer:[CommonUtil backgroundColorInNavigation:self.navigationController.navigationBar]];
    
    
    
    //自定义返回按钮
    UIImage *backButtonImage = [[UIImage imageNamed:@"bt_backarrow"] resizableImageWithCapInsets:UIEdgeInsetsMake(0,30, 0, 0)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    //    //移除返回按钮的文字    (NSIntegerMin有毒)
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#ffffff"],NSFontAttributeName:[UIFont systemFontOfSize:18]}];
    
    UIImage *img = [UIImage new];
    
    [[UINavigationBar appearance] setBackIndicatorImage:img];
    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:img];
    // Do any additional setup after loading the view.
}
//让导航控制器的状态前景色由控制器内的每个controller去控制
- (UIViewController*)childViewControllerForStatusBarStyle {
    
    return self.topViewController;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
