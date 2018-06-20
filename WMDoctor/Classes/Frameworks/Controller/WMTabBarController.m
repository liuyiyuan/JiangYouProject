//
//  WMTabBarController.m
//  WMDoctor
//
//  Created by choice-ios1 on 16/12/16.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import "WMTabBarController.h"
#import "AppDelegate+RongCloud.h"
@interface WMTabBarController ()

@end

@implementation WMTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    //http://wfkbyni.iteye.com/blog/2034104

    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSString *unreadMsgCount = [[NSUserDefaults standardUserDefaults] objectForKey:@"SetUnreadMsgCount"];
    if (!stringIsEmpty(unreadMsgCount)) {
        [self setTabBarNmuber:unreadMsgCount];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SetUnreadMsgCount"];
    }
    NSDictionary * userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"RongCloudPush"];
    if (!userInfo) {
        return;
    }
    [[AppDelegate sharedAppDelegate]rongCloudIMMessageJump:userInfo];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"RongCloudPush"];
}


-(void)setTabBarNmuber:(NSString *)numberStr{
    
    if ([numberStr intValue]==0) {
       self.viewControllers[1].tabBarItem.badgeValue=nil;
    }
    else{
        if ([numberStr intValue]>99) {
            numberStr=@"99+";
        }
        self.viewControllers[1].tabBarItem.badgeValue=numberStr;

    }
    
    
    
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
