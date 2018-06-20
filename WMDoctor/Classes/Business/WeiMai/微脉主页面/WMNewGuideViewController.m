//
//  WMNewGuideViewController.m
//  WMDoctor
//
//  Created by 茭白 on 2017/5/22.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMNewGuideViewController.h"
#import "WMMyInformationTableViewController.h"
#import "WMMyServiceSetViewController.h"
#import "WMMyMicroBeanViewController.h"
#import "WMQuestionsViewController.h"

@interface WMNewGuideViewController ()

@end

@implementation WMNewGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak typeof(self) weakself = self;
    
    //医聊圈设置
    [self.bridge registerHandler:@"goMedicalCircleSetting" handler:^(id data, WVJBResponseCallback responseCallback) {
        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
        WMMyServiceSetViewController * doctorVC = [storyboard instantiateViewControllerWithIdentifier:@"WMMyServiceSetViewController"];
        doctorVC.hidesBottomBarWhenPushed = YES;
        doctorVC.backTitle = @"";
        NSString *inquiryType = @"4";
        if (data) {
            inquiryType = [data objectForKey:@"inquiryType"];
        }
        doctorVC.inquiryType = inquiryType;
        doctorVC.hidesBottomBarWhenPushed = YES;
        [weakself.navigationController pushViewController:doctorVC animated:YES];
    }];
    
    
    // Do any additional setup after loading the view.
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
