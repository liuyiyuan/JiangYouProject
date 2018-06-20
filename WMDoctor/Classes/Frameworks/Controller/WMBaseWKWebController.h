//
//  WMBaseWKWebController.h
//  WMDoctor
//
//  Created by choice-ios1 on 17/1/3.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMBaseViewController.h"
#import <WKWebViewJavascriptBridge.h>
#import <WebKit/WebKit.h>

/**
 * webview承载页面
 */
@interface WMBaseWKWebController : WMBaseViewController


/**
 *  页面的webview
 */
@property (nonatomic,strong) WKWebView * webView;

/**
 *  外部加交互的时候可以用到，但是非特殊交互尽量在此类内加
 */
@property WKWebViewJavascriptBridge* bridge;

/**
 *  代理，需要在webview做特殊处理的可以实现该代理
 */
//@property (nonatomic,assign) id< WMWebViewDelegate> webdelegate;

/**
 *  URL路径
 */
@property (nonatomic,copy) NSString * urlString;

/**
 *  页面标题，不设置默认为页面节点标题，写在子类的viewDidLoad之前
 */
@property (nonatomic,copy) NSString * webTitle;

/**
 *  继承于该类禁止修改 automaticallyAdjustsScrollViewInsets的值。如果需要设置页面inset，由此字段控制
 *   default is 64.f
 */
@property (nonatomic,assign) float heightInsets;


/**
 *  底部约束，默认为0，负值表示离底部有多远距离。可以自行设置；一般用不到。
 */
@property (nonatomic,assign) float bottomInsets;

/**
 *  web是否可以返回
 */
@property (nonatomic, readonly, getter=canGoBack) BOOL canGoBack;

/**
 *  web是否可以前进
 */
@property (nonatomic, readonly, getter=canGoForward) BOOL canGoForward;

/**
 *  web返回到上一层
 */
- (void)goBack;
/**
 *  web前进到下一层
 */
- (void)goForward;

@end
