//
//  WMRCBaseChatViewController.m
//  WMDoctor
//
//  Created by 茭白 on 2017/3/27.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMRCBaseChatViewController.h"
#import "WMBackButtonItem.h"
#import <UMMobClick/MobClick.h>
#import <IQKeyboardManager.h>

@interface WMRCBaseChatViewController ()

@end

@implementation WMRCBaseChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self base_setBack];
    
    
    // Do any additional setup after loading the view.
}
-(void)base_setBack{
    WMBackButtonItem * backBarItem = [[WMBackButtonItem alloc] initWithTitle:self.backName
                                                                      target:self
                                                                      action:@selector(backButtonAction:)];
    self.navigationItem.leftBarButtonItem = backBarItem;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSLocalizedString(NSStringFromClass([self class]), nil)];
    //页面将要展现的时候获取一下状态
    //消除融云和IQKeyboardManager的冲突
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar=NO;
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    
    [super viewDidDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar=YES;
    [MobClick endLogPageView:NSLocalizedString(NSStringFromClass([self class]), nil)];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
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
