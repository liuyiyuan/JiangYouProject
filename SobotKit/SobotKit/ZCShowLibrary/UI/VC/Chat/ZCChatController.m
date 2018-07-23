//
//  ZCChatController.m
//  SobotKit
//
//  Created by zhangxy on 2018/1/29.
//  Copyright © 2018年 zhichi. All rights reserved.
//

#import "ZCChatController.h"
#import "ZCChatView.h"
#import "ZCLIbGlobalDefine.h"
#import "ZCUIKeyboardDelegate.h"
#import "ZCUIImageTools.h"
#import "ZCUICore.h"
#import "ZCLibServer.h"

#define MinViewWidth 320
#define MinViewHeight 540
#define pixelValue(number) (ZC_iPhoneX ? (number) / 750.0 * [[UIScreen mainScreen] bounds].size.width : (number) / 1334.0 * [[UIScreen mainScreen] bounds].size.height)
@interface ZCChatController ()<ZCChatViewDelegate>{
    // 屏幕宽高
    CGFloat                     viewWidth;
    CGFloat                     viewHeigth;
    
    // 页面加载生命周期
    void (^PageClickBlock)   (id object,ZCPageBlockType type);
    // 链接点击
    void (^LinkedClickBlock) (NSString *url);
}
@property (nonatomic,strong) ZCChatView * chatView;

@end

@implementation ZCChatController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.navigationController != nil) {
        [self.navigationController setNavigationBarHidden:NO animated:NO];
    }
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.isBarHidden) {
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    }
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [ZCLibClient closeAndoutZCServer:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

// 横竖屏切换
-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait ||toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        
        CGFloat c = viewWidth;
        if(viewWidth > viewHeigth){
            viewWidth = viewHeigth;
            viewHeigth = c;
        }
    }else{
        CGFloat c = viewHeigth;
        if(viewWidth < viewHeigth){
            viewHeigth = viewWidth;
            viewWidth = c;
        }
    }
    // 切换的方法必须调用
    [self viewDidLayoutSubviews];
}


//**************************项目中的导航栏一部分是自定义的View,一部分是系统自带的NavigationBar*********************************
- (void)setNavigationBarStyle{
    [self createLeftBarItemSelect:@selector(buttonClick:) norImageName:@"zcicon_titlebar_back_normal" highImageName:@"zcicon_titlebar_back_normal"];
}

//-(void)goBack{
//    [_chatView dismissZCChatView];
//    [self.navigationController popViewControllerAnimated:YES];
//}


- (void)createLeftBarItemSelect:(SEL)select norImageName:(NSString *)imageName highImageName:(NSString *)heightImageName{
    //12 * 19
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn.titleLabel setFont:[ZCUITools zcgetTitleFont]];
    [btn addTarget:self action:select forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(0, 0, 44,44) ;
    [btn setImage:[ZCUITools zcuiGetBundleImage:@"zcicon_titlebar_back_normal"] forState:UIControlStateNormal];
//    if (imageName) {
//        [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
//    }else{
//        btn.frame = CGRectMake(0, 0, 44, 44);
//        [btn setImage:[ZCUITools zcuiGetBundleImage:@"zcicon_titlebar_back_normal"] forState:UIControlStateNormal];
//    }
//    if (heightImageName) {
//        [btn setImage:[UIImage imageNamed:heightImageName] forState:UIControlStateHighlighted];
//    }else{
//        [btn setImage:[ZCUITools zcuiGetBundleImage:@"zcicon_titlebar_back_normal"] forState:UIControlStateHighlighted];
//    }
    [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = Btn_BACK;
    [btn setTitleColor:[ZCUITools zcgetTopViewTextColor] forState:UIControlStateNormal];
    [btn setTitleColor:[ZCUITools zcgetTopViewTextColor] forState:UIControlStateHighlighted];
    [btn setTitleColor:[ZCUITools zcgetTopViewTextColor] forState:UIControlStateDisabled];
    [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    
    CGRect lf = btn.frame;
    lf.size.width=60;
    [btn setFrame:lf];
//    [btn setTitle:@" 返回" forState:UIControlStateNormal];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:btn];
    
    //    self.navigationItem.leftBarButtonItem = item;
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace   target:nil action:nil];
    
    /**
     width为负数时，相当于btn向右移动width数值个像素，由于按钮本身和  边界间距为5pix，所以width设为-5时，间距正好调整为0；width为正数 时，正好相反，相当于往左移动width数值个像素
     */
    negativeSpacer.width = -5;
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, item, nil];
    
     [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:pixelValue(36)],NSForegroundColorAttributeName:[ZCUITools zcgetTopViewTextColor]}];
    
    UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];

    [rightBtn setFrame:CGRectMake(self.view.frame.size.width-74, NavBarHeight-44, 74, 44)];
    [rightBtn.imageView setContentMode:UIViewContentModeRight];
    [rightBtn setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
    [rightBtn setContentEdgeInsets:UIEdgeInsetsZero];
    [rightBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [rightBtn setAutoresizesSubviews:YES];    
    [rightBtn setTitle:@"" forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:[ZCUITools zcgetListKitTitleFont]];
    [rightBtn setTitleColor:[ZCUITools zcgetTopViewTextColor] forState:UIControlStateNormal];
    [rightBtn setImage:[ZCUITools zcuiGetBundleImage:@"zcicon_btnmore"] forState:UIControlStateNormal];
    [rightBtn setImage:[ZCUITools zcuiGetBundleImage:@"zcicon_btnmore_press"] forState:UIControlStateHighlighted];
    rightBtn.tag = Btn_MORE;
    [rightBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    [self.navigationController.navigationBar setBarTintColor:[ZCUITools zcgetDynamicColor]];

    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    viewWidth = self.view.frame.size.width;
    viewHeigth = self.view.frame.size.height;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor blackColor], NSFontAttributeName : [UIFont boldSystemFontOfSize:pixelValue(36)]};
    
    self.view.userInteractionEnabled = YES;
    
    if(self.navigationController !=nil){
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
     [self setNavigationBarStyle];
    // Do any additional setup after loading the view.
    self.view.userInteractionEnabled = YES;
    self.view.backgroundColor = [UIColor whiteColor];

    CGRect VF = CGRectMake(0, 0, viewWidth, viewHeigth - NavBarHeight);
    if (self.navigationController.navigationBarHidden) {
        VF = CGRectMake(0, 0, viewWidth, viewHeigth);
    }
    
    _chatView = [[ZCChatView alloc]initWithFrame:VF WithSuperController:self];
    _chatView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin ;
    _chatView.delegate = self;
    _chatView.hideTopViewNav = !self.navigationController.navigationBarHidden;
    [self.view addSubview:_chatView];
    [_chatView showZCChatView:_info];
    
    // 添加回调事件
    [_chatView setPageBlock:^(ZCChatView *object, ZCPageBlockType type) {
        if(type == ZCPageBlockLoadFinish){
//            object.backButton.hidden = YES;
            
        }
    } messageLinkClick:nil];
    
    [_chatView setPageBlock:PageClickBlock messageLinkClick:LinkedClickBlock];
    // 通知外部可以更新UI
    if(PageClickBlock){
        PageClickBlock(self,ZCPageBlockLoadFinish);
    }
    
}

-(void)topViewBtnClick:(ZCBtnClickTag)Tag{
    if (Tag == Btn_BACK) {
        
//        if(PageClickBlock){
//            PageClickBlock(self,ZCPageBlockGoBack);
//        }
        
        if (self.navigationController != nil && !_isNoPush) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
    }else if (Tag == Btn_MORE){
        NSLog(@"删除数据");
    }
}

-(void)buttonClick:(UIButton *)sender{
    if (sender.tag == Btn_BACK) {
        [self.chatView confimGoBack];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self.navigationController popViewControllerAnimated:YES];
//        });

    }else if (sender.tag == Btn_MORE){
        NSLog(@"删除数据");
        [self.chatView cleanHistoryMessage];
    }
    
}

-(void)onTitleChanged:(NSString *)title{
    
    if(!self.navigationController.navigationBarHidden){
       self.title = zcLibConvertToString(title);
    }else{
        
    }
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
//    if (viewWidth < MinViewWidth) {
//        viewWidth = MinViewWidth;
//    }
//    if (viewHeigth < MinViewWidth) {
//        viewHeigth = MinViewWidth;
//    }
    CGRect VF = CGRectMake(0, 0, viewWidth, viewHeigth - NavBarHeight);
    if (self.navigationController.navigationBarHidden) {
        VF = CGRectMake(0, 0, viewWidth, viewHeigth);
    }
    _chatView.frame = VF;
}
- (void)dealloc {
    
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


//-(UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
////    UIView * view = [super hitTest:point withEvent:event];
//    if (view == nil) {
//        CGPoint staitionPoint = [self.chatView convertPoint:point fromView:self];
//        if (CGRectContainsPoint(self.chatView.bounds, staitionPoint)) {
//            view = self.chatView;
//        }
//    }
//}

-(id)initWithInitInfo:(ZCKitInfo *)info{
    self=[super init];
    if(self){
        if(info !=nil && !zcLibIs_null([ZCLibClient getZCLibClient].libInitInfo) && !zcLibIs_null([ZCLibClient getZCLibClient].libInitInfo.appKey)){
//            self.zckitInfo=info;
        }else{
//            self.zckitInfo=[ZCKitInfo new];
        }
//        [ZCUIConfigManager getInstance].kitInfo = info;
        [ZCUICore getUICore].kitInfo = info;
    }
    return self;
}

-(void)setPageBlock:(void (^)(ZCChatController *object,ZCPageBlockType type))pageClick messageLinkClick:(void (^)(NSString *link)) linkBlock{
    PageClickBlock = pageClick;
    LinkedClickBlock = linkBlock;
}

@end
