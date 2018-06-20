//
//  WMNewIndexWebContorller.m
//  WMDoctor
//
//  Created by JacksonMichael on 2018/2/27.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "WMNewIndexWebContorller.h"
#import "WMNewDetailWebViewController.h"
#import "AppConfig.h"

@interface WMNewIndexWebContorller ()
{
    WorkEnvironment _basecurrentEnvir;
}
@end

@implementation WMNewIndexWebContorller

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    LoginModel * loginModel = [WMLoginCache getMemoryLoginModel];
    self.webTitle = @"资讯";
    
    self.urlString = ([AppConfig currentEnvir] == 0)?[NSString stringWithFormat:@"https://m.myweimai.com/yisheng/doctor_news_records.html?userCode=%@",loginModel.userCode]:([AppConfig currentEnvir] == 3)?[NSString stringWithFormat:@"http://dev.m.myweimai.com/yisheng/doctor_news_records.html?userCode=%@",loginModel.userCode]:[NSString stringWithFormat:@"http://test.m.myweimai.com/yisheng/doctor_news_records.html?userCode=%@",loginModel.userCode];
//    [self.webView reload];
    NSURLRequest * urlr = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:self.urlString]];
    [self.webView loadRequest:urlr];
    [self goAnyplace];
    
    //注册刷新通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeToShool) name:@"changeToShoolNotification" object:nil];
    
}

- (void)changeToShool{
    NSURLRequest * urlr = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@&activeTab=3",self.urlString]]];
    [self.webView loadRequest:urlr];
}

- (void)goAnyplace{
    __weak typeof(self) weakself = self;
    _basecurrentEnvir = [AppConfig currentEnvir];   //获取当前运行环境
    
    
    
    
    //去到我的钱包
    [self.bridge registerHandler:@"toDetail" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"data=%@",data);
        
        
        WMNewDetailWebViewController * newVC = [[WMNewDetailWebViewController alloc]init];
        newVC.urlString = data[@"url"];
        
        newVC.shareUrl = data[@"url"];
        newVC.shareTitle = data[@"title"];
        newVC.sharePictureUrl = data[@"image"];
        newVC.shareDetail = data[@"introduction"];
        
        newVC.hidesBottomBarWhenPushed = YES;
        [weakself.navigationController pushViewController:newVC animated:YES];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changeToShoolNotification" object:nil];
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
