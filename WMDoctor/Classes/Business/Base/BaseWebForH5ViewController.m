//
//  BaseWebForH5ViewController.m
//  Micropulse
//
//  Created by JacksonMichael on 16/7/20.
//  Copyright © 2016年 ENJOYOR. All rights reserved.
//

#import "BaseWebForH5ViewController.h"
//#import "DataSigner.h"
//#import "ShareMenu.h"
//#import "AFWebHttpClient.h"
#import "CommonUtil.h"
#define IOS8ORLATER   [[[UIDevice currentDevice] systemVersion] floatValue] >=8.0
static NSString  *const defaultShareIconURL = @"https://weimai-yunyin.oss-cn-hangzhou.aliyuncs.com/weimaiyiliaopic/2017/03/28/b2c4d714-edd8-4e2d-8300-9c3ef6930753.png";

@interface BaseWebForH5ViewController ()<WMWebViewDelegate>

@property (nonatomic,assign) BOOL stopBack;

//右侧按钮的数据操作类型
@property (nonatomic,copy) NSString *type;
//右侧按钮的数据格式
@property (nonatomic,copy) NSDictionary *typeData;

@end

@implementation BaseWebForH5ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (IOS8ORLATER) {
        
        if (self.urlString) {
            
            NSURL * url = [NSURL URLWithString:self.urlString];
            if ([url scheme]==nil||[[url scheme] isEqualToString:@""]) {
                return;
            }
            
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];

            NSUserActivity * userActivity = [[NSUserActivity alloc] initWithActivityType:@"com.qiushi.Micropulse.handoff"];
            //    userActivity.title = @"我是标题";
            //    userActivity.needsSave = YES;
            //    [self.userActivity becomeCurrent];
            
            userActivity.webpageURL = url;
            self.userActivity = userActivity;
        }else{
            if (self.filePath) {
                NSURL *url = [NSURL fileURLWithPath:self.filePath];
                
                if ([url scheme]==nil||[[url scheme] isEqualToString:@""]) {
                    return;
                }
                
                [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
            }
        }
    }
    [self baseWeb_setupData];
    
}
- (void)baseWeb_setupData
{
    _stopBack = NO;
}


- (void)rightBarAction:(UIBarButtonItem*)item
{
    if ([self.type isEqualToString:@"schemeUrl"]) {
        BaseWebForH5ViewController * controller = [[BaseWebForH5ViewController alloc] init];
        controller.urlString = self.typeData[@"url"];
        [self.navigationController pushViewController:controller animated:YES];
    }else if ([self.type isEqualToString:@"share"]){
        
        [self toShareWithData:self.typeData];
    }

}
//重写返回按钮
- (void)backButtonAction:(UIBarButtonItem *)item
{
    if (_stopBack==NO) {
        if ([self.webView canGoBack]) {
            [self.webView goBack];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else
    {
        //把交互交给H5
        [self.bridge callHandler:@"" data:@1];
    }
}
- (void)toShareWithData:(id)data{
    
}

//TODO:实现分享回调方法：
- (void)didFinishGetUMSocialDataInViewController:(id)result error:(NSError *)error
{
    NSLog(@"呵呵哒🙄= %@||%@",result,error);
}
- (void)closeWebViewWhenDelay:(int64_t)timeInterval
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:NO completion:nil];
    });
}

- (BOOL)wm_webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSLog(@"调用了地址:%@",request);
    
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
    NSLog(@"页面释放了吧");
    if (IOS8ORLATER) {
        [self.userActivity invalidate];
    }
}

@end
