//
//  WMMyWalletViewController.m
//  WMDoctor
//  我的钱包，没错是我的钱包，不是你的
//  Created by JacksonMichael on 2017/1/12.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMMyWalletViewController.h"
#import "WMTokenModel.h"
#import "WMGetTokenAPIManager.h"
#import "AppConfig.h"

@interface WMMyWalletViewController ()

@end

@implementation WMMyWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    // Do any additional setup after loading the view.
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                
                                [UIColor colorWithHexString:@"ffffff"],
                                NSForegroundColorAttributeName,
                                
                                [UIFont systemFontOfSize:14],
                                NSFontAttributeName,
                                nil];
    
    [[UIBarButtonItem appearance] setTitleTextAttributes: attributes
                                                forState: UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//新版钱包
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    self.navigationItem.rightBarButtonItem = nil;
    NSString *urlStr = [request URL].absoluteString;
    if ([urlStr containsString:@"withdraw/withdraw.htm"]) {
        //➕提现说明
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"提现说明" style:UIBarButtonItemStyleDone target:self action:@selector(showAlter)];
        rightItem.tintColor = [UIColor whiteColor];
        self.navigationItem.rightBarButtonItem = rightItem;
        
    }
    
    if ([urlStr containsString:@"bankCard/cardDetail.htm"]) {
        //➕管理
//        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"管理" style:UIBarButtonItemStyleDone target:self action:@selector(callJS)];
//        self.navigationItem.rightBarButtonItem = rightItem;
        
    }
    
    
    
    return YES;
}
- (void)showAlter{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提现说明" message:@"1.最小金额必须大于100元。\n2.提现免手续费,每日仅限3笔提现申请。\n3.提现到账时间1到2个工作日(周末和法定节假日顺延)。\n4.如有疑问,请联系客服:400-000-3999。" preferredStyle:UIAlertControllerStyleAlert];
    UIView *subView1 = alert.view.subviews[0];
    UIView *subView2 = subView1.subviews[0];
    UIView *subView3 = subView2.subviews[0];
    UIView *subView4 = subView3.subviews[0];
    UIView *subView5 = subView4.subviews[0];
    UILabel * messageLabel = subView5.subviews[1];
    messageLabel.textAlignment=NSTextAlignmentLeft;
    
    UIAlertAction *actionOne = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];

    [alert addAction:actionOne];
    [self presentViewController:alert animated:YES completion:nil];
    
}
- (void)callJS{
    [self.bridge callHandler:@"cardManage" data:nil responseCallback:^(id responseData) {
        NSLog(@"%@", responseData);
        
    }];
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
