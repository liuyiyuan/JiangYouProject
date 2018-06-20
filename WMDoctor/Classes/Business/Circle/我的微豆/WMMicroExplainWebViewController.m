//
//  WMMicroExplainWebViewController.m
//  WMDoctor
//
//  Created by xugq on 2017/11/28.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMMicroExplainWebViewController.h"
#import "WMScoreTaskViewController.h"
#import "WMServiceViewController.h"
#import "AppConfig.h"

@interface WMMicroExplainWebViewController ()

@end

@implementation WMMicroExplainWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
    self.webView.frame = CGRectMake(0, 0, kScreen_width, kScreen_height-70);
}

- (void)setupView{
    
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
