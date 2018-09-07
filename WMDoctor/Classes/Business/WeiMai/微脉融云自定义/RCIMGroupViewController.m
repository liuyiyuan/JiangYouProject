//
//  RCIMGroupViewController.m
//  Micropulse
//
//  Created by 茭白 on 2017/7/25.
//  Copyright © 2017年 iChoice. All rights reserved.
//

#import "RCIMGroupViewController.h"
#import "WMRCGroupNewsMessage.h"
#import "WMRCGroupNewsMessageCell.h"
#import "WMGroupActivityAPIManager.h"
#import "WMRCDataManager.h"
#import "WMBaseWKWebController.h"
#import "WMGroupMemberAPIManager.h"
#import "WMPatientsInfoAPIManager.h"
#import "WMPatientsInfoParamModel.h"
#import "WMPatientsInfoModel.h"
#import "WMRCConversationHeaderView.h"
#import "WMDoctorVoiceView.h"
#import "WMReplyAwokeView.h"
#import "WMReplyMessage.h"
#import "WMReplyMessageCell.h"

@interface RCIMGroupViewController ()<WMRCChatHeaderViewDelegate>{
    NSMutableArray *_groupMembers;
    NSString *_title;
    NSInteger _pageNum;
}
@property(nonnull,strong)UIBarButtonItem * clearItem;
@property (nonatomic ,strong)WMRCConversationHeaderView *conversationHeaderView;
@property (nonatomic, assign)long lastIndex;
@property (nonatomic, strong)WMDoctorVoiceView *doctorVoiceView;
@property (nonatomic, strong)WMReplyAwokeView *replyAwokeView;
@property (nonatomic, strong)RCMessageModel *selectedMsgModel;

@end

@implementation RCIMGroupViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.title = _title;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ClickChatBtn" object:nil userInfo:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupData];
    [self operatePluginBoardView];
    [self registerClass:[WMRCGroupNewsMessageCell class] forMessageClass:[WMRCGroupNewsMessage class]];
    [self registerClass:[WMReplyMessageCell class] forMessageClass:[WMReplyMessage class]];
    [self setupViews];
    [self setupView];
    [self changeFrame];
    [self setupDoctorVoiceView];
}

- (void)setupData{
    _title = self.title;
    self.lastIndex = 10000;
    _pageNum = 1;
    _groupMembers = [NSMutableArray array];
    [self loadGroupMembersRequest];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendTextValue:) name:@"QuickReplyOftalkNotification" object:@"quickStr"];
}

- (void)setupViews{
    self.title = self.groupName;
    self.clearItem= [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"groupMembers"] style:UIBarButtonItemStylePlain target:self action:@selector(showActionSheet:)];
    self.clearItem.width=50;
    self.clearItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItems = @[self.clearItem];
    self.replyAwokeView = [[WMReplyAwokeView alloc] initWithFrame:CGRectMake(0, -56, kScreen_width, 56)];
    [self.chatSessionInputBarControl addSubview:self.replyAwokeView];
    self.replyAwokeView.hidden = YES;
    [self.chatSessionInputBarControl.switchButton addTarget:self action:@selector(hiddenReplyView) forControlEvents:UIControlEventTouchUpInside];
    [self.chatSessionInputBarControl.additionalButton addTarget:self action:@selector(hiddenReplyView2) forControlEvents:UIControlEventTouchUpInside];
    [self.chatSessionInputBarControl addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

- (void)showActionSheet:(id)sender{
   
    
}

- (RCMessageContent *)willSendMessage:(RCMessageContent *)messageContent{
    
    //判断今日是否发言过
    NSDate * date = [NSDate date];
    LoginModel * loginModel = [WMLoginCache getMemoryLoginModel];
    NSString * todayString = [NSString stringWithFormat:@"%@,%@", [[date description] substringToIndex:10], loginModel.phone];
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"todayFirstSpeak"] isEqualToString:todayString]) {
        
    }
    //注意加一个 判断
    if ([messageContent isKindOfClass:[RCTextMessage class]]) {
        
        RCTextMessage *message = (RCTextMessage*)messageContent;
        NSArray *contentArr = [WMStringUtil splitString:message.content corpsStr:@":"];
        NSArray *preArr = @[@"xwzx", @"hd", @"jbht"];
        
        if (contentArr.count >= 2 && [preArr containsObject:contentArr[0]]) {
            
            WMGroupActivityAPIManager *groupActivityAPIManager = [[WMGroupActivityAPIManager alloc] init];
            NSDictionary *param = @{
                                    @"name" : contentArr[0],
                                    @"code" : contentArr[1]
                                    };
            [groupActivityAPIManager loadDataWithParams:param withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
                WMGroupActivityModel *groupActivityModel = [[WMGroupActivityModel alloc] initWithDictionary:responseObject error:nil];
                NSDictionary *modelDic = @{
                                           @"commentNum" : groupActivityModel.commentNum,
                                           @"liushuihao" : groupActivityModel.liushuihao,
                                           @"shareImgUrl" : groupActivityModel.type,
                                           @"type" : groupActivityModel.type,
                                           @"url" : groupActivityModel.url
                                           };
                
                WMRCGroupNewsMessage *groupMessage = [WMRCGroupNewsMessage messageWithTitle:groupActivityModel.title
                                                                                withShowUrl:groupActivityModel.img
                                                                            withDetailLabel:groupActivityModel.desc
                                                                      withSenateModelString:[self dictionaryToJson:modelDic]
                                                                         withTemplateString:[NSString stringWithFormat:@"%@:%@", contentArr[0], contentArr[1]]];
                
                [[RCIM sharedRCIM] sendMessage:ConversationType_GROUP
                                      targetId:self.targetId
                                       content:groupMessage
                                   pushContent:groupActivityModel.title
                                      pushData:groupActivityModel.title
                                       success:^(long messageId) {
                } error:^(RCErrorCode nErrorCode, long messageId) {}];
                NSLog(@"运营活动data = %@", groupMessage);
            } withFailure:^(ResponseResult *errorResult) {
                NSLog(@"运营活动error = %@", errorResult);
            }];
            
            return nil;
        } else if (self.replyAwokeView.hidden == NO){
            WMReplyMessage *replyMessage = [WMReplyMessage messageWithTargetName:self.replyAwokeView.nameLab.text
                                                               withTargetContent:self.replyAwokeView.contentLab.text
                                                                withReplyMessage:self.chatSessionInputBarControl.inputTextView.text];
            [[RCIM sharedRCIM] sendMessage:ConversationType_GROUP
                                  targetId:self.targetId
                                   content:replyMessage
                               pushContent:self.chatSessionInputBarControl.inputTextView.text
                                  pushData:self.chatSessionInputBarControl.inputTextView.text
                                   success:^(long messageId) {
                                       NSLog(@"回复成功:%@", self.chatSessionInputBarControl.inputTextView.text);
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           [self hiddenReplyView2];
                                       });
                                   }
                                     error:^(RCErrorCode nErrorCode, long messageId) {
                                         NSLog(@"回复失败");
                                     }];
            return nil;
        }
    }
    return messageContent;
}

- (void)sendTextValue:(NSNotification*)sender{
    RCTextMessage *testMessage=[RCTextMessage messageWithContent:[sender.userInfo objectForKey:@"theQuickStr"]];
    [self.chatSessionInputBarControl resetToDefaultStatus];
    [[RCIM sharedRCIM] sendMessage:ConversationType_GROUP
                          targetId:self.targetId
                           content:testMessage
                       pushContent:nil
                          pushData:nil
                           success:^(long messageId) {
                               NSLog(@"发送成功。当前消息ID：%ld", messageId);
                           } error:^(RCErrorCode nErrorCode, long messageId) {
                               NSLog(@"发送失败。消息ID：%ld， 错误码：%ld", messageId, (long)nErrorCode);
                           }];
    [self.chatSessionInputBarControl resetToDefaultStatus];
}

- (void)willDisplayMessageCell:(RCMessageBaseCell *)cell
                   atIndexPath:(NSIndexPath *)indexPath{
    RCMessageModel *messageModel = self.conversationDataRepository[indexPath.row];
    RCUserInfo *userInfo=[WMRCUserInfoEntitys getPatientEntity:messageModel.senderUserId];
    if ([cell isKindOfClass:[RCMessageCell class]]) {
        
        UIView * temp = [cell viewWithTag:100];
        [temp removeFromSuperview];
        if (cell.messageDirection==MessageDirection_RECEIVE) {
            RCMessageCell *messageCell = (RCMessageCell *)cell;
            float view_y = 0;
            if (cell.isDisplayMessageTime) {
                view_y = messageCell.nicknameLabel.frame.origin.y+46+46 - 10;
            } else{
                view_y = messageCell.nicknameLabel.frame.origin.y+46 - 10;
            }
            if (messageCell.nicknameLabel) {
                
                UILabel * view =[[UILabel alloc] init];
                view.frame= CGRectMake(messageCell.nicknameLabel.frame.origin.x-46-6-10,view_y, 46, 18);
                view.tag=100;
                view.layer.masksToBounds = YES;
                view.layer.cornerRadius = 9;
                view.backgroundColor = [UIColor colorWithHexString:@"2CD7AA"];
                view.textColor = [UIColor whiteColor];
                view.font = [UIFont systemFontOfSize:10];
                view.textAlignment = NSTextAlignmentCenter;
                if ([userInfo.type intValue] == 1) {
                    view.text = @"医生";
                    [messageCell addSubview:view];
                } else if ([userInfo.type intValue] == 2){
                    view.text = @"助理";
                    [messageCell addSubview:view];
                }
            }
        }
    }
}

- (NSString*)dictionaryToJson:(NSDictionary *)dic{
    
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

- (void)backButtonAction:(UIBarButtonItem*)item{
}

- (void)didTapUrlInMessageCell:(NSString *)url
                         model:(RCMessageModel *)model{
}

//点击头像
- (void)didTapCellPortrait:(NSString *)userId{
    [super didTapCellPortrait:userId];
    
    [[WMRCDataManager shareManager] getUserInfoWithUserId:userId completion:^(RCUserInfo *userInfo) {
        if ([userInfo.type isEqualToString:@"3"]) {
           
        }
        
        //检查更新用户头像
        
    }];
}

//获取长按Cell中的消息时的菜单
- (NSArray<UIMenuItem *> *)getLongTouchMessageCellMenuList:(RCMessageModel *)model{
    _selectedMsgModel = model;
    NSMutableArray<UIMenuItem *> *superMenuList = [[super getLongTouchMessageCellMenuList:model] mutableCopy];
    UIMenuItem *replyItem = [[UIMenuItem alloc] initWithTitle:@"回复" action:@selector(longTouchMessageReply)];
    UIMenuItem *copyItem = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyMessage)];
    NSMutableArray<UIMenuItem *> *menuList = [NSMutableArray new];
    LoginModel * loginModel = [WMLoginCache getMemoryLoginModel];
    if ([model.senderUserId isEqualToString:[loginModel.userCode stringValue]]) {
        //自己发的
        if ([model.content isKindOfClass:[WMReplyMessage class]]) {
            //回复内容
            [menuList addObject:copyItem];
            [menuList addObjectsFromArray:superMenuList];
            return menuList;
        } else if([model.content isKindOfClass:[RCTextMessage class]]){
            //不是回复内容
            return superMenuList;
        }
    }
    
    //不是自己发的
    //回复内容
    if ([model.content isKindOfClass:[WMReplyMessage class]]) {
        [menuList addObject:replyItem];
        [menuList addObject:copyItem];
        [menuList addObjectsFromArray:superMenuList];
        [self.replyAwokeView setValueWithModel:model];
        return menuList;
    } else if([model.content isKindOfClass:[RCTextMessage class]]){
        //不是回复内容
        [menuList addObject:replyItem];
        [menuList addObjectsFromArray:superMenuList];
        [self.replyAwokeView setValueWithModel:model];
        return menuList;
    }
    return superMenuList;
}

//长按cell中菜单中“回复”按钮
- (void)longTouchMessageReply{
    [self.chatSessionInputBarControl.inputTextView becomeFirstResponder];
    self.replyAwokeView.hidden = NO;
}

- (void)copyMessage{
    if (_selectedMsgModel && [_selectedMsgModel.content isKindOfClass:[WMReplyMessage class]]) {
        WMReplyMessage *replyMessage = (WMReplyMessage *)_selectedMsgModel.content;
        UIPasteboard * pastboard = [UIPasteboard generalPasteboard];
        pastboard.string = replyMessage.replyMessage;
    }
}

- (void)hiddenReplyView{
    self.replyAwokeView.hidden = YES;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"frame"]) {
        if (self.chatSessionInputBarControl.top == kScreen_height - 50) {
            self.replyAwokeView.hidden = YES;
        }
    }
}

#pragma mark-- 聊天界面下方的输入工具栏的改动
- (void)operatePluginBoardView{
    //删除扩充框里面的地图
    [self.chatSessionInputBarControl.pluginBoardView removeItemWithTag:PLUGIN_BOARD_ITEM_LOCATION_TAG];
    UIImage *retalkImage=[UIImage imageNamed:@"wm_im_retalk"];
    
    //或添加到最后的：
    [self.chatSessionInputBarControl.pluginBoardView insertItemWithImage:retalkImage
                                                                   title:@"快捷回复"
                                                                     tag:201];
}

#pragma mark-- 聊天界面下方的输入工具栏的代理事件
- (void)pluginBoardView:(RCPluginBoardView *)pluginBoardView
     clickedItemWithTag:(NSInteger)tag {
    switch (tag) {
        case 201: {
            //新版快捷回复
            
        } break;
        default:
            [super pluginBoardView:pluginBoardView clickedItemWithTag:tag];
            break;
    }
}

//获取群成员
- (void)loadGroupMembersRequest{
    WMGroupMemberAPIManager *groupMemberAPIManager=[[WMGroupMemberAPIManager alloc] init];
    NSDictionary *param = @{
                            @"qunbianhao" : self.targetId
                            };
    [groupMemberAPIManager loadDataWithParams:param withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        WMGroupMemberModel *groupMembers = [[WMGroupMemberModel alloc] initWithDictionary:responseObject error:nil];
        [_groupMembers removeAllObjects];
        [_groupMembers addObjectsFromArray: groupMembers.result];
        for (WMOneMemberModel *member in _groupMembers) {
            if ([member.userType intValue] == 1 || [member.userType intValue] == 2) {
                RCUserInfo *userInfo=[WMRCUserInfoEntitys getPatientEntity:member.rongcloudId];
                userInfo.type = member.userType;
                [WMRCUserInfoEntitys savePatientEntity:userInfo];
            }
        }
        if (_groupMembers.count > 0) {
           
        }
        if ([groupMembers.currentUserType isEqualToString:@"2"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"DoctorVoiceChangeFrame" object:nil userInfo:nil];
        }
    } withFailure:^(ResponseResult *errorResult) {
        NSLog(@"群成员error = %@", errorResult);
    }];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"QuickReplyOftalkNotification" object:@"quickStr"];
    [self.chatSessionInputBarControl removeObserver:self forKeyPath:@"frame"];
}

- (void)changeFrame{
    self.conversationMessageCollectionView.frame=CGRectMake(0, 100, kScreen_width, kScreen_height-100);
}

#pragma mark--布局表头的选择按钮
- (void)setupView{
    self.conversationHeaderView=[[WMRCConversationHeaderView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight, kScreen_width, 36)];
    self.conversationHeaderView.delegate=self;
    [self.view addSubview:self.conversationHeaderView];
    self.conversationMessageCollectionView.frame=CGRectMake(0, 64, kScreen_width, kScreen_height-64);
}

//聊天
- (void)healthRecordAction:(UIButton *)button{
    self.doctorVoiceView.hidden = YES;
}

//今日医声
- (void)chatAction:(UIButton *)button{
    self.doctorVoiceView.hidden = NO;
    [self.chatSessionInputBarControl resetToDefaultStatus];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setupDoctorVoiceView{
    self.doctorVoiceView = [[WMDoctorVoiceView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight + 36, kScreen_width, kScreen_height - SafeAreaTopHeight - 36)];
    self.doctorVoiceView.targetId = self.targetId;
    [self.doctorVoiceView setupDoctorVoiceView];
    [self.view addSubview:self.doctorVoiceView];
    self.doctorVoiceView.hidden = YES;
}

- (void)chatInputBar:(RCChatSessionInputBarControl *)chatInputBar shouldChangeFrame:(CGRect)frame{
    [super chatInputBar:chatInputBar shouldChangeFrame:frame];
    if (self.replyAwokeView.hidden == NO) {
        //此时显示
        CGRect collectionViewRect = self.conversationMessageCollectionView.frame;
        collectionViewRect.size.height = CGRectGetMinY(frame) - collectionViewRect.origin.y - 56;
        [self.conversationMessageCollectionView setFrame:collectionViewRect];
        [self scrollToBottomAnimated:NO];
    }
}

- (void)hiddenReplyView2{
    self.replyAwokeView.hidden = YES;
    CGRect collectionViewRect = self.conversationMessageCollectionView.frame;
    collectionViewRect.size.height = self.chatSessionInputBarControl.top - collectionViewRect.origin.y;
    [self.conversationMessageCollectionView setFrame:collectionViewRect];
    [self scrollToBottomAnimated:NO];
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
