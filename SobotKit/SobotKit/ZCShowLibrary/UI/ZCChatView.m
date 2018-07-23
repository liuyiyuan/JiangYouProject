//
//  ZCChatView.m
//  SobotKit
//
//  Created by lizhihui on 2018/1/29.
//  Copyright © 2018年 zhichi. All rights reserved.
//

#import "ZCChatView.h"
#import "ZCLIbGlobalDefine.h"

//#import "ZCLeaveMsgController.h"
#import "ZCUIAskTableController.h"

#import <SobotKit/SobotKit.h>


#import "ZCPlatformTools.h"
#import "ZCUICore.h"
#import "ZCUILoading.h"

#import "ZCUIColorsDefine.h"
#import "ZCChatBaseCell.h"
#import "ZCRichTextChatCell.h"
#import "ZCImageChatCell.h"
#import "ZCVoiceChatCell.h"
#import "ZCTipsChatCell.h"
#import "ZCGoodsCell.h"
#import "ZCHorizontalRollCell.h"
#import "ZCVerticalRollCell.h"
#import "ZCMultiItemCell.h"

#import "ZCActionSheet.h"
#import "ZCUILeaveMessageController.h"
#import "ZCLibSkillSet.h"
#import "ZCSobotCore.h"
#import "ZCStoreConfiguration.h"
#import "ZCUIImageView.h"

#import "ZCSatisfactionCell.h"

#import "ZCPlatformTools.h"

#import "ZCMultiRichCell.h"

#import "ZCHotGuideCell.h"
#define cellHotGuideIdentifier @"ZCHotGuideCell"

#define cellMultiRichIdentifier @"ZCMultiRichCell"
#define cellRichTextIdentifier @"ZCRichTextChatCell"
#define cellImageIdentifier @"ZCImageChatCell"
#define cellVoiceIdentifier @"ZCVoiceChatCell"
#define cellTipsIdentifier @"ZCTipsChatCell"
#define cellGoodsIndentifier @"ZCGoodsCell"
#define cellSatisfactionIndentifier @"ZCSatisfactionCell"
#define cellHorizontalRollIndentifier @"ZCHorizontalRollCell"
#define cellVerticalRollIndentifier @"ZCVerticalRollCell"
#define cellMultilItemIndentifier @"ZCMultiItemCell"

#import "ZCIMChat.h"
#import "ZCUIChatKeyboard.h"
#import "ZCUIKeyboard.h"
#import "ZCUICustomActionSheet.h"
#import "ZCUIWebController.h"
#import "ZCUIXHImageViewer.h"
#import "ZCLibServer.h"
#import "ZCUIVoiceTools.h"
#import "ZCLIbGlobalDefine.h"
#import "ZCLibNetworkTools.h"


#define TableSectionHeight 44


#define MinViewWidth 320
#define MinViewHeight 540



@interface ZCChatView()<ZCUICoreDelegate,UITableViewDelegate,UITableViewDataSource,ZCUIBackActionSheetDelegate,ZCChatCellDelegate,UIAlertViewDelegate,ZCUIVoiceDelegate,ZCActionSheetDelegate>{
    CGFloat viewWidth;
    CGFloat viewHeight;
    // 链接点击
    void (^LinkedClickBlock) (NSString *url);
    // 页面加载生命周期
    void (^PageClickBlock)   (id object,ZCPageBlockType type);

    // 呼叫的电话号码
    NSString                    *callURL;
    // 旋转时隐藏查看大图功能
    ZCUIXHImageViewer           *xhObj;
    
    // 无网络提醒button
    UIButton                    *_newWorkStatusButton;
    
    //长连接显示情况
    UIButton                    *_socketStatusButton;
    
    CGFloat navHeight;
    
    BOOL                        isStartConnectSockt;
}




@property (nonatomic,strong) ZCUIKeyboard * keyboardTools;

@property (nonatomic,strong) UIRefreshControl * refreshControl;
@property (nonatomic,strong) UIButton *goUnReadButton;
@property (nonatomic,strong) UITableView * listTable;
@property (nonatomic,assign) BOOL isNoMore;
// 通告view
@property (nonatomic,strong)  UIView           *notifitionTopView;

/***  评价页面 **/
@property (nonatomic,strong) ZCUICustomActionSheet *sheet;

/** 声音播放对象 */
@property (nonatomic,strong) ZCUIVoiceTools    *voiceTools;

/** 网络监听对象 */
@property (nonatomic,strong) ZCLibNetworkTools *netWorkTools;

@end

@implementation ZCChatView

-(instancetype)initWithFrame:(CGRect)frame WithSuperController:(UIViewController *)superController{
    self = [super initWithFrame:frame];
    if (self) {
        _superController = superController;
        self.backgroundColor = [UIColor whiteColor];
        [self setUI];
        self.userInteractionEnabled = YES;
        _voiceTools  = [[ZCUIVoiceTools alloc] init];
        _voiceTools.delegate = self;
        self.clipsToBounds=YES;
    }
    return self;
}

-(void)showZCChatView:(ZCKitInfo *)kitInfo{
    [ZCUICore getUICore].chatView = self;
    [[ZCUICore getUICore] openSDKWith:[ZCLibClient getZCLibClient].libInitInfo uiInfo:kitInfo Delegate:self  blcok:^(ZCInitStatus code, NSMutableArray *arr, NSString *result) {
        if(code == ZCInitStatusLoading){
            // 开始初始化
            // 展示智齿loading
            [[ZCUILoading shareZCUILoading] showAddToSuperView:self];
        }
        if(code == ZCInitStatusLoadSuc){
            // 初始化完成

            // 智齿loading消失
            [[ZCUILoading shareZCUILoading] dismiss];
            [self configShowNotifion];
        }
       
    }];
}


/**
 页面改变事件

 @param status 判断事件处理关键
 @param message 事件相关联消息
 @param object  预留参数
 */
-(void)onPageStatusChanged:(ZCShowStatus)status message:(NSString *)message obj:(id)object{
    // 有新消息、消息列表改变
    if(status == ZCShowStatusAddMessage || status ==  ZCShowStatusMessageChanged || status == ZCInitStatusCompleteNoMore){
       
        if(status == ZCInitStatusCompleteNoMore){
            _isNoMore = YES;
        }
        [_listTable reloadData];
        if([self.refreshControl isRefreshing]){
            [self.refreshControl endRefreshing];
        }else{
            [self scrollTableToBottom];
        }
    }
    
    // 超过一定数量显示未读消息点击效果
    if(status == ZCShowStatusUnRead){
        [self.goUnReadButton setTitle:message forState:UIControlStateNormal];
        self.goUnReadButton.hidden = NO;
    }
    
    if (status == ZCShowStatusGoBack) {
        [self goBackIsKeep];
    }

    // 跳转到留言页面
    if (status == ZCShowStatusLeaveMsgPage) {
        if ([object integerValue] == 2 && [self getZCLibConfig].type == 2 && [self getZCLibConfig].msgFlag == 1) {
            [_keyboardTools setKeyBoardStatus:ZCKeyboardStatusNewSession];
            
            // 设置昵称
            if(!_hideTopViewNav){
                [self.titleLabel setText:ZCSTLocalString(@"暂无客服在线")];
            }else{
                if (self.delegate && [self.delegate respondsToSelector:@selector(onTitleChanged:)]) {
                    [self.delegate onTitleChanged:ZCSTLocalString(@"暂无客服在线")];
                }
            }
            
        }else{
            // 是否直接退出SDK
            NSInteger isExit = [object integerValue];
            [self jumpNewPageVC:ZC_LeaveMsgPage IsExist:isExit isShowToat:NO tipMsg:@"" Dict:nil];
        }
    }
    if(status == ZCShowStatusChangedTitle){
 
        if(!_hideTopViewNav){
            [self.titleLabel setText:message];
        }else{
            if (self.delegate && [self.delegate respondsToSelector:@selector(onTitleChanged:)]) {
                [self.delegate onTitleChanged:message];
            }
        }
        
    }
    
    if (status == ZCShowStatusSatisfaction) {
        [_keyboardTools hideKeyboard];
        
    }
    
    // 新会话
    if (status == ZCShowStatusReConnected) {
        // 新的会话要将上一次的数据清空全部初始化在重新拉取
        [_listTable reloadData];
//        _isHadLoadHistory = NO;
        _isNoMore = NO;
        [_keyboardTools setKeyBoardStatus:ZCKeyboardStatusNewSession];
        // 重新加载数据
        return;
    }
    
    //
    if (status == ZCShowStatusConnectingUser) {
        _keyboardTools.isConnectioning = YES;
        _keyboardTools.zc_turnButton.enabled = NO;
    }
    
    if (status == ZCShowStatusConnectFinished){
        _keyboardTools.zc_turnButton.enabled = YES;
        _keyboardTools.isConnectioning = NO;
        [[ZCUICore getUICore] dismissSkillSetView];
    }
    
    if (status == ZCShowCustomActionSheet) {
        // 回收键盘
        [_keyboardTools hideKeyboard];
        [ZCUICore getUICore].chatView = self;
        [(ZCUICustomActionSheet*)object showInView:self];
        
    }
    
    // 设置键盘样式
    if (status == ZCSetKeyBoardStatus) {
        [_keyboardTools hideKeyboard];
        if ([@"ZCKeyboardStatusRobot" isEqualToString:message]) {
            [_keyboardTools setKeyBoardStatus:ZCKeyboardStatusRobot];
        }else if ([@"ZCKeyboardStatusWaiting" isEqualToString:message]){
            [_keyboardTools setKeyBoardStatus:ZCKeyboardStatusWaiting];
        }else if ([@"ZCKeyboardStatusUser" isEqualToString:message]){
            [_keyboardTools setKeyBoardStatus:ZCKeyboardStatusUser];
        }else if ([@"ZCKeyboardStatusNewSession" isEqualToString:message]){
            [_keyboardTools setKeyBoardStatus:ZCKeyboardStatusNewSession];
        }else if (message == nil){
            [_keyboardTools setInitConfig:(ZCLibConfig *)object];
        }

    }
    
    if (status == ZCSetListTabelRoad) {
        [self.listTable reloadData];
    }
    // 仅人工模式 关闭技能组 直接退出SDK页面
    if (status == ZCInitStatusCloseSkillSet) {
        [[ZCUICore getUICore].listArray removeAllObjects];
        [_listTable reloadData];
        [self goBackIsKeep];
    }
    
    // 链接中。。
    if (status == ZCInitStatusConnecting) {
        if ([message intValue] == ZC_CONNECT_KICKED_OFFLINE_BY_OTHER_CLIENT) {
            if(self.superController.navigationController){
                [[ZCUIToastTools shareToast] showToast:ZCSTLocalString(@"您打开了新窗口，本次会话结束") duration:1.0f view:self.window.rootViewController.view position:ZCToastPositionCenter];
            }else{
                [[ZCUIToastTools shareToast] showToast:ZCSTLocalString(@"您打开了新窗口，本次会话结束") duration:1.0f view:self position:ZCToastPositionCenter];
            }
        }else{
          [self showSoketConentStatus:[message intValue]];
        }
        
    }
    
}
-(void)jumpNewPageVC:(ZCPagesType)type IsExist:(LeaveExitType)isExist isShowToat:(BOOL)isShow tipMsg:(NSString *)msg Dict:(NSDictionary *)dict{
    if (type == ZC_AskTabelPage) {
        ZCUIAskTableController * askVC = [[ZCUIAskTableController alloc]init];
        askVC.dict = dict[@"data"];
        if (msg !=nil && [msg isEqualToString:@"clearskillId"]) {
            askVC.isclearskillId = YES;
        }
   
        askVC.trunServerBlock = ^(BOOL isback) {
            if (isback && [[ZCUICore getUICore] getLibConfig].type == 2) {
                // 返回当前页面 结束会话回到启动页面
                [self goBackIsKeep];
            }else{
                if (isback) {
                    return ;
                }else{
                    // 去执行转人工的操作
                    [[ZCUICore getUICore] doConnectUserService];
                }
                
            }
        };
         [self openNewPage:askVC];
        
    }else if (type == ZC_LeaveMsgPage){        
        if (_superController.chatdelegate && [_superController.chatdelegate respondsToSelector:@selector(openLeaveMsgClick:)]) {
            [_superController.chatdelegate openLeaveMsgClick:msg];
            return;
        }
        __weak ZCChatView * chatView = self;
        ZCUILeaveMessageController *leaveMessageVC = [[ZCUILeaveMessageController alloc]init];
        leaveMessageVC.exitType = isExist;
        leaveMessageVC.isShowToat = isShow;
        leaveMessageVC.tipMsg = msg;
        leaveMessageVC.isNavOpen = (self.superController.navigationController!=nil ? YES: NO);
        [leaveMessageVC setCloseBlock:^{
            [chatView goBackIsKeep];
        }];
        
        [self openNewPage:leaveMessageVC];
    }
}


-(void)openNewPage:(UIViewController *) vc{
    if(self.superController && [self.superController isKindOfClass:[UIViewController class]]){
        if (self.superController.navigationController) {
            [self.superController.navigationController pushViewController:vc animated:YES];
        }else{
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
            [self.superController  presentViewController:nav animated:YES completion:^{
                
            }];
            
        }
    }
}


#pragma mark -- 设置昵称
-(void)setTitleName:(NSString *)titleName{
    /**
     * 0.默认 1.企业昵称 2.自定义昵称
     *
     */
    if ([[ZCLibClient getZCLibClient].libInitInfo.titleType intValue] == 1) {
        // 取企业昵称
        titleName = [self getZCLibConfig].companyName;

    }else if ([[ZCLibClient getZCLibClient].libInitInfo.titleType intValue] ==2) {
        if (![@"" isEqual:zcLibConvertToString([ZCLibClient getZCLibClient].libInitInfo.customTitle)]) {
            // 自定义的昵称
            titleName = [ZCLibClient getZCLibClient].libInitInfo.customTitle;
        }
    }
    
    if(!_hideTopViewNav){
        [self.titleLabel setText:titleName];
    }else{
        if (self.delegate && [self.delegate respondsToSelector:@selector(onTitleChanged:)]) {
            [self.delegate onTitleChanged:titleName];
        }
    }
    
}

/**
 显示消息到TableView上
 */
-(void)scrollTableToBottom{

    [ZCLogUtils logHeader:LogHeader debug:@"滚动到底部"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        CGFloat ch=_listTable.contentSize.height;
        CGFloat h=_listTable.bounds.size.height;
        
        CGRect tf         = _listTable.frame;
        CGFloat x = tf.size.height-_listTable.contentSize.height;
        
        CGFloat keyBoardHeight = self.frame.size.height - _keyboardTools.zc_bottomView.frame.origin.y-BottomHeight;
        if(x > 0){
            if(x<keyBoardHeight){
                tf.origin.y = navHeight - (keyBoardHeight - x)  - BottomHeight;
            }
        }else{
            tf.origin.y   =  -keyBoardHeight;
        }
        _listTable.frame  = tf;
        
        if(ch > h){
            [_listTable setContentOffset:CGPointMake(0, ch-h) animated:NO];
        }else{
            [_listTable setContentOffset:CGPointMake(0, 0) animated:NO];
        }
        
    });
    
}

// 加载历史消息
-(void)getHistoryMessage{
    [[ZCUICore getUICore] getChatMessages];
}

// 销毁界面
-(void)dismissZCChatView{
    [self removeFromSuperview];
    
}


#pragma mark -- 原普通版使用
-(ZCLibConfig *)getZCLibConfig{
    return [self getPlatformInfo].config;
}

-(ZCPlatformInfo *) getPlatformInfo{
    return [[ZCPlatformTools sharedInstance] getPlatformInfo];
}




- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat sectionHeaderHeight = 40;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    }
    else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}
#pragma mark UITableView delegate Start
// 返回section数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

// 返回section高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(_isNoMore && section == 0){
        return TableSectionHeight;
    }
//    if(section == 1 && _zcKeyboardView && !_zcKeyboardView.vioceTipLabel.hidden){
//        return 40;
//    }
    return 0;
}

// 返回section 的View
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(_isNoMore && section == 0){
        
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, TableSectionHeight)];
        [view setBackgroundColor:[UIColor clearColor]];
        
        UILabel *lbl=[[UILabel alloc] initWithFrame:CGRectMake(20, 19, viewWidth-40, TableSectionHeight -19)];
        lbl.font=[ZCUITools zcgetListKitDetailFont];
        lbl.backgroundColor = [UIColor clearColor];
        [lbl setTextAlignment:NSTextAlignmentCenter];
        // 没有更多记录的颜色
        [lbl setTextColor:[ZCUITools zcgetTimeTextColor]];
        [lbl setAutoresizesSubviews:YES];
        [lbl setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [lbl setText:ZCSTLocalString(@"到顶了，没有更多")];
        [view addSubview:lbl];
        return view;
    }
    
    if(section == 1){
        
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 40)];
        [view setBackgroundColor:[UIColor clearColor]];
        return view;
    }
    
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

// 返回section下得行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 1){
        return 0;
    }
    return [ZCUICore getUICore].chatMessages.count;
}

// cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZCLibMessage *model=[[ZCUICore getUICore].chatMessages objectAtIndex:indexPath.row];
    ZCChatBaseCell *cell=nil;
    
    // 设置内容
    if(model.tipStyle>0){
        if (model.tipStyle == ZCReceivedMessageEvaluation) {
            cell = (ZCSatisfactionCell *)[tableView dequeueReusableCellWithIdentifier:cellSatisfactionIndentifier];
            if (cell == nil) {
                cell = [[ZCSatisfactionCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellSatisfactionIndentifier];
            }
        }else{
            cell = (ZCTipsChatCell*)[tableView dequeueReusableCellWithIdentifier:cellTipsIdentifier];
            if (cell == nil) {
                cell = [[ZCTipsChatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellTipsIdentifier];
            }
        }
    }else if(model.tipStyle == ZCReceivedMessageUnKonw){
        // 商品内容
        cell = (ZCGoodsCell*)[tableView dequeueReusableCellWithIdentifier:cellGoodsIndentifier];
        if (cell == nil) {
            cell = [[ZCGoodsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellGoodsIndentifier];
        }
    }else if(model.richModel.msgType==1){
        cell = (ZCImageChatCell*)[tableView dequeueReusableCellWithIdentifier:cellImageIdentifier];
        if (cell == nil) {
            cell = [[ZCImageChatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellImageIdentifier];
        }
    }else if(model.richModel.msgType == 0 && model.richModel.answerType != 15){ // TODO 测试添加消息展示样式 && model.richModel.answerType != 1
        cell = (ZCRichTextChatCell*)[tableView dequeueReusableCellWithIdentifier:cellRichTextIdentifier];
        if (cell == nil) {
            cell = [[ZCRichTextChatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellRichTextIdentifier];
        }
    }else if(model.richModel.msgType==2){
        cell = (ZCVoiceChatCell*)[tableView dequeueReusableCellWithIdentifier:cellVoiceIdentifier];
        if (cell == nil) {
            cell = [[ZCVoiceChatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellVoiceIdentifier];
        }
    }else if (model.richModel.msgType == 7){
        cell = (ZCHotGuideCell*)[tableView dequeueReusableCellWithIdentifier:cellHotGuideIdentifier];
        if (cell == nil) {
            cell = [[ZCHotGuideCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellHotGuideIdentifier];
        }
    }else if(model.richModel.msgType == 15){
        if (model.richModel.multiModel.msgType == 0){
            // 横向的collection
            cell = (ZCHorizontalRollCell*)[tableView dequeueReusableCellWithIdentifier:cellHorizontalRollIndentifier];
            if (cell == nil) {
                cell =  [[ZCHorizontalRollCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellHorizontalRollIndentifier];
            }
        }else if (model.richModel.multiModel.msgType== 1){
            cell = (ZCMultiItemCell*)[tableView dequeueReusableCellWithIdentifier:cellMultilItemIndentifier];
            if (cell) {
                cell =  [[ZCMultiItemCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellMultilItemIndentifier];
            }
        }else if (model.richModel.multiModel.msgType == 2){
            cell = (ZCVerticalRollCell*)[tableView dequeueReusableCellWithIdentifier:cellVerticalRollIndentifier];
            if (cell) {
                cell = [[ZCVerticalRollCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellVerticalRollIndentifier];
            }
        }else if (model.richModel.multiModel.msgType == 3){
            cell = (ZCMultiRichCell*)[tableView dequeueReusableCellWithIdentifier:cellMultiRichIdentifier];
            if (cell) {
                cell = [[ZCMultiRichCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellMultiRichIdentifier];
            }
        }
    }else{
        cell = (ZCRichTextChatCell*)[tableView dequeueReusableCellWithIdentifier:cellRichTextIdentifier];
        if (cell == nil) {
            cell = [[ZCRichTextChatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellRichTextIdentifier];
        }
    }
    
    
    cell.viewWidth = _listTable.frame.size.width;
    cell.delegate=self;
    NSString *time=@"";
    NSString *format=@"MM-dd HH:mm";
    
    if([model.cid isEqual:[self getZCLibConfig].cid]){
        format=@"HH:mm";
    }
    
    
    if(indexPath.row>0){
        ZCLibMessage *lm=[[ZCUICore getUICore].chatMessages objectAtIndex:(indexPath.row-1)];
        if(![model.cid isEqual:lm.cid]){
            //            time=intervalSinceNow(model.ts);
            time = zcLibDateTransformString(format, zcLibStringFormateDate(model.ts));
        }
    }else{
        time = zcLibDateTransformString(format, zcLibStringFormateDate(model.ts));
    }
    
    if([self getZCLibConfig].isArtificial){
        model.isHistory = YES;
    }
    
    if(model.tipStyle == 2){
        time = @"";
    }
    
    [cell InitDataToView:model time:time];
    
    [cell setBackgroundColor:[UIColor clearColor]];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;
}

// table 行的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZCLibMessage *model =[[ZCUICore getUICore].chatMessages objectAtIndex:indexPath.row];
    NSString *time=@"";
    NSString *format=@"MM-dd HH:mm";
    if([model.cid isEqual:[self getZCLibConfig].cid]){
        format=@"HH:mm";
    }
    
    if(indexPath.row>0){
        ZCLibMessage *lm=[[ZCUICore getUICore].chatMessages objectAtIndex:(indexPath.row-1)];
        if(![model.cid isEqual:lm.cid]){
            //            time=intervalSinceNow(model.ts);
            time = zcLibDateTransformString(format, zcLibStringFormateDate(model.ts));
        }
        //        [ZCLogUtils logHeader:LogHeader debug:@"============\n%@\ncur=%@\nlast=%@\ntime=%@",model,model.cid,lm.cid,time];
    }else{
        time = zcLibDateTransformString(format, zcLibStringFormateDate(model.ts));
        //        time=intervalSinceNow(model.ts);
    }
    
    if(model.tipStyle == 2){
        time = @"";
    }
    
    CGFloat cellheight = 0;
    
    // 设置内容
    if(model.tipStyle>0){
        
        if(model.tipStyle == ZCReceivedMessageEvaluation){
            // 评价cell的高度
            cellheight = [ZCSatisfactionCell getCellHeight:model time:time viewWith:viewWidth];
        }else{
            // 提示cell的高度
            cellheight = [ZCTipsChatCell getCellHeight:model time:time viewWith:viewWidth];
        }
        
    }else if(model.tipStyle == ZCReceivedMessageUnKonw){
        // 商品内容
        cellheight = [ZCGoodsCell getCellHeight:model time:time viewWith:viewWidth];
    }else if(model.richModel.msgType==1){
        cellheight = [ZCImageChatCell getCellHeight:model time:time viewWith:viewWidth];
    }else if(model.richModel.msgType==0){
        cellheight = [ZCRichTextChatCell getCellHeight:model time:time viewWith:viewWidth];
    }else if(model.richModel.msgType==2){
        cellheight = [ZCVoiceChatCell getCellHeight:model time:time viewWith:viewWidth];
    }else if (model.richModel.msgType == 7){
        cellheight = [ZCHotGuideCell getCellHeight:model time:time viewWith:viewWidth];
    }else if(model.richModel.msgType==15){
        if (model.richModel.multiModel.msgType == 0){
            cellheight = [ZCHorizontalRollCell getCellHeight:model time:time viewWith:viewWidth];
        }else if (model.richModel.multiModel.msgType == 1){
            cellheight = [ZCMultiItemCell getCellHeight:model time:time viewWith:viewWidth];
        }else if (model.richModel.multiModel.msgType == 2){
            cellheight = [ZCVerticalRollCell getCellHeight:model time:time viewWith:viewWidth];
        }else if (model.richModel.multiModel.msgType == 3){
            cellheight = [ZCMultiRichCell getCellHeight:model time:time viewWith:viewWidth];
        }
    }else{
        cellheight = [ZCRichTextChatCell getCellHeight:model time:time viewWith:viewWidth];
    }
    return cellheight;
}

// table 行的点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark table cell delegate start  cell点击的代理事件
-(void)cellItemClick:(ZCLibMessage *)model type:(ZCChatCellClickType)type obj:(id)object{
  
    if (type == ZCChatCellClickTypeCollectionBtnSend) {
        // 展开和收起
        [self.listTable reloadData];
        [self scrollTableToBottom];
        return;
    }
    
    if ([_keyboardTools getKeyBoardViewStatus] == ZCKeyboardStatusNewSession && type == ZCChatCellClickTypeItemChecked) {
        [[ZCUICore getUICore] addTipsListenerMessage:ZCTipCellMessageOverWord];
        return;
    }
    
    if(type == ZCChatCellClickTypeSendGoosText && ![self getZCLibConfig].isArtificial){
        return;
    }
    
    if (type == ZCChatCellClickTypeShowToast) {
        [[ZCUIToastTools shareToast] showToast:[NSString stringWithFormat:@"   %@  ",ZCSTLocalString(@"复制成功！")] duration:1.0f view:self.superController.view.window.rootViewController.view position:ZCToastPositionCenter Image:[ZCUITools zcuiGetBundleImage:@"zcicon_successful"]];
        return;
    }
    
    // 点击满意度，调评价
    if (type == ZCChatCellClickTypeSatisfaction) {

    }
    
    if (type == ZCChatCellClickTypeLeaveMessage) {
        // 不直接退出SDK
        [self jumpNewPageVC:ZC_LeaveMsgPage IsExist:2 isShowToat:NO tipMsg:@"" Dict:nil];
    }
    
    if(type==ZCChatCellClickTypeTouchImageYES){
        xhObj = object;
        [_keyboardTools hideKeyboard];
    }
    
    if(type==ZCChatCellClickTypeTouchImageNO){
        // 隐藏大图查看
        xhObj = nil;
    }
    
    if(type==ZCChatCellClickTypeItemChecked){
        // 向导内容
        NSDictionary *dict = model.richModel.suggestionArr[[object intValue]];
        if(dict==nil || dict[@"question"]==nil){
            return;
        }
        [[ZCUICore getUICore] sendMessage:[NSString stringWithFormat:@"%d、%@",[object intValue]+1,dict[@"question"]] questionId:dict[@"docId"] type:ZCMessageTypeText duration:@""];
    }
    
    // 发送商品信息给客服
    if(type == ZCChatCellClickTypeSendGoosText){
        [[ZCUICore getUICore] sendMessage:object questionId:@"" type:ZCMessageTypeText duration:@""];
    }
    
    // 重新发送
    if(type==ZCChatCellClickTypeReSend){
        // 当前的键盘样式是新会话的样式，重新发送的消息不在发送  （用户超时下线提示和会话结束提示）
        //        [self.zcKeyboardView getKeyBoardViewStatus] == AGAINACCESSASTATUS
        if ([_keyboardTools getKeyBoardViewStatus] == ZCKeyboardStatusNewSession) {
            [_listTable reloadData];
            return;
        }
        
        [[ZCLibServer getLibServer] sendMessage:model.richModel.msg questionId:@"" msgType:model.richModel.msgType duration:model.richModel.duration config:[self getZCLibConfig] robotFlag:[ZCLibClient getZCLibClient].libInitInfo.robotId start:^(ZCLibMessage *message) {
            model.sendStatus = 1;
            [_listTable reloadData];
        } success:^(ZCLibMessage *message, ZCMessageSendCode sendCode) {
            model.sendStatus = message.sendStatus;
            
            if(![self getZCLibConfig].isArtificial && sendCode == ZC_SENDMessage_New){
                NSInteger index = [[ZCUICore getUICore].listArray indexOfObject:model];
                
                // 如果返回的数据是最后一轮，当前的多轮会话的cell不可点击
                // 记录下标
                if ( [zcLibConvertToString([NSString stringWithFormat:@"%d",message.richModel.answerType]) hasPrefix:@"15"]  && message.richModel.multiModel.endFlag) {
                    for (ZCLibMessage *message in [ZCUICore getUICore].listArray) {
                        if ([zcLibConvertToString([NSString stringWithFormat:@"%d",message.richModel.answerType]) hasPrefix:@"15"] && !message.richModel.multiModel.endFlag && !message.richModel.multiModel.isHistoryMessages ) {
                            message.richModel.multiModel.isHistoryMessages = YES;// 变成不可点击，成为历史
                        }
                    }
                }
                [[ZCUICore getUICore].listArray insertObject:message atIndex:index+1];
                [_listTable reloadData];
                [self scrollTableToBottom];
            }else if(sendCode == ZC_SENDMessage_Success){
                model.sendStatus = 0;
                model.richModel.msgtranslation = message.richModel.msgtranslation;
                
                [_listTable reloadData];
            }else{
                model.sendStatus = 2;
                [_listTable reloadData];
            }
        } progress:^(ZCLibMessage *message) {
            model.progress = message.progress;
            [_listTable reloadData];
        } fail:^(ZCLibMessage *message, ZCMessageSendCode errorCode) {
            model.sendStatus = 2;
            [_listTable reloadData];
            
        }];
    }
    
    if(type==ZCChatCellClickTypePlayVoice  || type == ZCChatCellClickTypeReceiverPlayVoice){
        if([ZCUICore getUICore].animateView){
            [[ZCUICore getUICore].animateView stopAnimating];
        }
        
        // 已经有播放的，关闭当前播放的
        if(_voiceTools){
            [_voiceTools stopVoice];
        }
        
        if([ZCUICore getUICore].playModel){
            [ZCUICore getUICore].playModel.isPlaying=NO;
            [ZCUICore getUICore].playModel=nil;
        }
        
        if([object isEqual:[ZCUICore getUICore].animateView]){
            [ZCUICore getUICore].animateView = nil;
            return;
        }
        
        
        [ZCUICore getUICore].playModel=model;
        [ZCUICore getUICore].playModel.isPlaying=YES;
        
        [ZCUICore getUICore].animateView=object;
        
        [[ZCUICore getUICore].animateView startAnimating];
        
        // 本地文件
        if(zcLibCheckFileIsExsis(model.richModel.msg)){
            if(_voiceTools){
                [_voiceTools playAudio:[NSURL fileURLWithPath:model.richModel.msg] data:nil];
            }
        }else{
            NSString *voiceURL=model.richModel.msg;
            NSString *dataPath = zcLibGetDocumentsFilePath(@"/sobot/");
            // 创建目录
            zcLibCheckPathAndCreate(dataPath);
            
            // 拼接完整的地址
            dataPath=[dataPath stringByAppendingString:[NSString stringWithFormat:@"/%@.wav",zcLibMd5(voiceURL)]];
            if(zcLibCheckFileIsExsis(dataPath)){
                if(_voiceTools){
                    [_voiceTools playAudio:[NSURL fileURLWithPath:dataPath] data:nil];
                }
                return;
            }
            
            // 下载，播放网络声音
            [[ZCLibServer getLibServer] downFileWithURL:model.richModel.msg start:^{
                
            } success:^(NSData *data) {
                [data writeToFile:dataPath atomically:YES];
                if(_voiceTools){
                    [_voiceTools playAudio:[NSURL fileURLWithPath:dataPath] data:nil];
                }
            } progress:^(float progress) {
                
            } fail:^(ZCNetWorkCode errorCode) {
                
            }];
        }
    }
    
    // 转人工
    if(type == ZCChatCellClickTypeConnectUser){
        [[ZCUICore getUICore] turnUserService:nil object:nil];
    }
    
    // 踩/顶   -1踩   1顶
    if(type == ZCChatCellClickTypeStepOn || type == ZCChatCellClickTypeTheTop){
        int status = (type == ZCChatCellClickTypeStepOn)?-1:1;
        
        [[ZCLibServer getLibServer] rbAnswerComment:[self getZCLibConfig] message:model status:status start:^{
            
        } success:^(ZCNetWorkCode code) {
            if(status== -1){
                model.commentType = 3;
            }else{
                model.commentType = 2;
            }
            [_listTable  reloadData];
            
        } fail:^(ZCNetWorkCode errorCode) {
            
        }];
    }
    
    // collectionView item 点击
    if (type == ZCChatCellClickTypeCollectionSendMsg) {
        //  多轮会话，发送给机器人
        
        NSDictionary * dict = (NSDictionary*)object;
        
        // 发送完成再计数
        [[ZCUICore getUICore] cleanUserCount];
        
        //        * 正在发送的消息对象，方便更新状态
        __block ZCLibMessage    *sendMessage;
        
        __weak ZCChatView *safeVC = self;
        
        if ([self getZCLibConfig].isArtificial || [dict[@"ishotguide"] intValue] == 1) {
            [[ZCUICore getUICore] sendMessage:dict[@"title"] questionId:@"" type:ZCMessageTypeText duration:@""];
            return;
        }
        
        // 发送给机器人
        [[ZCLibServer getLibServer] sendToRobot:dict[@"requestText"] showText:dict[@"title"] questionStr:dict[@"question"] questionFlag:2 msgType:model.richModel.msgType questionId:@"" config:[self getZCLibConfig] robotFlag:[ZCLibClient getZCLibClient].libInitInfo.robotId duration:@"" start:^(ZCLibMessage *message) {
            sendMessage  = message;
            sendMessage.sendStatus=1;
            
            [[ZCUICore getUICore].listArray addObject:sendMessage];
            [safeVC.listTable reloadData];
            [safeVC scrollTableToBottom];
        } success:^(ZCLibMessage *message, ZCMessageSendCode sendCode) {
            [ZCUICore getUICore].isSendToUser = NO;
            [ZCUICore getUICore].isSendToRobot = YES;
            if(sendCode==ZC_SENDMessage_New){
                if(message.richModel
                   && (message.richModel.answerType==3
                       ||message.richModel.answerType==4)
                   && ![ZCUICore getUICore].kitInfo.isShowTansfer
                   && ![ZCLibClient getZCLibClient].isShowTurnBtn){
                    safeVC.unknownWordsCount ++;
                    if([[ZCUICore getUICore].kitInfo.unWordsCount integerValue]==0) {
                        [ZCUICore getUICore].kitInfo.unWordsCount =@"1";
                    }
                    if (safeVC.unknownWordsCount >= [[ZCUICore getUICore].kitInfo.unWordsCount integerValue]) {
                        
                        // 仅机器人的模式不做处理
                        if ([safeVC getZCLibConfig].type != 1) {
                            // 设置键盘的样式 （机器人，转人工按钮显示）
                            [safeVC.keyboardTools setKeyBoardStatus:ZCKeyboardStatusRobot];
                            // 保存在本次有效的会话中显示转人工按钮
                            [ZCLibClient getZCLibClient].isShowTurnBtn = YES;
                        }
                    }
                    
                }
                
                NSInteger index = [[ZCUICore getUICore].listArray indexOfObject:sendMessage];
                
                // 如果返回的数据是最后一轮，当前的多轮会话的cell不可点击
                // 记录下标
                if ( [zcLibConvertToString([NSString stringWithFormat:@"%d",message.richModel.answerType]) hasPrefix:@"15"]  && message.richModel.multiModel.endFlag) {
                    for (ZCLibMessage *message in [ZCUICore getUICore].listArray) {
                        if ([zcLibConvertToString([NSString stringWithFormat:@"%d",message.richModel.answerType]) hasPrefix:@"15"] && !message.richModel.multiModel.endFlag && !message.richModel.multiModel.isHistoryMessages ) {
                            message.richModel.multiModel.isHistoryMessages = YES;// 变成不可点击，成为历史
                        }
                    }
                }
                
                [[ZCUICore getUICore].listArray insertObject:message atIndex:index+1];
                [safeVC.listTable reloadData];
                [safeVC scrollTableToBottom];
            }else if(sendCode==ZC_SENDMessage_Success){
                sendMessage.sendStatus=0;
                sendMessage.richModel.msgtranslation = message.richModel.msgtranslation;
                [safeVC.listTable reloadData];
            }else {
                sendMessage.sendStatus=2;
                [safeVC.listTable reloadData];
                if(sendCode == ZC__SENDMessage_FAIL_STATUS){
                    /**
                     *   给人工发消息没有成功，说明当前已经离线
                     *   1.回收键盘
                     *   2.添加结束语
                     *   3.添加新会话键盘样式
                     *   4.中断计时
                     *
                     **/
                    [[ZCUICore getUICore] cleanUserCount];
                    [[ZCUICore getUICore] cleanAdminCount];
                    [_keyboardTools hideKeyboard];
                    [_keyboardTools setKeyBoardStatus:ZCKeyboardStatusNewSession];
                    [[ZCUICore getUICore] addTipsListenerMessage:ZCTipCellMessageOverWord];
                }
            }
            
        } progress:^(ZCLibMessage *message) {
            [ZCUICore getUICore].isSendToUser = NO;
            [ZCUICore getUICore].isSendToRobot = YES;
            [ZCLogUtils logText:@"上传进度：%f",message.progress];
            sendMessage.progress = message.progress;
            [safeVC.listTable reloadData];
        } failed:^(ZCLibMessage *message, ZCMessageSendCode sendCode) {
            [ZCUICore getUICore].isSendToUser = NO;
            [ZCUICore getUICore].isSendToRobot = YES;
            sendMessage.sendStatus=2;
            [safeVC.listTable reloadData];
        }];
    }
    
}

-(void)cellItemLinkClick:(NSString *)text type:(ZCChatCellClickType)type obj:(NSString *)linkURL{
    if(type==ZCChatCellClickTypeOpenURL){
        if(LinkedClickBlock){
            LinkedClickBlock(linkURL);
        }else{
            if([linkURL hasPrefix:@"tel:"] || zcLibValidateMobile(linkURL)){
                callURL=linkURL;
                
                if (NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_9_x_Max) {
                    //初始化AlertView
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                    message:[linkURL stringByReplacingOccurrencesOfString:@"tel:" withString:@""]
                                                                   delegate:self
                                                          cancelButtonTitle:ZCSTLocalString(@"取消")
                                                          otherButtonTitles:ZCSTLocalString(@"呼叫"),nil];
                    alert.tag=1;
                    [alert show];
                }else{
                    // 打电话
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callURL]];
                }
                
            }else if([linkURL hasPrefix:@"mailto:"] || zcLibValidateEmail(linkURL)){
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:linkURL]];
            }else{
                if (![linkURL hasPrefix:@"https"] && ![linkURL hasPrefix:@"http"]) {
                    linkURL = [@"https://" stringByAppendingString:linkURL];
                }
                
                ZCUIWebController *webPage=[[ZCUIWebController alloc] initWithURL:zcUrlEncodedString(linkURL)];
                if(self.superController.navigationController != nil ){
                    [self.superController.navigationController pushViewController:webPage animated:YES];
                }else{
                    UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:webPage];
                    nav.navigationBarHidden=YES;
                    [self.superController presentViewController:nav animated:YES completion:^{
                        
                    }];
                }
            }
        }
    }
}




// 显示打电话
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag==1){
        if(buttonIndex==1){
            // 打电话
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callURL]];
            
        }
    } else if(alertView.tag==3){
        if(buttonIndex==1){
            // 打开QQ
            [self openQQ:callURL];
            callURL=@"";
        }
    }
}

// 打开QQ，未使用
-(BOOL)openQQ:(NSString *)qq{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",qq]];
    if([[UIApplication sharedApplication] canOpenURL:url]){
        [[UIApplication sharedApplication] openURL:url];
        return NO;
    }
    else{
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://wpa.qq.com/msgrd?v=3&uin=%@&site=qq&menu=yes",qq]]];
        return YES;
    }
}
#pragma mark UITableView delegate end

-(void)configShowNotifion{
    BOOL isShowNotifion = NO;
    if ([[ZCUICore getUICore] getLibConfig].announceMsgFlag == 1) {
        isShowNotifion = YES;
    }
    [[ZCUICore getUICore] setInputListener:_keyboardTools.zc_chatTextView];

        // 初始化结束后添加通告
        [self notifitionTopViewWithisShowTopView:isShowNotifion
                                           Title:[self getPlatformInfo].config.announceMsg
                                      addressUrl:[self getPlatformInfo].config.announceClickUrl
                                         iconUrl:[ZCLibClient getZCLibClient].libInitInfo.notifitionIconUrl];

}

#pragma mark -- 通告栏 eg: “国庆大酬宾。
- (UIView *)notifitionTopViewWithisShowTopView:(BOOL) isShow  Title:(NSString *) title  addressUrl:(NSString *)url iconUrl:(NSString *)icoUrl{
    
    if (!_notifitionTopView && isShow && ![@"" isEqual:zcLibConvertToString(title)]) {
        _notifitionTopView = [[UIView alloc]init];
        _notifitionTopView.frame = CGRectMake(0, 0, viewWidth, 40);
        _notifitionTopView.backgroundColor = [ZCUITools getNotifitionTopViewBgColor];
        _notifitionTopView.alpha = 0.8;
        
        UITapGestureRecognizer * tapAction = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jumpWebView:)];
        
        
        // icon
        ZCUIImageView * icon = [[ZCUIImageView alloc]initWithFrame:CGRectMake(10, 11, 18,18)];
        if (![@"" isEqual:zcLibConvertToString(icoUrl)]) {
            [icon loadWithURL:[NSURL URLWithString:zcUrlEncodedString(icoUrl)] placeholer:[ZCUITools zcuiGetBundleImage:@"ZCIcon_notification_Speak"] showActivityIndicatorView:NO];
        }else{
            [icon setImage:[ZCUITools zcuiGetBundleImage:@"ZCIcon_notification_Speak"]];
        }
        
        icon.contentMode = UIViewContentModeScaleAspectFill;
        [icon setBackgroundColor:[UIColor clearColor]];
        [icon addGestureRecognizer:tapAction];
        [_notifitionTopView addSubview:icon];
        
        
        // title
        UILabel * titleLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(icon.frame) +10, 12, viewWidth - 30- 10-10 - icon.frame.size.width, 16)];
        titleLab.font = [ZCUITools zcgetNotifitionTopViewFont];
        titleLab.textColor = [ZCUITools getNotifitionTopViewLabelColor];
        titleLab.text = title;
        [titleLab addGestureRecognizer:tapAction];
        [_notifitionTopView addSubview:titleLab];
        
        if (![@"" isEqual:zcLibConvertToString(url)]) {
            // arraw
            UIImageView * arrawIcon = [[UIImageView alloc]initWithFrame:CGRectMake(viewWidth - 30, 11, 18, 18)];
            arrawIcon.backgroundColor = [UIColor clearColor];
            [arrawIcon setImage:[ZCUITools zcuiGetBundleImage:@"zcicon_webtitleback_normal"]];
            arrawIcon.transform = CGAffineTransformMakeRotation(M_PI);
            arrawIcon.contentMode = UIViewContentModeScaleAspectFill;
            [arrawIcon addGestureRecognizer:tapAction];
            [_notifitionTopView addSubview:arrawIcon];
            
        }
        [_notifitionTopView addGestureRecognizer:tapAction];
        [self addSubview:_notifitionTopView];
        _notifitionTopView.hidden = !isShow;
    }
    return _notifitionTopView;
}

-(UIButton *)newWorkStatusButton{
    if(!_newWorkStatusButton){
        CGFloat NWY = NavBarHeight;
        if (!self.superController.navigationController.navigationBarHidden) {
            NWY = 0;
        }
        _newWorkStatusButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [_newWorkStatusButton setFrame:CGRectMake(0, NWY, CGRectGetWidth(self.frame), 40)];
        [_newWorkStatusButton setContentEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
        [_newWorkStatusButton setImage:[ZCUITools zcuiGetBundleImage:@"zcicon_tag_nonet"] forState:UIControlStateNormal];
        [_newWorkStatusButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
        [_newWorkStatusButton setBackgroundColor:UIColorFromRGBAlpha(BgNetworkFailColor, 0.8)];
        [_newWorkStatusButton setTitle:[NSString stringWithFormat:@" %@",ZCSTLocalString(@"当前网络不可用，请检查您的网络设置")] forState:UIControlStateNormal];
        [_newWorkStatusButton setTitleColor:UIColorFromRGB(TextNetworkTipColor) forState:UIControlStateNormal];
        [_newWorkStatusButton.titleLabel setFont:[ZCUITools zcgetVoiceButtonFont]];
        [_newWorkStatusButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        
        [self addSubview:_newWorkStatusButton];
        
        _newWorkStatusButton.hidden=YES;
    }
    return _newWorkStatusButton;
}

-(UIButton *)socketStatusButton{
    if(!_socketStatusButton){
        CGFloat SSY = NavBarHeight-44;
        if (!_hideTopViewNav) {
         
            if (ZC_iPhoneX) {
                SSY = 44;
            } else {
                SSY =20;
            }
            
        }
        _socketStatusButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [_socketStatusButton setFrame:CGRectMake(60, SSY, viewWidth-120, 44)];
        [_socketStatusButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
        [_socketStatusButton setBackgroundColor:[UIColor clearColor]];
        [_socketStatusButton setTitle:[NSString stringWithFormat:@"  %@",ZCSTLocalString(@"收取中...")] forState:UIControlStateNormal];
        [_socketStatusButton setTitleColor:[ZCUITools zcgetTopViewTextColor] forState:UIControlStateNormal];
        [_socketStatusButton.titleLabel setFont:[ZCUITools zcgetTitleFont]];
        [_socketStatusButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        
     
        [self addSubview:_socketStatusButton];
        
        
        _socketStatusButton.hidden=YES;
        
        UIActivityIndicatorView *_activityView=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _activityView.hidden=YES;
        _activityView.tag = 1;
        _activityView.center = CGPointMake(_socketStatusButton.frame.size.width/2 - 50, 22);
        [_socketStatusButton addSubview:_activityView];
    }
    return _socketStatusButton;
    
    
}

- (void)jumpWebView:(UITapGestureRecognizer*)tap{
    if ([self getZCLibConfig].announceClickFlag == 1 && ![@"" isEqual:[self getZCLibConfig].announceClickUrl] ) {
        [self cellItemLinkClick:nil type:ZCChatCellClickTypeOpenURL obj:[self getZCLibConfig].announceClickUrl];
    }
}


-(void)cleanHistoryMessage{
    [_keyboardTools hideKeyboard];
    ZCActionSheet *mysheet = [[ZCActionSheet alloc] initWithDelegate:self selectedColor:UIColorFromRGB(TextCleanMessageColor) CancelTitle:ZCSTLocalString(@"取消") OtherTitles:ZCSTLocalString(@"清空聊天记录"), nil];
    mysheet.selectIndex = 1;
    [mysheet show];

}

// 清空聊天记录代理
- (void)actionSheet:(ZCActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        
        // 清空历史记录
        [[ZCUICore getUICore].listArray removeAllObjects];
        _isNoMore = NO;
//        _isClearnHistory = YES;
        [self.listTable reloadData];
        //                [ZCUICore getUICore].isClearnHistory = YES;
        
        [[ZCLibServer getLibServer] cleanHistoryMessage:[self getZCLibConfig].uid success:^(NSData *data) {
            
        } fail:^(ZCNetWorkCode errorCode) {
            
        }];
        
    }
}


-(void)confimGoBack{
    // 隐藏键盘
    [_keyboardTools hideKeyboard];
    
    // 如果用户开起关闭时显示评价的弹框
    if ([ZCUICore getUICore].kitInfo.isOpenEvaluation) {
        
        //  1.是否转接过人工   （人工的评价逻辑）
        //  2.本次会话没有评价过人工
        //  3.没有被拉黑过
        //  4.和人工讲过话
        //  5.仅人工模式，不能评价机器人
//        [[ZCUICore getUICore] keyboardOnClickSatisfacetion:YES];
        
        if (([self getZCLibConfig].isArtificial || [ZCUICore getUICore].isOffline)
            && ![ZCUICore getUICore].isEvaluationService
            && [ZCUICore getUICore].isSendToUser
            && !([[self getZCLibConfig] isblack]|| [ZCUICore getUICore].isOfflineBeBlack)) {
            // 必须评价
            [self JumpCustomActionSheet:ServerSatisfcationBackType andDoBack:YES isInvitation:1 Rating:5 IsResolved:0];
            
        }else if(![ZCUICore getUICore].isEvaluationRobot
                 && [ZCUICore getUICore].isSendToRobot
                 && ![ZCUICore getUICore].isOffline
                 && [self getZCLibConfig].type !=2
                 && ![self getZCLibConfig].isArtificial){
            // 必须评价
            [self JumpCustomActionSheet:RobotSatisfcationBackType andDoBack:YES isInvitation:1 Rating:5 IsResolved:0];
        }else{
            if ([self.keyboardTools getKeyBoardViewStatus] == ZCKeyboardStatusNewSession) {
                [[ZCUICore getUICore].listArray removeAllObjects];
            }
            [_listTable reloadData];
            [self goBackIsKeep];
        }
        
    }else{
        if ([_keyboardTools getKeyBoardViewStatus] == ZCKeyboardStatusNewSession) {
            [[ZCUICore getUICore].listArray removeAllObjects];
            [_listTable reloadData];
        }
        [self goBackIsKeep];
    }
}


-(void)setUI{
    
    if (self.superController.navigationController.navigationBarHidden) {
        [self createTitleView];
    }
    
    _listTable = [[UITableView alloc] initWithFrame:CGRectZero];
    _listTable.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin ;
    _listTable.delegate = self;
    _listTable.dataSource = self;
    
    [_listTable registerClass:[ZCRichTextChatCell class] forCellReuseIdentifier:cellRichTextIdentifier];
    [_listTable registerClass:[ZCImageChatCell class] forCellReuseIdentifier:cellImageIdentifier];
    [_listTable registerClass:[ZCVoiceChatCell class] forCellReuseIdentifier:cellVoiceIdentifier];
    [_listTable registerClass:[ZCTipsChatCell class] forCellReuseIdentifier:cellTipsIdentifier];
    [_listTable registerClass:[ZCGoodsCell class] forCellReuseIdentifier:cellGoodsIndentifier];
    [_listTable registerClass:[ZCSatisfactionCell class] forCellReuseIdentifier:cellSatisfactionIndentifier];
    [_listTable registerClass:[ZCHorizontalRollCell class] forCellReuseIdentifier:cellHorizontalRollIndentifier];
    [_listTable registerClass:[ZCVerticalRollCell class] forCellReuseIdentifier:cellVerticalRollIndentifier];
    [_listTable registerClass:[ZCMultiItemCell class] forCellReuseIdentifier:cellMultilItemIndentifier];
    [_listTable registerClass:[ZCMultiRichCell class] forCellReuseIdentifier:cellMultiRichIdentifier];
    [_listTable registerClass:[ZCHotGuideCell  class] forCellReuseIdentifier:cellHotGuideIdentifier];
    
    [_listTable setSeparatorColor:[UIColor clearColor]];
    [_listTable setBackgroundColor:[UIColor clearColor]];
    _listTable.clipsToBounds=NO;
    _listTable.estimatedRowHeight = 0;
    _listTable.estimatedSectionFooterHeight = 0;
    
    //
    [self insertSubview:_listTable atIndex:0];
    
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [_listTable setTableFooterView:view];
    
    self.refreshControl = [[UIRefreshControl alloc]init];
    self.refreshControl.attributedTitle = nil;
    [self.refreshControl addTarget:self action:@selector(getHistoryMessage) forControlEvents:UIControlEventValueChanged];
    [_listTable addSubview:_refreshControl];
    
    
    _keyboardTools = [[ZCUIKeyboard alloc] initConfigView:self table:_listTable];
    [_keyboardTools handleKeyboard];
    _netWorkTools = [ZCLibNetworkTools shareNetworkTools];
    
    [_keyboardTools handleKeyboard];
    
    // 通道保护
    if([self getZCLibConfig] && [self getZCLibConfig].isArtificial){
        [[ZCIMChat getZCIMChat] checkConnected];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netWorkChanged:) name:ZCNotification_NetworkChange object:nil];
    [[ZCIMChat getZCIMChat] setChatPageState:ZCChatPageStateActive];
    
    // 通知外部可以更新UI
    if(PageClickBlock){
        PageClickBlock(self,ZCPageBlockLoadFinish);
    }
}


-(UIButton *)goUnReadButton{
    if(!_goUnReadButton){
        _goUnReadButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [_goUnReadButton setFrame:CGRectMake(viewWidth - 120, 40, 140, 40)];
        [_goUnReadButton setImage:[ZCUITools zcuiGetBundleImage:@"zcicon_newmessages"] forState:UIControlStateNormal];
        [_goUnReadButton setImage:[ZCUITools zcuiGetBundleImage:@"zcicon_newmessages"] forState:UIControlStateHighlighted];
        
        [_goUnReadButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
        [_goUnReadButton setTitleColor:[ZCUITools zcgetDynamicColor] forState:UIControlStateNormal];
        [_goUnReadButton.titleLabel setFont:[ZCUITools zcgetListKitDetailFont]];
        [_goUnReadButton setContentEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        [_goUnReadButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        _goUnReadButton.layer.cornerRadius = 20;
        _goUnReadButton.layer.borderWidth = 0.75f;
        _goUnReadButton.layer.borderColor = [ZCUITools zcgetBackgroundBottomColor].CGColor;
        _goUnReadButton.layer.masksToBounds = YES;
        [_goUnReadButton setBackgroundColor:[UIColor whiteColor]];
        _goUnReadButton.tag = BUTTON_UNREAD;
        [_goUnReadButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_goUnReadButton];
        _goUnReadButton.hidden=YES;
    }
    return _goUnReadButton;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    viewWidth  = self.frame.size.width;
    viewHeight = self.frame.size.height;
    
//    if (viewWidth <MinViewWidth) {
//        viewWidth = MinViewWidth;
//    }
//    if (viewHeight < MinViewWidth) {
//        viewHeight = MinViewWidth;
//    } 
    
    navHeight = NavBarHeight;
    if(_hideTopViewNav){
        _topView.hidden = YES;
        navHeight = 0;
    }
    // 添加头部信息
    [_topView setFrame:CGRectMake(0, 0, viewWidth, navHeight)];
    
    if (self.sheet !=nil) {
        self.sheet.frame = CGRectMake(0, 0, viewWidth, viewHeight);
    }
    if ([ZCUICore getUICore].isUpFrame) {
        return;
    }
    [_listTable setFrame:CGRectMake(0, navHeight, viewWidth, viewHeight - navHeight - 48 - (ZC_iPhoneX?34:0))];
    
    
    CGFloat BY = viewHeight-BottomHeight;
//    if (ZC_iPhoneX) {
//        BY = viewHeight - BottomHeight - 34;
//    }
    [_keyboardTools setZCChatNavHeight:navHeight];
    _keyboardTools.zc_bottomView.frame = CGRectMake(0, BY, viewWidth, BottomHeight);
    [ZCUICore getUICore].isUpFrame = NO;
}



// 页面点击事件
-(IBAction)buttonClick:(UIButton *) sender{
    
    if (self.superController.navigationController.navigationBarHidden) {
        if(sender.tag == BUTTON_MORE){
            ZCActionSheet *mysheet = [[ZCActionSheet alloc] initWithDelegate:self selectedColor:UIColorFromRGB(TextCleanMessageColor) CancelTitle:ZCSTLocalString(@"取消") OtherTitles:ZCSTLocalString(@"清空聊天记录"), nil];
            mysheet.selectIndex = 1;
            [mysheet show];
            
        }
        if (sender.tag == BUTTON_BACK) {
            [self confimGoBack];
        }
    }
    
    // 未读消息数
    if(sender.tag == BUTTON_UNREAD){
        self.goUnReadButton.hidden = YES;
        int unNum = [[ZCIMChat getZCIMChat] getUnReadNum];
        if(unNum<=[ZCUICore getUICore].chatMessages.count){
            CGRect  popoverRect = [_listTable rectForRowAtIndexPath:[NSIndexPath indexPathForRow:([ZCUICore getUICore].chatMessages.count - unNum) inSection:0]];
            [_listTable setContentOffset:CGPointMake(0,popoverRect.origin.y-40) animated:NO];
        }
        
    }
}

#pragma mark -- 点击评价
-(void)JumpCustomActionSheet:(int) sheetType andDoBack:(BOOL) isBack isInvitation:(int) invitationType Rating:(int)rating IsResolved:(int)isResolve{
    [_keyboardTools hideKeyboard];
    _sheet = [[ZCUICustomActionSheet alloc] initActionSheet:sheetType Name:[ZCUICore getUICore].receivedName Cofig:[self getZCLibConfig] cView:self IsBack:isBack isInvitation:invitationType WithUid:[self getZCLibConfig].uid IsCloseAfterEvaluation:[ZCUICore getUICore].kitInfo.isCloseAfterEvaluation Rating:rating IsResolved:isResolve IsAddServerSatifaction:[ZCUICore getUICore].isAddServerSatifaction];
    _sheet.delegate=self;
    [_sheet showInView:self];
    [ZCUICore getUICore].isDismissSheetPage = NO;
}


- (void)thankFeedBack:(int)type rating:(float)rating IsResolve:(int)isresolve{
    [[ZCUICore getUICore] thankFeedBack:type rating:rating IsResolve:isresolve];
}

-(void)dimissCustomActionSheetPage{
    _sheet = nil;
    [ZCUICore getUICore].isDismissSheetPage = YES;
}

-(void)actionSheetClick:(int)isCommentType{
    if (isCommentType != 4) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if(self.superController.navigationController){
                [[ZCUIToastTools shareToast] showToast:ZCSTLocalString(@"感谢您的反馈^-^!") duration:1.0f view:self.window.rootViewController.view position:ZCToastPositionCenter];
            }else{
                
                [[ZCUIToastTools shareToast] showToast:ZCSTLocalString(@"感谢您的反馈^-^!") duration:1.0f view:self.superController.presentingViewController.view position:ZCToastPositionCenter];
            }
            
        });
    }
    
    if(isCommentType == 1){
//        [[ZCUICore getUICore] thankFeedBack];

        // 评价完成后 结束会话
//       [[ZCLibServer getLibServer] logOut:[[ZCPlatformTools sharedInstance] getPlatformInfo].config];
        [ZCLibClient closeAndoutZCServer:NO];
        [ZCUICore getUICore].isSayHello = NO;
        [ZCUICore getUICore].isShowRobotHello = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

//            if (self.delegate && [self.delegate respondsToSelector:@selector(topViewBtnClick:)]) {
//                [self.delegate topViewBtnClick:Btn_BACK];
//            }
//            [[ZCUICore getUICore] desctory];
            [self goBackIsKeep];
        
        });
    }else if(isCommentType == 0){
        if ([self.keyboardTools getKeyBoardViewStatus] == ZCKeyboardStatusNewSession) {
            [[ZCUICore getUICore].listArray removeAllObjects];
            [_listTable reloadData];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self goBackIsKeep];
        });
    
    }else if (isCommentType == 3){
        [[ZCUICore getUICore] thankFeedBack];
    }else if(isCommentType == 4){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self goBackIsKeep];
        });
    }else{
        // 关闭了评价页面
    }
    
}


- (void)cellItemClick:(int)satifactionType IsResolved:(int)isResolved Rating:(int)rating{
    if (satifactionType == 1) {
        // 弹评价页面
        [[ZCUICore getUICore] CustomActionSheet:ServerSatisfcationNolType andDoBack:NO isInvitation:0 Rating:rating IsResolved:isResolved];
        
    }else{
        // 提交评价
        [[ZCUICore getUICore] commitSatisfactionWithIsResolved:isResolved Rating:rating];
    }
}



#pragma mark 音频播放设置
-(void)voicePlayStatusChange:(ZCVoicePlayStatus)status{
    switch (status) {
        case ZCVoicePlayStatusReStart:
            if([ZCUICore getUICore].animateView){
                [[ZCUICore getUICore].animateView startAnimating];
            }
            break;
        case ZCVoicePlayStatusPause:
            if([ZCUICore getUICore].animateView){
                [[ZCUICore getUICore].animateView stopAnimating];
                
            }
            break;
        case ZCVoicePlayStatusStartError:
            if([ZCUICore getUICore].animateView){
                [[ZCUICore getUICore].animateView stopAnimating];
            }
            break;
        case ZCVoicePlayStatusFinish:
        case ZCVoicePlayStatusError:
            if([ZCUICore getUICore].animateView){
                [[ZCUICore getUICore].animateView stopAnimating];
                [ZCUICore getUICore].animateView=nil;
                
                [ZCUICore getUICore].playModel.isPlaying=NO;
                [ZCUICore getUICore].playModel=nil;
            }
            break;
        default:
            break;
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [_keyboardTools hideKeyboard];
    
    // 隐藏复制小气泡
    [[NSNotificationCenter defaultCenter] postNotificationName:UIMenuControllerDidHideMenuNotification object:nil];
}

#pragma mark 网络链接改变时会调用的方法
-(void)netWorkChanged:(NSNotification *)note
{
    BOOL isReachable = _netWorkTools.isReachable;
    if(!isReachable){
        self.newWorkStatusButton.hidden=NO;
        [_listTable setContentInset:UIEdgeInsetsMake(40, 0, 0, 0)];
        
        if([self getZCLibConfig]==nil){
            [[ZCUILoading shareZCUILoading] showAddToSuperView:self];
        }
        [self insertSubview:_newWorkStatusButton aboveSubview:_notifitionTopView];
    }else{
        self.newWorkStatusButton.hidden=YES;
        [_listTable setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        
        // 初始化数据
        if([self getZCLibConfig]==nil && [@"" isEqual:zcLibConvertToString([self getZCLibConfig].cid)] && ![ZCUICore getUICore].isInitLoading){
            [[ZCUICore getUICore] initConfigData:YES IsNewChat:NO];
        }
    }
}


// 长连接通道发生变化时显示连接状态
-(void)showSoketConentStatus:(ZCConnectStatusCode)status{
    // 连接中
    if(status == ZC_CONNECT_START){
        UIButton *btn = [self socketStatusButton];
        [btn setTitle:[NSString stringWithFormat:@"  %@",ZCSTLocalString(@"收取中...")] forState:UIControlStateNormal];
        UIActivityIndicatorView *activityView  = [btn viewWithTag:1];
        btn.hidden = NO;
        activityView.hidden = NO;
        [activityView startAnimating];
        
        isStartConnectSockt = YES;
        
    }else{
        isStartConnectSockt = NO;
        
        UIButton *btn = [self socketStatusButton];
        UIActivityIndicatorView *activityView  = [btn viewWithTag:1];
        [activityView stopAnimating];
        activityView.hidden = YES;
        
        if(status == ZC_CONNECT_SUCCESS){
            btn.hidden = YES;
        }else{
            [btn setTitle:[NSString stringWithFormat:@"%@",ZCSTLocalString(@"未连接")] forState:UIControlStateNormal];
        }
    }
}

// 接收链接改变
-(void)onConnectStatusChanged:(ZCConnectStatusCode)status{
    
    if(status == ZC_CONNECT_KICKED_OFFLINE_BY_OTHER_CLIENT){
        if(self.superController.navigationController){
            [[ZCUIToastTools shareToast] showToast:ZCSTLocalString(@"您打开了新窗口，本次会话结束") duration:1.0f view:self.window.rootViewController.view position:ZCToastPositionCenter];
        }else{
            [[ZCUIToastTools shareToast] showToast:ZCSTLocalString(@"您打开了新窗口，本次会话结束") duration:1.0f view:self position:ZCToastPositionCenter];
        }
    }else{
        [self showSoketConentStatus:status];
    }
}

-(void)goBackIsKeep{
    if (_keyboardTools) {
        [_keyboardTools removeKeyboardObserver];
        _keyboardTools = nil;
    }
    if (_voiceTools) {
        [_voiceTools stopVoice];
        _voiceTools.delegate = nil;
        _voiceTools = nil;
    }
    
    if (_netWorkTools) {
        [_netWorkTools removeNetworkObserver];
        _netWorkTools = nil;
    }
    
    if ([ZCUICore getUICore].lineModel) {
        [[ZCUICore getUICore].listArray removeObject:[ZCUICore getUICore].lineModel];
    }
    
    
    if([ZCUICore getUICore].listArray && [ZCUICore getUICore].listArray.count>0){
        ZCLibMessage *lastMsg = [[ZCUICore getUICore].listArray lastObject];
        if(lastMsg.tipStyle>0){
            [[ZCPlatformTools sharedInstance] getPlatformInfo].lastMsg = lastMsg.sysTips;
            [[ZCPlatformTools sharedInstance] getPlatformInfo].lastDate = lastMsg.ts;
        } else {
            [[ZCPlatformTools sharedInstance] getPlatformInfo].lastMsg = lastMsg.richModel.msg;
            [[ZCPlatformTools sharedInstance] getPlatformInfo].lastDate = lastMsg.ts;
        }
    }
    [[ZCUICore getUICore] clearData];
    
//    NSMutableArray * cidArray = [NSMutableArray arrayWithArray:[ZCUICore getUICore].cids];
//    NSMutableArray * messageArray = [NSMutableArray arrayWithArray:[ZCUICore getUICore].listArray];
    
    // 如果通道没有建立成功，当前正在链接中  则清空数据，下次重新初始化
    if(isStartConnectSockt){
        [self getPlatformInfo].cidsArray = nil;
        
        [self getPlatformInfo].messageArr = nil;
    }else{
        [self getPlatformInfo].cidsArray = [ZCUICore getUICore].cids;
        [self getPlatformInfo].messageArr = [ZCUICore getUICore].listArray;
    }
    [ZCUICore getUICore].cids = nil;
    [ZCUICore getUICore].listArray = nil;
    [[ZCPlatformTools sharedInstance] savePlatformInfo:[self getPlatformInfo]];
    
    [[ZCIMChat getZCIMChat] setChatPageState:ZCChatPageStateBack];
    if(PageClickBlock){
        PageClickBlock(self,ZCPageBlockGoBack);
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(topViewBtnClick:)]) {
        [self.delegate topViewBtnClick:Btn_BACK];
    }
}


-(void)createTitleView{
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, NavBarHeight)];
    [self.topView setBackgroundColor:[ZCUITools zcgetDynamicColor]];
    [_topView setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth];
    [_topView setAutoresizesSubviews:YES];
    [self addSubview:self.topView];
    
    
    // 用户自定义背景图片
    self.topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, NavBarHeight)];
    [self.topImageView setBackgroundColor:[UIColor clearColor]];
    
    // 如果用户传图片就添加，否则取导航条的默认颜色。
    if ([ZCUITools zcuiGetBundleImage:@"zcicon_navcbgImage"]) {
        [self.topImageView setImage:[ZCUITools zcuiGetBundleImage:@"zcicon_navcbgImage"]];
        [_topImageView setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth];
        self.topImageView.contentMode = UIViewContentModeScaleAspectFill;
        [_topImageView setAutoresizesSubviews:YES];
    }
    //    [self.topView addSubview:self.topImageView];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, NavBarHeight-44, self.frame.size.width- 80*2, 44)];
    [self.titleLabel setFont:[ZCUITools zcgetTitleFont]];
    [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.titleLabel setTextColor:[ZCUITools zcgetTopViewTextColor]];
    [self.titleLabel setBackgroundColor:[UIColor clearColor]];
    [self.titleLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin];
    [self.titleLabel setAutoresizesSubviews:YES];
    
    [self.topView addSubview:self.titleLabel];
    
    self.backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.backButton setFrame:CGRectMake(0, NavBarHeight-44, 64, 44)];
    [self.backButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.backButton setImage:[ZCUITools zcuiGetBundleImage:@"zcicon_titlebar_back_normal"] forState:UIControlStateNormal];
    [self.backButton setImage:[ZCUITools zcuiGetBundleImage:@"zcicon_titlebar_back_normal"] forState:UIControlStateHighlighted];
    [self.backButton setBackgroundColor:[UIColor clearColor]];
    [self.backButton setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [self.backButton setContentEdgeInsets:UIEdgeInsetsZero];
    [self.backButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [self.backButton setAutoresizesSubviews:YES];
    [self.backButton setTitle:ZCSTLocalString(@"返回") forState:UIControlStateNormal];
    [self.backButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
    [self.backButton.titleLabel setFont:[ZCUITools zcgetListKitTitleFont]];
    [self.backButton setTitleColor:[ZCUITools zcgetTopViewTextColor] forState:UIControlStateNormal];
    [self.topView addSubview:self.backButton];
    self.backButton.tag = BUTTON_BACK;
    [self.backButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    self.moreButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.moreButton setFrame:CGRectMake(self.frame.size.width-74, NavBarHeight-44, 74, 44)];
    [self.moreButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.moreButton setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
    [self.moreButton setContentEdgeInsets:UIEdgeInsetsZero];
    [self.moreButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [self.moreButton setAutoresizesSubviews:YES];
    [self.moreButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 15)];
    [self.moreButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 15)];
    [self.moreButton setTitle:@"" forState:UIControlStateNormal];
    [self.moreButton.titleLabel setFont:[ZCUITools zcgetListKitTitleFont]];
    [self.moreButton setTitleColor:[ZCUITools zcgetTopViewTextColor] forState:UIControlStateNormal];
    [self.moreButton setImage:[ZCUITools zcuiGetBundleImage:@"zcicon_btnmore"] forState:UIControlStateNormal];
    [self.moreButton setImage:[ZCUITools zcuiGetBundleImage:@"zcicon_btnmore_press"] forState:UIControlStateHighlighted];
    [self.topView addSubview:self.moreButton];
    self.moreButton.tag = BUTTON_MORE;
    [self.moreButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
}



-(void)setPageBlock:(void (^)(ZCChatView *object,ZCPageBlockType type))pageClick messageLinkClick:(void (^)(NSString *link)) linkBlock{
    PageClickBlock = pageClick;
    LinkedClickBlock = linkBlock;
}


@end
