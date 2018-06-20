//
//  WMServiceViewController.m
//  WMDoctor
//
//  Created by 茭白 on 2016/12/21.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import "WMServiceViewController.h"
#import "AppConfig.h"
#import <UMMobClick/MobClick.h>
#import "WMBackButtonItem.h"
#import "WMTabBarController.h"
#import <IQKeyboardManager.h>

@interface WMServiceViewController ()<HZActionSheetDelegate>
@property(nonnull,strong)UIBarButtonItem * clearItem;
@end

@implementation WMServiceViewController
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillHideNotification object:nil];
    
    [self setClearBarButtonItems];
    
    [self notifyUpdateUnreadMessageCount];
}
- (void)notifyUpdateUnreadMessageCount {
    __weak typeof(self) __weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        int unreadMsgCount = [[RCIMClient sharedRCIMClient] getUnreadCount:@[
                                                                             @(ConversationType_PRIVATE),
                                                                             @(ConversationType_CUSTOMERSERVICE)
                                                                             ]];
        [(WMTabBarController *)__weakSelf.tabBarController setTabBarNmuber:[NSString stringWithFormat:@"%d",unreadMsgCount]];
    });
    
}

- (void)keyboardDidShow:(NSNotification *)notification
{
    if (notification.name==UIKeyboardWillHideNotification) {
        
        self.clearItem.enabled=YES;
    }
    else
    {
        self.clearItem.enabled=NO;
    }
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    //客服发来了新信息
    /*[[NSNotificationCenter defaultCenter] addObserver:self
     selector:@selector(isShowHoldView:)
     name:kRongCloudNumberNotification
     object:nil];
     */
    //消除融云和IQKeyboardManager的冲突
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar=NO;
    [self.chatSessionInputBarControl updateStatus:KBottomBarDefaultStatus animated:YES];
    [MobClick beginLogPageView:NSLocalizedString(NSStringFromClass([self class]), nil)];
    //刷新一下自己的信息。比如更换头像等，可以及时刷新
    [[RCIM sharedRCIM] refreshUserInfoCache:[RCIMClient sharedRCIMClient].currentUserInfo withUserId:[RCIMClient sharedRCIMClient].currentUserInfo.userId];
    
    
    
}

/*
-(void)setBack{
    WMBackButtonItem * backBarItem=[[WMBackButtonItem alloc] initWithTitle:self.backTitle target:self action:@selector(backButtonAction:)];
    
    self.navigationItem.leftBarButtonItem = backBarItem;
 
    WMBackButtonItem * backBarItem;
    if (_isFromMe==NO) {
        backBarItem = [[WMBackButtonItem alloc] initWithTitle:NSLocalizedString(@"kText_wemai_back", nil)
                                                                          target:self
                                                                          action:@selector(backButtonAction:)];
    }
    else{
        backBarItem = [[WMBackButtonItem alloc] initWithTitle:NSLocalizedString(@"kText_me_back", nil)
                                                       target:self
                                                       action:@selector(backButtonAction:)];
    }
    self.navigationItem.leftBarButtonItem = backBarItem;
     
 */
- (void)backButtonAction:(UIBarButtonItem*)item
{
    [self leftBarButtonItemPressed:nil];
}
#pragma mark--设置左边的item为清空历史记录按钮
-(void)setClearBarButtonItems
{
    //UIBarButtonItem *pushItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(showActionSheet:)];
    
    self.clearItem= [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"weimai_delete"] style:UIBarButtonItemStylePlain target:self action:@selector(showActionSheet:)];
    self.clearItem.width=50;
    self.clearItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItems = @[self.clearItem];
    
}
- (void)showActionSheet:(id)sender{
    HZActionSheet * sheet = [[HZActionSheet alloc] initWithTitle:@"清空聊天记录"
                                                        delegate:self
                                               cancelButtonTitle:@"取消"
                                       destructiveButtonIndexSet:[NSIndexSet indexSetWithIndex:0]
                                               otherButtonTitles:@[@"确定"]];
    [sheet showInView:self.view];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //点击确认按钮开始清除
    if (buttonIndex == 0)
    {
        [self didClearAllMessage];
    }
}

- (void)didClearAllMessage
{
    __weak WMServiceViewController *weakSelf = self;
    //清除本地数据库数据
    [weakSelf.conversationDataRepository removeAllObjects];
    //清除网络数据
    [[RCIMClient sharedRCIMClient]clearMessages:ConversationType_CUSTOMERSERVICE targetId:RONGCLOUD_SERVICE_ID];
    [self leftBarButtonItemPressed:nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        //刷新
        [weakSelf.conversationMessageCollectionView reloadData];
        
    });
}



#pragma mark--消除客服评价功能

- (void)leftBarButtonItemPressed:(id)sender {
    //需要调用super的实现
//    [super leftBarButtonItemPressed:sender];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)commentCustomerServiceWithStatus:(RCCustomerServiceStatus)serviceStatus commentId:(NSString *)commentId quitAfterComment:(BOOL)isQuit {
    if (isQuit) {
        [self leftBarButtonItemPressed:nil];
    }
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar=YES;
    [MobClick endLogPageView:NSLocalizedString(NSStringFromClass([self class]), nil)];
    
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:@"kRongCloudNumberNotification" object:nil];
    
}
#pragma mark-- 以下是实现结束后跳转评论页面 暂时没有要求
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)sendMessageNew{
    RCTextMessage *testMessage=[RCTextMessage messageWithContent:@"我想开通医聊圈功能"];
    [[RCIM sharedRCIM] sendMessage:self.conversationType
                          targetId:self.targetId
                           content:testMessage
                       pushContent:nil
                          pushData:nil
                           success:^(long messageId) {
                               NSLog(@"发送成功。当前消息ID：%ld", messageId);
                           } error:^(RCErrorCode nErrorCode, long messageId) {
                               NSLog(@"发送失败。消息ID：%ld， 错误码：%ld", messageId, (long)nErrorCode);
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
