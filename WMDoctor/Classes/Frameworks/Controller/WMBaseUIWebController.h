//
//  WMBaseUIWebController.h
//  WMDoctor
//  仅用于金融交互页面
//  Created by choice-ios1 on 17/1/3.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMBaseViewController.h"
#import <WebViewJavascriptBridge.h>


@protocol WMWebViewDelegate;

//因为是继承与BaseViewController，所以返回按钮方法通用

/**
 *  @author ZICHU, 16-07-21 17:07:33
 *
 *  修改返回按钮方法，默认事件返回webview上一页如果需要重写调用backButtonAction方法
 *  增加关闭按钮，当用户有返回意识的时候显示出来
 */

/**
 *  用于金融Web页面加载
 */
@interface WMBaseUIWebController : WMBaseViewController


@property (nonatomic,strong) UIWebView * webView;

/**
 *  外部加交互的时候可以用到，但是非特殊交互尽量在此类内加
 */
@property WebViewJavascriptBridge* bridge;

/**
 *  代理，需要在webview做特殊处理的可以实现该代理
 */
@property (nonatomic,assign) id< WMWebViewDelegate> webdelegate;

/**
 * @brief URL路径
 */
@property (nonatomic,copy) NSString * urlString;

/**
 *  页面标题，不设置默认为页面节点标题
 */
@property (nonatomic,copy) NSString * webTitle;

/**
 *  @author ZICHU, 16-07-27 10:07:40
 *
 *   继承于该类禁止修改 automaticallyAdjustsScrollViewInsets的值。如果需要设置页面inset，由此字段控制
 *   default is 64.f
 */
@property (nonatomic,assign) float heightInsets;


/**
 * 底部约束，默认为0，负值表示离底部有多远距离。可以自行设置；一般用不到。
 */
@property (nonatomic,assign) float bottomInsets;

/**
 * @brief web是否可以返回
 */
@property (nonatomic, readonly, getter=canGoBack) BOOL canGoBack;

/**
 * @brief web是否可以前进
 */
@property (nonatomic, readonly, getter=canGoForward) BOOL canGoForward;


/**
 *  是否隐藏导航栏
 */
@property (nonatomic,assign) BOOL isHideNavigation;


/**
 * @brief web返回到上一层
 */
- (void)goBack;
/**
 * @brief web前进到下一层
 */
- (void)goForward;

@end

@protocol WMWebViewDelegate <NSObject>

@optional

//- (void)wm_webviewBackAction;

- (void)wm_webViewDidStartLoad:(UIWebView *)webView;
- (void)wm_webViewDidFinishLoad:(UIWebView *)webView;
- (void)wm_webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error;
- (BOOL)wm_webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;

@end
