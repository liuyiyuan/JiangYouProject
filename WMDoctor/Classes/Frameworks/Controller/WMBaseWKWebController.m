//
//  WMBaseWKWebController.m
//  WMDoctor
//
//  Created by choice-ios1 on 17/1/3.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMBaseWKWebController.h"


#import "AppConfig.h"


static void *KINContext = &KINContext;


@interface WMBaseWKWebController ()<WKNavigationDelegate>
{
    UILabel * _provideLabel;
    BOOL _isObserved;
}
@property (nonatomic,strong) UIProgressView * progressView;

@end

@implementation WMBaseWKWebController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }return self;
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
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar addSubview:self.progressView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"页面将要消失");
    [self.progressView removeFromSuperview];
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
    
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    
    _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:configuration];
    _webView.navigationDelegate = self;
    
    if (self.urlString) {
        NSURL * url = [NSURL URLWithString:self.urlString];
        if ([url scheme]==nil||[[url scheme] isEqualToString:@""]) {
            return;
        }
        [_webView loadRequest:[NSURLRequest requestWithURL:url]];
        
        NSUserActivity * userActivity = [[NSUserActivity alloc] initWithActivityType:@"com.qiushi.WMDoctor.handoff"];
        
        userActivity.webpageURL = url;
        self.userActivity = userActivity;
    }
    [self.view addSubview:_webView];
    
    //消除黑边
    _webView.opaque = NO;
    _webView.backgroundColor = [UIColor clearColor];
    _webView.scrollView.bounces = NO;
    self.webView.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
    
    _webView.allowsBackForwardNavigationGestures = YES;
    
    _webView.translatesAutoresizingMaskIntoConstraints = NO;
    
    _isObserved = NO;
    //新版本kvo
    //注册kvo，系统为懒加载，如果注册了，但是- (void)addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(nullable void *)context;这个方法没有调用，则实际上是没有注册的。一旦该方法被调用，所有的observer都会自动注册掉
    [_webView addObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress)) options:0 context:KINContext];
    [_webView addObserver:self forKeyPath:NSStringFromSelector(@selector(title)) options:0 context:KINContext];


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
    
//    self.bridge = [WKWebViewJavascriptBridge bridgeForWebView:_webView webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
//
//    }];
    self.bridge = [WKWebViewJavascriptBridge bridgeForWebView:_webView];
    [self.bridge setWebViewDelegate:self];
    
    [self goToView];    
}


/**
 去到各个页面
 */
- (void)goToView{
    __weak typeof(self) weakself = self;
    //去到我的圈子
    [self.bridge registerHandler:@"goSocial" handler:^(id data, WVJBResponseCallback responseCallback) {
//
    }];
    
    //去到个人信息
    [self.bridge registerHandler:@"goPersonInformation" handler:^(id data, WVJBResponseCallback responseCallback) {
        
    }];
    
    //去到我的服务
    [self.bridge registerHandler:@"goMyProvider" handler:^(id data, WVJBResponseCallback responseCallback) {
//
        
    }];
    
    //去到我的名片
    [self.bridge registerHandler:@"goMyVisitingCard" handler:^(id data, WVJBResponseCallback responseCallback) {
        LoginModel * loginModel = [WMLoginCache getMemoryLoginModel];
        //                loginModel.certStatus = @"1";   //自测试
        if ([loginModel.certStatus isEqualToString:@"2"]) { //先判断内存中的状态，如果已认证通过就直接进去不请求接口了
            
        }else{
            
        }
    }];
    
    //去到我的钱包
    [self.bridge registerHandler:@"goMyWallet" handler:^(id data, WVJBResponseCallback responseCallback) {
//        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
        
    }];
    
    //去到我的订单
    [self.bridge registerHandler:@"goMyOrder" handler:^(id data, WVJBResponseCallback responseCallback) {
        
    }];
    
    //去到小脉助手
    [self.bridge registerHandler:@"goWemayHelper" handler:^(id data, WVJBResponseCallback responseCallback) {
//        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
       
    }];
    
    //去分享给朋友
    
    [self.bridge registerHandler:@"goAppShare" handler:^(id data, WVJBResponseCallback responseCallback) {

    }];
    
    
    //弱提示交互
    [self.bridge registerHandler:@"goPersonInformation" handler:^(id data, WVJBResponseCallback responseCallback) {
       
    }];
    
    //我的钱包余额
    [self.bridge registerHandler:@"goBalanceList" handler:^(id data, WVJBResponseCallback responseCallback) {
       
    }];
    
    //guide
    [self.bridge registerHandler:@"goMePage" handler:^(id data, WVJBResponseCallback responseCallback) {
        
    }];
    
    //一问医答设置
    [self.bridge registerHandler:@"goDoctorAnswered" handler:^(id data, WVJBResponseCallback responseCallback) {
        
       
    }];
    
    //我的微豆
    [self.bridge registerHandler:@"goMyBean" handler:^(id data, WVJBResponseCallback responseCallback) {
       
    }];
    
    //积分不够?点此赚积分
    [self.bridge registerHandler:@"toScoreTaskList" handler:^(id data, WVJBResponseCallback responseCallback) {
        
    }];
    
    //联系小脉助手兑换
    [self.bridge registerHandler:@"toWeimaiRobot" handler:^(id data, WVJBResponseCallback responseCallback) {
       
    }];
    
    [self.bridge registerHandler:@"goDetail" handler:^(id data, WVJBResponseCallback responseCallback) {
      
        
    }];
}
- (void)addCloseItemAction
{
    //TO DO>>>
}
//重写返回按钮
- (void)backButtonAction:(UIBarButtonItem*)item
{
    if ([_webView canGoBack]) {
        [_webView goBack];
    }else{
        
    }
}
//重写返回按钮
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

#pragma -mark Delegate

// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    NSLog(@"didStartProvisionalNavigation");

}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
    NSLog(@"didCommitNavigation");

}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    NSLog(@"didFinishNavigation");

}
// 页面加载失败时调用
//- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error;

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    BOOL unConvention = (![webView.URL.scheme  isEqual: @"http"]) && (![webView.URL.scheme  isEqual: @"https"]);
    
    if (unConvention && [error code] != NSURLErrorCancelled) {
        [WMHUDUntil showFailWithMessage:@"页面加载失败😭" toView:self.view];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Estimated Progress KVO (WKWebView)

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    _isObserved = YES;
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))] && object == self.webView) {
        [self.progressView setAlpha:1.0f];
        BOOL animated = self.webView.estimatedProgress > self.progressView.progress;
        [self.progressView setProgress:self.webView.estimatedProgress animated:animated];
        
        // Once complete, fade out UIProgressView
        if(self.webView.estimatedProgress >= 1.0f) {
            [UIView animateWithDuration:0.3f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.progressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0.0f animated:NO];
            }];
        }
    }else if ([keyPath isEqualToString:NSStringFromSelector(@selector(title))] && object == self.webView){
        NSLog(@"change title???");
        if (!_webTitle) {
            self.title = _webView.title;
        }else{
            self.title = _webTitle;
        }
    }
}
-(UIProgressView *)progressView {
    if (!_progressView) {
        _progressView =  [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        [_progressView setTrackTintColor:[UIColor colorWithWhite:1.0f alpha:0.0f]];
        [_progressView setFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height-_progressView.frame.size.height, self.view.frame.size.width, _progressView.frame.size.height)];
        [_progressView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];
    }
    return _progressView;
}
- (void)dealloc
{
    NSLog(@"页面dealloc");
    if (_isObserved) {
        [self.webView removeObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress)) context:KINContext];
        [self.webView removeObserver:self forKeyPath:NSStringFromSelector(@selector(title)) context:KINContext];
    }
    [self.userActivity invalidate];
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
