//
//  BaseWebViewController.m
//  Micropulse
//
//  Created by choice-ios1 on 15/9/1.
//  Copyright (c) 2015年 ENJOYOR. All rights reserved.
//

#import "BaseWebViewController.h"
//#import "GuahaoH5ViewController.h"
#import "WMDevice.h"

@interface BaseWebViewController ()<UIWebViewDelegate>
{
    UILabel * _provideLabel;
}
@end

@implementation BaseWebViewController

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
//    _heightInsets = 64;
    _heightInsets = 0;      //导航栏不透明后的处理
    _bottomInsets = 0;
    
}
- (void)viewDidLoad {
    
    [super viewDidLoad];

    [self baseSetupView];
}

#pragma -mark UI布局

- (void)baseSetupView
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

}
- (void)addCloseItemAction
{
    if (self.navigationItem.leftBarButtonItems.count<2) {
        
        UIButton* closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [closeButton setImage:[UIImage imageNamed:@"title_new_close"] forState:UIControlStateNormal];
        closeButton.frame = CGRectMake(0, 0, 30, 30);
        [closeButton addTarget:self action:@selector(closeWebviewAction) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem* closeBarItem = [[UIBarButtonItem alloc] initWithCustomView:closeButton];
        
        self.navigationItem.leftBarButtonItems = @[self.navigationItem.leftBarButtonItem,closeBarItem];
        
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
//重写返回按钮
- (void)backButtonAction:(UIBarButtonItem *)item
{
    
    if ([_webView canGoBack]) {
        [_webView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
//关闭按钮事件
- (void)closeWebviewAction
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma -mark UIWebViewDelegate 

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
//    [MBHUDUntil showHUDAddedTo:self.view];
    
    if (self.webdelegate&&[self.webdelegate respondsToSelector:@selector(wm_webViewDidStartLoad:)]) {
        [self.webdelegate wm_webViewDidStartLoad:webView];
    }
//    //H5通过交互可以设置导航条的rightBarButtonItem，故在页面重新加载的时候需要置空
//    self.navigationItem.rightBarButtonItem = nil;
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
        
        [self addCloseItemAction];
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
