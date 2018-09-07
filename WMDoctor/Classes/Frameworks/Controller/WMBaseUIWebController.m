//
//  WMBaseUIWebController.m
//  WMDoctor
//
//  Created by choice-ios1 on 17/1/3.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMBaseUIWebController.h"
#import "WMHUDUntil.h"

@interface WMBaseUIWebController ()<UIWebViewDelegate>
{
    UILabel * _provideLabel;
//    WMTokenModel * _model;
}
@end

@implementation WMBaseUIWebController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
        
    }return self;
}
- (void)initialize
{
    _heightInsets = 0;
    _bottomInsets = 0;
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    //[self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    //[self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self basewk_setupView];
    
    // Do any additional setup after loading the view.
}
- (void)basewk_setupView
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.webView = [[UIWebView alloc] init];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    //消除黑边
    _webView.opaque = NO;
    _webView.backgroundColor = [UIColor clearColor];
    _webView.scrollView.bounces = NO;
    self.webView.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
    
    _webView.translatesAutoresizingMaskIntoConstraints = NO;
    
    //另一种实现方案：放到webview.scrollview上，但是在webview的上部，这样就不用调整其他的
    _provideLabel = [[UILabel alloc] init];
    [self.view addSubview:_provideLabel];
    [self.view sendSubviewToBack:_provideLabel];
    _provideLabel.font = [UIFont systemFontOfSize:12];
    _provideLabel.textColor = [UIColor lightGrayColor];
    _provideLabel.textAlignment = NSTextAlignmentCenter;
    _provideLabel.translatesAutoresizingMaskIntoConstraints = NO;
    __weak typeof(self) weakself = self;
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_provideLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_provideLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_provideLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:_heightInsets]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_provideLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:25]];
    
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:_bottomInsets]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_provideLabel attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    
    // Do any additional setup after loading the view.
    
//    self.bridge = [WebViewJavascriptBridge bridgeForWebView:_webView webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
//        
//    }];
    self.bridge = [WebViewJavascriptBridge bridgeForWebView:_webView];
    [self.bridge setWebViewDelegate:self];
    
    //关闭webView
    [self.bridge registerHandler:@"closeWebView" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        [weakself closeWebViewWhenDelay:0];
    }];
    
    //服务器告诉客户端token失效的回调,此处应删除本地token
    [self.bridge registerHandler:@"tokenInvalidCallBack" handler:^(id data, WVJBResponseCallback responseCallback) {
        [WMHUDUntil showMessageToWindow:@"状态失效，请重新进入"];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:nil forKey:@"jrtoken"];
        [defaults setObject:nil forKey:@"jrtokentime"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
//        [weakself closeWebViewWhenDelay:2.5];         //金融会自动调用closeWbeView
    }];
    
    
    
    if (!self.isHideNavigation) {
        self.heightInsets = 20;
    }
    
    if (self.urlString&&![self.urlString isEqualToString:@""]) {
        //获取判断token     大渺
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString * tokenStr = [defaults objectForKey:@"jrtoken"];
        NSString * tokenTime = [defaults objectForKey:@"jrtokentime"];
        if (!stringIsEmpty(tokenTime)) {
            if ([self ConvertStrToTime:tokenTime]) {   //没过期
                
                
                NSMutableURLRequest * mutableURLRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.urlString] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60];
                [mutableURLRequest setValue:tokenStr forHTTPHeaderField:@"token"];
                [self.webView loadRequest:mutableURLRequest];
                return;
            }else{  //过期
                [self getToken];
            }
        }else{
            [self getToken];
        }

//        NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60];
//        [self.webView loadRequest:request];
    }
    //模拟电池栏
//    UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 20)];
//    
//    UIColor *backgroundColor = [UIColor colorWithRed:239/255.f green:107/255.f blue:112/225.f alpha:1];
//    statusBarView.backgroundColor = backgroundColor;
//    
//    [self.view addSubview:statusBarView];
//    
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];


}
//- (UIStatusBarStyle)preferredStatusBarStyle{
//    
//    return UIStatusBarStyleLightContent;
//    
//}


/**
 推出当前WebViewControl

 @param timeInterval <#timeInterval description#>
 */
- (void)closeWebViewWhenDelay:(int64_t)timeInterval
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}

/**
 金融token获取  大渺
 */
- (void)getToken{
   
}


/**
 时间比对   大渺
 */
- (BOOL)ConvertStrToTime:(NSString *)timeStr

{
    
    long long time=[timeStr longLongValue];
    
    NSDate *d = [[NSDate alloc]initWithTimeIntervalSince1970:time/1000.0];
    
    if ([d timeIntervalSince1970] > [NSDate date].timeIntervalSince1970) {
        NSLog(@"未超时");
        
        return YES;
    }else{
        NSLog(@"已超时");
        return NO;
    }
    
}

#pragma -mark 自定义实现
- (void)goBack{
    
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }
}
- (void)goForward{
    
    if ([self.webView canGoForward]) {
        [self.webView goForward];
    }
}
- (BOOL)canGoBack{
    
    return [self.webView canGoBack];
}
- (BOOL)canGoForward{
    
    return [self.webView canGoForward];
}

- (void)addCloseItemAction
{
    if (self.navigationItem.leftBarButtonItems.count<2) {
        
        UIButton* closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [closeButton setImage:[UIImage imageNamed:@"bt_backarrow"] forState:UIControlStateNormal];
        closeButton.frame = CGRectMake(0, 0, 30, 30);
        [closeButton addTarget:self action:@selector(closeWebviewAction) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem* closeBarItem = [[UIBarButtonItem alloc] initWithCustomView:closeButton];
        
        self.navigationItem.leftBarButtonItems = @[self.navigationItem.leftBarButtonItem,closeBarItem];
        
    }
}
//关闭按钮事件
- (void)closeWebviewAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)backButtonAction:(UIBarButtonItem *)item
{
    if ([_webView canGoBack]) {
        [_webView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma -mark UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    //    [MBHUDUntil showHUDAddedTo:self.view];
    
    if (self.webdelegate&&[self.webdelegate respondsToSelector:@selector(wm_webViewDidStartLoad:)]) {
        [self.webdelegate wm_webViewDidStartLoad:webView];
    }
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    //    [MBHUDUntil hideAllHUDForView:self.view];
    
    if (!_webTitle) {
        self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    }else{
        self.title = _webTitle;
    }
    //NSURL * myUrl = webView.request.URL;
    //注释于2016年09月11日14:24:45 by 益智仁
    //_provideLabel.text = [NSString stringWithFormat:@"网页由 %@ 提供",myUrl.host];
    
    if (self.webdelegate&&[self.webdelegate respondsToSelector:@selector(wm_webViewDidFinishLoad:)]) {
        [self.webdelegate wm_webViewDidFinishLoad:webView];
    }
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
    
    NSLog(@"fail,,,=%@",error);
    
    //[error.domain isEqualToString:@"WebKitErrorDomain"]
    BOOL unConvention = (![webView.request.URL.scheme  isEqual: @"http"]) && (![webView.request.URL.scheme  isEqual: @"https"]);
    
    if (unConvention && [error code] != NSURLErrorCancelled) {
        [WMHUDUntil showFailWithMessage:@"页面加载失败😭" toView:self.view];
    }
    
    if (self.webdelegate&&[self.webdelegate respondsToSelector:@selector(wm_webView:didFailLoadWithError:)]) {
        [self.webdelegate wm_webView:webView didFailLoadWithError:error];
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    //过滤移动运营商拦截
    if ([request.URL.absoluteString isEqualToString:@"about:blank"]) {
        return NO;
    }
    
    if (navigationType==UIWebViewNavigationTypeBackForward) {
        
        //[self addCloseItemAction];
    }
    
    NSLog(@"%@",request.URL);
    
    BOOL isNeedLoad = YES;
    
    if (self.webdelegate&&[self.webdelegate respondsToSelector:@selector(wm_webView:shouldStartLoadWithRequest:navigationType:)]) {
        isNeedLoad = [self.webdelegate wm_webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    }
    
    return isNeedLoad;
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
