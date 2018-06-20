//
//  WMOutLinkWebViewController.m
//  WMDoctor
//
//  Created by JacksonMichael on 2018/2/27.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "WMOutLinkWebViewController.h"
#import "WMQuestionsViewController.h"
#import "WMMyServiceSetViewController.h"
#import "WMMyMicroBeanViewController.h"
#import "WMMyWalletViewController.h"
#import "AppConfig.h"

@interface WMOutLinkWebViewController ()

@end

@implementation WMOutLinkWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    __weak typeof(self) weakself = self;
    
    //医聊圈设置
    [self.bridge registerHandler:@"goMedicalCircleSetting" handler:^(id data, WVJBResponseCallback responseCallback) {
        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
        WMMyServiceSetViewController * doctorVC = [storyboard instantiateViewControllerWithIdentifier:@"WMMyServiceSetViewController"];
        doctorVC.hidesBottomBarWhenPushed = YES;
        doctorVC.backTitle = @"";
        doctorVC.inquiryType = @"0";
        doctorVC.hidesBottomBarWhenPushed = YES;
        [weakself.navigationController pushViewController:doctorVC animated:YES];
    }];

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
