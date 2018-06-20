//
//  MicropulseViewController.m
//  WMDoctor
//
//  Created by 茭白 on 2016/12/16.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import "MicropulseViewController.h"
#import "WMSystemMessageViewController.h"
#import "WMServiceViewController.h"
#import "WMRCChatListCell.h"
#import "WMRCChatListSystemCell.h"
#import "WMRCDataManager.h"
#import "AppConfig.h"
#import "WMRCConversationViewController.h"
#import "WMRCInquiryMessage.h"
#import <UMMobClick/MobClick.h>
#import "WMTabBarController.h"
#import "TTTAttributedLabel.h"
#import "WMAllPatientViewController.h"
#import "WMRCChatListSayHelloCell.h"
#import "WMRCBusinessCardMessage.h"
#import "CommonUtil.h"
#import "WMDoctorCertificationResultView.h"
#import "WMPerfectPerInfoViewController.h"
#import "WMCertificationViewController.h"
#import "WMGetStatusAPIManager.h"
#import "WMStatusModel.h"
#import "WMNewGuideViewController.h"
#import <PINCache.h>
#import "WMCacheModel.h"
#import "WMCertificationViewController.h"
#import "WMNavgationController.h"
#import "WMCardiotocographyReportViewController.h"
#import "RCIMGroupViewController.h"
#import "WMGroupRCDataManager.h"
#import "WMRCGroupNewsMessage.h"
#import "WMQuestionsViewController.h"
#import "WMLoginCache.h"
#import "WMMyInformationTableViewController.h"

#define  FORMAT_MODE_REGULAR_LONG @"yyyy-MM-dd HH:mm:ss"

@interface MicropulseViewController ()<
UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate,TTTAttributedLabelDelegate,WMDoctorCerResultViewDelegate>
{
    TTTAttributedLabel *textLable;
}
@property(nonnull, strong)UIBarButtonItem * clearItem;
@property(nonnull, strong)MicropulseViewController *micropulseViewController;
@property(nonatomic, strong)NSMutableArray *systemTargetIdArr;

@end

@implementation MicropulseViewController
#pragma mark--初始化
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setConversationAvatarStyle:RC_USER_AVATAR_CYCLE];
        [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),@(ConversationType_CUSTOMERSERVICE),@(ConversationType_SYSTEM), @(ConversationType_GROUP)]];
        //设置需要将哪些类型的会话在会话列表中聚合显示
        [self setCollectionConversationType:@[@(ConversationType_SYSTEM),@(ConversationType_CUSTOMERSERVICE)]];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didReceiveMessageNotification:)name:RCKitDispatchMessageNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(yindaoEnd)name:@"yindaoEnd" object:nil];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self =[super initWithCoder:aDecoder];
    if (self) {
        [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),@(ConversationType_CUSTOMERSERVICE),@(ConversationType_SYSTEM), @(ConversationType_GROUP)]];
        //设置需要将哪些类型的会话在会话列表中聚合显示
        [self setCollectionConversationType:@[@(ConversationType_SYSTEM),@(ConversationType_CUSTOMERSERVICE)]];
        [self setConversationAvatarStyle:RC_USER_AVATAR_CYCLE];
      
    }
    return self;
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
#pragma mark--视图生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    self.conversationListTableView.backgroundColor=[UIColor colorWithHexString:@"f4f4f4"];

    //打开通知标志
    [self judgeMessagePushState];
    //初始会话类型
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),@(ConversationType_CUSTOMERSERVICE),@(ConversationType_SYSTEM), @(ConversationType_GROUP)]];
    //设置需要将哪些类型的会话在会话列表中聚合显示
    [self setCollectionConversationType:@[@(ConversationType_SYSTEM),@(ConversationType_CUSTOMERSERVICE)]];
    [self setupData];
    //初始化会话页面
    [self setupView];
    [self CertificationResultView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    [MobClick beginLogPageView:NSLocalizedString(NSStringFromClass([self class]), nil)];
    [self.conversationListTableView reloadData];
    [self notifyUpdateUnreadMessageCount];
}

- (void)CertificationResultView{
    WMGetStatusAPIManager * apiManager = [WMGetStatusAPIManager new];
    LoginModel * loginModel = [WMLoginCache getMemoryLoginModel];
    NSString *certificationSuc=[NSString stringWithFormat:@"certificationSuc%@",loginModel.phone];
    NSString *certificationFail=[NSString stringWithFormat:@"certificationFail%@",loginModel.phone];
    [apiManager loadDataWithParams:nil withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        WMStatusModel * statusModel = (WMStatusModel *)responseObject;
        loginModel.certStatus=statusModel.status;
        [WMLoginCache setDiskLoginModel:loginModel];
        [WMLoginCache setMemoryLoginModel:loginModel];
        if (self.conversationListDataSource.count==0) {
            [self showEmptyConversationView];
        }
        if ([statusModel.popup intValue]==1) {
            if (loginModel.userType==NO) {
                
                if (![[[NSUserDefaults standardUserDefaults] objectForKey:certificationSuc]isEqualToString:@"Yes"] &&[statusModel.status isEqualToString:@"2"]) {
                    
                    [[NSUserDefaults standardUserDefaults] setObject: @"Yes"forKey:certificationSuc];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    WMDoctorCertificationResultView *resultView=[[WMDoctorCertificationResultView alloc] initWithText:statusModel.status withMoney:statusModel.money];
                    resultView.delegate=self;
                    [resultView show];
                }
                
                if ([statusModel.status isEqualToString:@"3"]&&![[[NSUserDefaults standardUserDefaults] objectForKey:certificationFail]isEqualToString:@"Yes"] ) {
                    
                    [[NSUserDefaults standardUserDefaults] setObject: @"Yes"forKey:certificationFail];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    WMDoctorCertificationResultView *resultView=[[WMDoctorCertificationResultView alloc] initWithText:statusModel.status withMoney:statusModel.money];
                    resultView.delegate=self;
                    [resultView show];
                    
                }
            }
        }
        } withFailure:^(ResponseResult *errorResult) {
        }];
}

#pragma mark--WMDoctorCerResultViewDelegate
- (void)newbieGuide{
    
    WMNewGuideViewController *certificationVC=[[WMNewGuideViewController alloc] init];
    WorkEnvironment _currentEnvir = [AppConfig currentEnvir];   //获取当前运行环境
    certificationVC.urlString=(_currentEnvir == 0)?H5_URL_NEWGUIDE_FORMAL:H5_URL_NEWGUIDE_TEST;
    certificationVC.hidesBottomBarWhenPushed=YES;
    
    UIWindow *window=[AppDelegate sharedAppDelegate].window;
    WMTabBarController * tabBarController = (WMTabBarController *)window.rootViewController;
    WMNavgationController * navController = (WMNavgationController*)tabBarController.viewControllers[tabBarController.selectedIndex];
    [navController showViewController:certificationVC sender:nil];
}

- (void)continueAuthentication{
    WMCertificationViewController *certificationVC=[[WMCertificationViewController alloc] init];
    certificationVC.hidesBottomBarWhenPushed=YES;
    UIWindow *window=[AppDelegate sharedAppDelegate].window;
    WMTabBarController * tabBarController = (WMTabBarController *)window.rootViewController;
    WMNavgationController * navController = (WMNavgationController*)tabBarController.viewControllers[tabBarController.selectedIndex];
    [navController showViewController:certificationVC sender:nil];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear: animated];
    [MobClick endLogPageView:NSLocalizedString(NSStringFromClass([self class]), nil)];
}

- (void)setupData{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveMessageNotification:)name:RCKitDispatchMessageNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(RongCloudLoginInSuccessNotification:)
                                                 name:kRongCloudLoginInSuccessNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(RongCloudAuthenticationMessageNotification:)name:kRongCloudAuthenticationMessageNotification object:nil];
    
    self.systemTargetIdArr=[[NSMutableArray alloc]initWithCapacity:0];

}
#pragma mark--清除功能按钮
-(void)setClearBarButtonItems{
    self.clearItem=[[UIBarButtonItem alloc]initWithTitle:@"消息盒子" style:UIBarButtonItemStylePlain target:self action:@selector(showActionSheet:)];
    self.clearItem.width=50;
    self.navigationItem.rightBarButtonItems = @[self.clearItem];
    
}

- (void)showActionSheet:(id)sender{
    WMCertificationViewController *vc=[[WMCertificationViewController alloc]init];
    vc.isFirstLogin=NO;
    vc.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark--试图布局
- (void)setupView{
    self.conversationListTableView.separatorColor = [UIColor colorWithHexString:@"E8E8E8"];
    self.conversationListTableView.tableFooterView = [UIView new];
    
}

#pragma mark --onSelectedTableRow
- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType
         conversationModel:(RCConversationModel *)model
               atIndexPath:(NSIndexPath *)indexPath{
    //点击cell，拿到cell对应的model，然后从model中拿到对应的RCUserInfo，然后赋值会话属性，进入会话
    if (model.conversationType==ConversationType_PRIVATE) {//单聊
        
        
        
        //一问医答
        if ([model.senderUserId isEqualToString:@"system000004"]) {
            [[RCIMClient sharedRCIMClient] clearMessagesUnreadStatus:ConversationType_PRIVATE targetId:model.targetId];
            WMQuestionsViewController *questionsViewController = [[WMQuestionsViewController alloc] init];
            questionsViewController.backTitle = @"";
            questionsViewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:questionsViewController animated:YES];
            
            return;
        }
        
        //胎心监护
        if ([model.senderUserId isEqualToString:@"system000003"]) {
            [[RCIMClient sharedRCIMClient] clearMessagesUnreadStatus:ConversationType_PRIVATE targetId:model.targetId];
            UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"WeiMai" bundle:nil];
            WMCardiotocographyReportViewController * settingVC = (WMCardiotocographyReportViewController *)[storyboard instantiateViewControllerWithIdentifier:@"WMCardiotocographyReportViewController"];
            
            settingVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:settingVC animated:YES];
            return;
        }
        
        [[WMRCDataManager shareManager] getUserInfoWithUserId:model.targetId completion:^(RCUserInfo *userInfo) {
            
            WMRCConversationViewController *_conversationVC = [[WMRCConversationViewController alloc]init];
            _conversationVC.conversationType = model.conversationType;
            _conversationVC.targetId = model.targetId;
            _conversationVC.title=userInfo.name;
            _conversationVC.backName=@"微脉";
            _conversationVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:_conversationVC animated:YES];
            
        }];
    } else if (model.conversationType==ConversationType_CUSTOMERSERVICE){//客服
        //小脉助手
        WMServiceViewController *serviceVC=[[WMServiceViewController alloc]init];
        serviceVC.conversationType = ConversationType_CUSTOMERSERVICE;
        serviceVC.targetId = RONGCLOUD_SERVICE_ID;
        serviceVC.title = @"小脉助手";
        serviceVC.backName=@"微脉";
        serviceVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController showViewController:serviceVC sender:nil];
     } else if (model.conversationType==ConversationType_SYSTEM){
        //系统消息
        WMSystemMessageViewController *vc=[[WMSystemMessageViewController alloc]init];
        vc.hidesBottomBarWhenPushed=YES;
        vc.systemTargetIdArr= self.systemTargetIdArr;
        vc.backTitle=NSLocalizedString(@"kText_wemai_back", nil);
        [self.navigationController pushViewController:vc animated:YES];
    } else if (model.conversationType == ConversationType_GROUP){
        //群消息
        [[WMGroupRCDataManager shareManager] getGroupInfoWithGroupId:model.targetId completion:^(RCDGroupInfo *groupInfo) {
            RCIMGroupViewController *_conversationVC = [[RCIMGroupViewController alloc]init];
            _conversationVC.conversationType = ConversationType_GROUP;
            _conversationVC.targetId = model.targetId;
            _conversationVC.groupName = groupInfo.groupName;
            _conversationVC.backName=@"微脉";
            _conversationVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:_conversationVC animated:YES];
        }];
    }
}

- (void)RongCloudLoginInSuccessNotification:(NSNotification *)notification{
    [self refreshConversationTableViewIfNeeded];
    [self notifyUpdateUnreadMessageCount];
}

- (void)RongCloudAuthenticationMessageNotification:(NSNotification *)notification{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self CertificationResultView];
    });
    
}

//插入自定义会话model
-(NSMutableArray *)willReloadTableData:(NSMutableArray *)dataSource{
    
    [self.systemTargetIdArr removeAllObjects];
    for (int i=0; i<dataSource.count; i++) {
        RCConversationModel *model = dataSource[i];
        if(model.conversationType == ConversationType_PRIVATE){
            model.conversationModelType = RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION;
        }
        else if(model.conversationType == ConversationType_CUSTOMERSERVICE){
            model.conversationModelType = RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION;
        }
        else if(model.conversationType == ConversationType_GROUP){
            model.conversationModelType = RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION;
        }
        else if(model.conversationType == ConversationType_SYSTEM){
            model.conversationModelType = RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION;
            [self.systemTargetIdArr addObject:model.targetId];
        }
    }
    return dataSource;
}

#pragma mark- other methods 判断消息推送用户选择状态
- (void)judgeMessagePushState {
    
    if ([[UIDevice currentDevice].systemVersion floatValue]>=8.0f) {
        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if (UIUserNotificationTypeNone == setting.types) {
            [self jumpToSystemNotification];
        }
    }
}
- (void)jumpToSystemNotification{
    //根据个人的手机号码和IsOpenSystemNotification组合为一个独特的编码存与本地 用于保证一个号码只进行一次通知提醒
    //检查一下时间 如果没有一个月，那么就不弹出通知，如果到了一个月 就弹出通知
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"IsOpenSystemNotification"]) {
        //如果存在 比较
        NSString *remindRecordTime=[[NSUserDefaults standardUserDefaults]objectForKey:@"IsOpenSystemNotification"];
        if ([[self setupEffectiveDate] compare:remindRecordTime]!=NSOrderedAscending) {
            [self sendRemindMessage];
            //时间到了
             [PopUpUtil confirmWithTitle:@"哎呀，小脉发现您关闭了通知，这样会错过患者发来的消息，强烈建议您打开哟：" message:@"“设置” -“通知” - “微脉”开启" toViewController:nil buttonTitles:@[@"稍后提醒",@"现在去设置"] completionBlock:^(NSUInteger buttonIndex) {
                if (buttonIndex==1) {
                    
                    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                    if ([[UIApplication sharedApplication] canOpenURL:url]) {
                        
                        [[UIApplication sharedApplication] openURL:url];
                        
                    }
                }
            }];

        } else{
            //时间不到
            NSLog(@"不可以发送");
        }
    } else{
        //如果不存在
        [self sendRemindMessage];
        [PopUpUtil confirmWithTitle:@"哎呀，小脉发现您关闭了通知，这样会错过患者发来的消息，强烈建议您打开哟：" message:@"“设置” -“通知” - “微脉”开启" toViewController:nil buttonTitles:@[@"稍后提醒",@"现在去设置"] completionBlock:^(NSUInteger buttonIndex) {
            if (buttonIndex==1) {
                
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    
                    [[UIApplication sharedApplication] openURL:url];
                    
                }
            }
        }];
    }
}
#pragma mark--获取当前时间
-(NSString *)setupEffectiveDate {
    //获取当前时间
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:FORMAT_MODE_REGULAR_LONG];
    //NSString *dateString = [dateFormatter stringFromDate:currentDate];
    NSTimeInterval time =   1 * 60 * 60 *24 *30;//一年的秒数
    //得到一年之前的当前时间（-：表示向前的时间间隔（即去年），如果没有，则表示向后的时间间隔（即明年））
    NSDate * lastYear = [currentDate dateByAddingTimeInterval:-time];
    
    //转化为字符串
    NSString * startDate = [dateFormatter stringFromDate:lastYear];
    //用startDate这个时间和保留的时间进行比较
    return startDate;
    
}
#pragma mark--本地缓存当前时间
-(void)sendRemindMessage{
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:FORMAT_MODE_REGULAR_LONG];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    [[NSUserDefaults standardUserDefaults]setObject:dateString forKey:@"IsOpenSystemNotification"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark--系统的cell For Row 代理
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RCConversationModel *model = self.conversationListDataSource[indexPath.row];
    if (model.conversationModelType == RC_CONVERSATION_MODEL_TYPE_COLLECTION) {
        WMRCChatListSystemCell *cell = (WMRCChatListSystemCell *)[[WMRCChatListSystemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WMRCChatListSystemCell"];
        WMRCChatListCell *serverCell = (WMRCChatListCell *)[[WMRCChatListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WMRCChatListCell"];
        serverCell.flogImageView.hidden = !model.isTop;
        cell.flogImageView.hidden = !model.isTop;
        if (model.conversationType == ConversationType_CUSTOMERSERVICE) {
            [[WMRCDataManager shareManager] getXiaoMaiHelpInfoWithUserId:model.targetId completion:^(RCUserInfo *info) {
                serverCell.nameLabel.text=info.name;
                [serverCell.avatarImage sd_setImageWithURL:[NSURL URLWithString:info.portraitUri]];
            }];
            if (model.receivedTime == 0) {
                cell.timeLabel.text = @"";
            } else{
                [self timeWithCell:serverCell withModel:model];
            }
            [self showDetailLabelWithModel:model withCell:serverCell];
            [self showRedLabelWithCell:serverCell withModel:model];
            return serverCell;
        } else{
            cell.nameLabel.text = @"微脉消息";
            [self timeWithCell:cell withModel:model];
            [self showDetailLabelWithModel:model withCell:cell];
            [self showRedLabelWithCell:cell withModel:model];
            cell.avatarImage.image = [UIImage imageNamed:@"wm_mess_weimai"];
            return cell;
        }
    } else{
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
}

- (void)removeQuestionsAndAnswerToTheFirstInDataSource{
    for (int i = 0; i < [self.conversationListDataSource count]; i ++) {
        NSLog(@"i : %d", i);
        RCConversationModel *tempModel = [self.conversationListDataSource objectAtIndex:i];
        if ([tempModel.targetId isEqualToString:@"system000004"]) {
            [self.conversationListDataSource exchangeObjectAtIndex:i withObjectAtIndex:0];
            break;
        }
    }
}

- (RCConversationBaseCell *)rcConversationListTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.conversationListDataSource.count&&indexPath.row < self.conversationListDataSource.count) {
        RCConversationModel *model = self.conversationListDataSource[indexPath.row];
        
        if (model.conversationType==ConversationType_PRIVATE) {
            RCMessageContent *lastMessageContent=(RCMessageContent *)model.lastestMessage;
            if ([lastMessageContent isKindOfClass:[RCTextMessage class]]) {
                RCTextMessage *lasConversationMsg=(RCTextMessage *)lastMessageContent;
                WMRCChatListSayHelloCell *sayHelloCell = (WMRCChatListSayHelloCell *)[[WMRCChatListSayHelloCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WMRCChatListSayHelloCell"];
                if ([lasConversationMsg.extra isEqualToString:@"rc_wm_say_hello"]) {
                    
                    if (model.isTop==YES) {
                        sayHelloCell.flogImageView.hidden=NO;
                    }else{
                        sayHelloCell.flogImageView.hidden=YES;
                    }
                    [[WMRCDataManager shareManager] getUserInfoWithUserId:model.targetId completion:^(RCUserInfo *userInfo) {
                        sayHelloCell.nameLabel.text=userInfo.name;
                        
                        [self timeWithCell:sayHelloCell withModel:model];
                        [self showDetailLabelWithModel:model withCell:sayHelloCell];
                        [self showHeadImageViewWithModel:userInfo.portraitUri withCell:sayHelloCell];
                        
                    }];
                     return sayHelloCell;
                }
            }
            
                WMRCChatListCell *cell = (WMRCChatListCell *)[[WMRCChatListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WMRCChatListCell"];
                //cell.doctorPositionLable.text=myselfInfo.QQ;
            //一问医答
            if ([model.targetId isEqualToString:@"system000004"]) {
                //置顶
                [[RCIMClient sharedRCIMClient] setConversationToTop:model.conversationType
                                                           targetId:model.targetId
                                                              isTop:YES];
                model.isTop = YES;
                if ([[NSUserDefaults standardUserDefaults] objectForKey:@"yindaoEnd"] != nil &&
                    [[NSUserDefaults standardUserDefaults] objectForKey:@"WMAskADoctorAwoke"] == nil &&
                    (self.isViewLoaded && self.view.window)) {//20
                    
                    self.awokeView = [[WMAskADoctorAwokeView alloc] initWithFrame:CGRectMake(0, 80 + SafeAreaTopHeight, kScreen_width, kScreen_height - 80 - SafeAreaTopHeight)];
                    self.awokeView.model = self.conversationListDataSource[indexPath.row];
                    [[UIApplication sharedApplication].keyWindow addSubview:self.awokeView];
                    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"WMAskADoctorAwoke"];
                }
                LoginModel * loginModel = [WMLoginCache getMemoryLoginModel];
                NSString *key = [NSString stringWithFormat:@"Shield_%@", loginModel.phone];
                if ([[[NSUserDefaults standardUserDefaults] objectForKey:key] isEqualToString:@"YES"]) {
                    //屏蔽消息
                    [[RCIMClient sharedRCIMClient] setConversationNotificationStatus:ConversationType_PRIVATE
                                                                            targetId:@"system000004"
                                                                           isBlocked:YES
                                                                             success:^(RCConversationNotificationStatus nStatus) {
                                                                                 NSLog(@"设置成功");
                                                                             } error:^(RCErrorCode status) {
                                                                                 NSLog(@"屏蔽一问医答失败");
                                                                             }];
                } else{
                    //接收消息，。
                    [[RCIMClient sharedRCIMClient] setConversationNotificationStatus:ConversationType_PRIVATE
                                                                            targetId:@"system000004"
                                                                           isBlocked:NO
                                                                             success:^(RCConversationNotificationStatus nStatus) {
                                                                                 NSLog(@"设置成功");
                                                                             } error:^(RCErrorCode status) {
                                                                                 NSLog(@"屏蔽一问医答失败");
                                                                             }];
                }
            }
            
                if (model.isTop==YES) {
                    cell.flogImageView.hidden=NO;
                }else{
                    cell.flogImageView.hidden=YES;
                }
            
                [[WMRCDataManager shareManager] getUserInfoWithUserId:model.targetId completion:^(RCUserInfo *userInfo) {
                    cell.nameLabel.text=userInfo.name;
                    [self timeWithCell:cell withModel:model];
                    [self showDetailLabelWithModel:model withCell:cell];
                    [self showRedLabelWithCell:cell withModel:model];
                    [self showHeadImageViewWithModel:userInfo.portraitUri withCell:cell];
                    [self setVIPTag:cell userInfo:userInfo];
                    
                }];
                return cell;
        } else if (model.conversationModelType == ConversationType_GROUP) {
            WMRCChatListCell *cell = (WMRCChatListCell *)[[WMRCChatListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WMRCChatListCell"];
            if (model.isTop==YES) {
                cell.flogImageView.hidden=NO;
            }else{
                cell.flogImageView.hidden=YES;
            }
            
            [[WMGroupRCDataManager shareManager] getGroupInfoWithGroupId:model.targetId  completion:^(RCDGroupInfo *groupInfo) {
                cell.nameLabel.text=groupInfo.groupName;
                [self timeWithCell:cell withModel:model];
                [self showDetailLabelWithModel:model withCell:cell];
                [self showRedLabelWithCell:cell withModel:model];
                [self showHeadImageViewWithModel:groupInfo.portraitUri withCell:cell];
            }];
            return cell;
        } else {
            return [[RCConversationBaseCell alloc]init];
        }
    } else{
        
        return [[RCConversationBaseCell alloc]init];
    }
}


#pragma mark--other
- (NSString *)stringFromDate:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}

- (NSString *)getyyyymmdd{
    NSDate *now = [NSDate date];
    NSDateFormatter *formatDay = [[NSDateFormatter alloc] init];
    formatDay.dateFormat = @"yyyyMMdd";
    NSString *dayStr = [formatDay stringFromDate:now];
    return dayStr;
}

- (void)timeWithCell:(RCConversationBaseCell *)cell withModel:(RCConversationModel *)model{
    
    WMRCChatListCell *ChatListCell=(WMRCChatListCell *)cell;
    //会话接收时间
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.receivedTime/1000];
    NSString *timeStr = [[self stringFromDate:date] substringToIndex:10];
    
    NSString *temp = [self getyyyymmdd];
    NSString *nowDateString = [NSString stringWithFormat:@"%@-%@-%@",[temp substringToIndex:4],[temp substringWithRange:NSMakeRange(4, 2)],[temp substringWithRange:NSMakeRange(6, 2)]];
    
    if ([timeStr isEqualToString:nowDateString]) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm"];
        NSString *showtimeNew = [formatter stringFromDate:date];
        ChatListCell.timeLabel.text = [NSString stringWithFormat:@"%@",showtimeNew];
        
    } else{
        ChatListCell.timeLabel.text = [NSString stringWithFormat:@"%@",timeStr];
    }
}

- (void)showRedLabelWithCell:(RCConversationBaseCell *)cell withModel:(RCConversationModel *)model{
    
    NSInteger unreadCount = model.unreadMessageCount;
    if ([cell isKindOfClass:[WMRCChatListCell class]]) {
        WMRCChatListCell *ChatListCell=(WMRCChatListCell *)cell;
        if (unreadCount==0) {
            ChatListCell.ppBadgeView.backgroundColor=[UIColor clearColor];
            ChatListCell.ppBadgeView.text = @"";
            
        } else{
            if (unreadCount>=100) {
                ChatListCell.ppBadgeView.backgroundColor=[UIColor redColor];
                ChatListCell.ppBadgeView.bounds = CGRectMake(0, 0,26, 20);
                ChatListCell.ppBadgeView.text = @"99+";
            } else{
                ChatListCell.ppBadgeView.backgroundColor=[UIColor redColor];
                ChatListCell.ppBadgeView.text = [NSString stringWithFormat:@"%li",(long)unreadCount];
                
            }
        }

    } else{
        WMRCChatListSystemCell *ChatListCell=(WMRCChatListSystemCell *)cell;
        if (unreadCount==0) {
            ChatListCell.ppBadgeView.backgroundColor=[UIColor clearColor];
            
        } else{
                ChatListCell.ppBadgeView.backgroundColor=[UIColor redColor];
        }
    }
}

- (void)showDetailLabelWithModel:(RCConversationModel *)model withCell:(RCConversationBaseCell *)cell{
    WMRCChatListCell *ChatListCell=(WMRCChatListCell *)cell;
    
    if (model.conversationType == ConversationType_GROUP) {
        [WMRCCommonUtil groupChatListDetailShowWithKit:model detailStr:^(NSString *detailStr) {
            ChatListCell.contentLabel.text = detailStr;
        }];
        return;
    }
    //文字信息
    if ([model.lastestMessage isKindOfClass:[RCTextMessage class]]) {
        
        ChatListCell.contentLabel.text = [model.lastestMessage valueForKey:@"content"];
    } else if ([model.lastestMessage isKindOfClass:[RCInformationNotificationMessage class]]){
        
        //灰色提示语 （自己加的 20170731）
        RCInformationNotificationMessage *lastestMessage=(RCInformationNotificationMessage *)model.lastestMessage;
        if (!stringIsEmpty(lastestMessage.message)) {
            
            ChatListCell.contentLabel.text = lastestMessage.message;
        }
    } else if ([model.lastestMessage isKindOfClass:[RCRichContentMessage class]]){
        
        //图文问诊 （自己加的 20160914）
        ChatListCell.contentLabel.text = @"图文问诊";
    } else if ([model.lastestMessage isKindOfClass:[WMRCInquiryMessage class]]){
        
        //图文问诊 （自己加的 20160914）
        WMRCInquiryMessage *inquiryMessag = (WMRCInquiryMessage *)model.lastestMessage;
        ChatListCell.contentLabel.text = inquiryMessag.inquiryTextMsg;
    } else if ([model.lastestMessage isKindOfClass:[WMRCBusinessCardMessage class]]){
        
        //名片消息 （自己加的 20160914）
        WMRCBusinessCardMessage *inquiryMessag = (WMRCBusinessCardMessage *)model.lastestMessage;
        ChatListCell.contentLabel.text = [NSString  stringWithFormat:@"[%@的名片]", inquiryMessag.name];
    } else if ([model.lastestMessage isKindOfClass:[RCImageMessage class]]){
        
        //图片信息
        ChatListCell.contentLabel.text = @"图片消息";
    } else if ([model.lastestMessage isKindOfClass:[RCVoiceMessage class]]){
        
        //语音信息
        ChatListCell.contentLabel.text = @"语音消息";
    } else if ([model.lastestMessage isKindOfClass:[WMRCGroupNewsMessage class]]){
        
        //医患群的 新闻 咨询消息
        WMRCGroupNewsMessage *lasConversationMsg=(WMRCGroupNewsMessage *)model.lastestMessage;
        ChatListCell.contentLabel.text = lasConversationMsg.title;
    } else if ([model.lastestMessage isKindOfClass:[RCLocationMessage class]]){
        
        //定位信息
        ChatListCell.contentLabel.text = @"位置消息";
    }
}

- (void)showHeadImageViewWithModel:(NSString *)headUrl withCell:(RCConversationBaseCell *)cell{
    WMRCChatListCell *ChatListCell=(WMRCChatListCell *)cell;
    
    [ChatListCell.avatarImage sd_setImageWithURL:[NSURL URLWithString:headUrl] placeholderImage:[UIImage imageNamed:@"bt_bottom_mine1"] options:SDWebImageAllowInvalidSSLCertificates];
}

- (void)setVIPTag:(WMRCChatListCell *)cell userInfo:(RCUserInfo *)userInfo{
    cell.vipTag.frame = CGRectMake([CommonUtil widthForLabelWithText:userInfo.name height:20 font:[UIFont systemFontOfSize:16]] + 10, 1, 30, 18);
    [cell setTagViewWithUserInfo:userInfo];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    [self removeQuestionsAndAnswerToTheFirstInDataSource];
    return  self.conversationListDataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

#pragma mark --右滑删除
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    //一问医答
    RCConversationModel *model = self.conversationListDataSource[indexPath.row];
    if ([model.senderUserId isEqualToString:@"system000004"]) {
        return NO;
    }
    return YES;
}

- (NSArray<UITableViewRowAction*>*)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    RCConversationModel *model = self.conversationListDataSource[indexPath.row];
    UITableViewRowAction *rowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                         title:@"删 除"
                                                                       handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                                                           NSLog(@"删除jjj");
                                                                           //可以从数据库删除数据
                                                                           [self notifyUpdateUnreadMessageCount];
                                                                           [[RCIMClient sharedRCIMClient] removeConversation:model.conversationType targetId:model.targetId];
                                                                           [[RCIMClient sharedRCIMClient] clearMessages:ConversationType_PRIVATE targetId:model.targetId];
                                                                           [self.conversationListDataSource removeObjectAtIndex:indexPath.row];
                                                                           [[WMRCDataManager shareManager] deletePatientInfoFromLocalWithUserId:model.targetId];
                                                                           [self.conversationListTableView reloadData];
                                                                           [self refreshConversationTableViewIfNeeded];
                                                                       }];
    
    UITableViewRowAction *rowActionSec;
    if (model.isTop) {
        
        rowActionSec= [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                         title:@"取消置顶"
                                                       handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                                           [[RCIMClient sharedRCIMClient] setConversationToTop:model.conversationType
                                                                                                      targetId:model.targetId
                                                                                                         isTop:NO];
                                                           model.isTop=NO;
                                                           [self refreshConversationTableViewIfNeeded];
                                                       }];
    }else{
        
        rowActionSec= [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                         title:@"置 顶"
                                                       handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                                           [[RCIMClient sharedRCIMClient] setConversationToTop:model.conversationType
                                                                                                      targetId:model.targetId
                                                                                                         isTop:YES];
                                                           model.isTop=YES;
                                                           for (RCConversationModel *tempModel in self.conversationListDataSource) {
                                                               if ([tempModel.targetId isEqualToString:@"system000004"]) {
                                                                   //置顶
                                                                   [[RCIMClient sharedRCIMClient] setConversationToTop:tempModel.conversationType                                                                                          targetId:tempModel.targetId
                                                                       isTop:YES];
                                                                   tempModel.isTop = YES;
                                                               }
                                                           }
                                                           [self refreshConversationTableViewIfNeeded];
                                                       }];
        
    }
    rowActionSec.backgroundColor=[UIColor colorWithHexString:@"3d94ea"];
    NSArray *arr = @[rowAction,rowActionSec];
    if (model.conversationType == ConversationType_SYSTEM) {
        return @[rowActionSec];
    }
    return arr;
}

#pragma mark-- 空白页面
- (void)showEmptyConversationView{
    //如果 不实现这个方法 就会有默认的图片。
    UIView *blankView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    float width=kScreen_width;
    float top;
    top=85;
    float imageHeight=160*kScreen_width/375.0;
    // 加载失败的图片loadFail_1
    UIImageView* loadingImageView=[[UIImageView alloc]init];
    loadingImageView.frame=CGRectMake((width-imageHeight)*0.5, top, imageHeight, imageHeight);
    loadingImageView.contentMode=UIViewContentModeScaleAspectFit;
    [blankView addSubview:loadingImageView];
    loadingImageView.image=[UIImage imageNamed:@"wm_im_xiaoxiquesheng"];
    
    UILabel * loadingLable=[[UILabel alloc]init];
    loadingLable.frame=CGRectMake((kScreen_width-196)*0.5, loadingImageView.frame.size.height+loadingImageView.frame.origin.y+20, 196, 40);
    loadingLable.font=[UIFont systemFontOfSize:14];
    loadingLable.numberOfLines=0;
    loadingLable.textAlignment=NSTextAlignmentCenter;
    loadingLable.textColor=[UIColor colorWithHexString:@"999999"];
   
    [blankView addSubview:loadingLable];
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake((kScreen_width-175)*0.5, loadingLable.frame.size.height+loadingLable.frame.origin.y+30, 175, 40);
    button.layer.cornerRadius=4;
    button.layer.masksToBounds=YES;
    [button setBackgroundColor:[UIColor colorWithHexString:@"18a2ff"]];
    
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [blankView addSubview:button];
    self.emptyConversationView=blankView;
    [self.view addSubview:self.emptyConversationView];
    
    LoginModel * loginModel = [WMLoginCache getMemoryLoginModel];
    
    if ([loginModel.certStatus intValue]==0||[loginModel.certStatus intValue]==3) {
        //显示前去认证
        button.hidden=NO;
        //正常显示
        button.hidden=NO;
        loadingLable.text=@"暂无消息，认证后享更多微脉医生特权";
        [button setTitle:@"前去认证" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(doctorCertification:) forControlEvents:UIControlEventTouchUpInside];
    } else if ([loginModel.certStatus intValue]==1){
        //显示等待中
        loadingLable.text=@"你已提交实名认证，请耐心等待";
        button.hidden=NO;
        //完善个人信息
        [button setTitle:@"完善个人信息" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(finishInfo) forControlEvents:UIControlEventTouchUpInside];
    } else{
        //正常显示
        button.hidden=NO;
        loadingLable.text=@"暂无患者，您可对患者进行随访主动关怀病情发展";
        [button setTitle:@"随访" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(suifang:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)finishInfo{
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
    WMMyInformationTableViewController * settingVC = (WMMyInformationTableViewController *)[storyboard instantiateViewControllerWithIdentifier:@"WMMyInformationTableViewController"];
    
    settingVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:settingVC animated:YES];
}

- (void)suifang:(UIButton *)button{
    WMAllPatientViewController *allPatientVC=[[WMAllPatientViewController alloc]init];
    allPatientVC.backTitle=@"微脉";
    allPatientVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:allPatientVC animated:YES];
}

- (void)doctorCertification:(UIButton *)button{
    
    WMCertificationViewController *allPatientVC=[[WMCertificationViewController alloc]init];
    allPatientVC.backTitle=@"微脉";
    allPatientVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:allPatientVC animated:YES];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return NO;
}

#pragma mark - 收到消息监听
- (void)didReceiveMessageNotification:(NSNotification *)notification{
    __weak typeof(&*self) blockSelf_ = self;
    //处理好友请求
    RCMessage *message = notification.object;
    LoginModel * loginModel = [WMLoginCache getMemoryLoginModel];
    if ([message.content isMemberOfClass:[RCMessageContent class]]) {
        if (message.conversationType == ConversationType_PRIVATE) {
            @throw  [[NSException alloc] initWithName:@"error" reason:@"好友消息要发系统消息！！！" userInfo:nil];
        }
        RCConversationModel *customModel = [RCConversationModel new];
        //自定义cell的type
        customModel.conversationModelType = RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION;
        customModel.senderUserId = message.senderUserId;
        customModel.lastestMessage = message.content;
        dispatch_async(dispatch_get_main_queue(), ^{
            //调用父类刷新未读消息数
            [blockSelf_ refreshConversationTableViewWithConversationModel:customModel];
            [super didReceiveMessageNotification:notification];
            //[blockSelf_ resetConversationListBackgroundViewIfNeeded];
            [self notifyUpdateUnreadMessageCount];
            
            //当消息为RCContactNotificationMessage时，没有调用super，如果是最后一条消息，可能需要刷新一下整个列表。
            //原因请查看super didReceiveMessageNotification的注释。
            
        });
        
    }else if (message.conversationType == ConversationType_PRIVATE){
        
        
        //获取接受到会话
        RCConversation *receivedConversation = [[RCIMClient sharedRCIMClient] getConversation:message.conversationType targetId:message.targetId];
        
        //转换新会话为新会话模型
        RCConversationModel *customModel = [[RCConversationModel alloc] init:RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION conversation:receivedConversation extend:nil];

        
        if ([customModel.targetId isEqualToString:@"system000004"]) {
            //为一问医答消息
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[NSString stringWithFormat:@"functionCode1001%@",loginModel.phone]];
            [[NSUserDefaults standardUserDefaults] synchronize];
            NSNotification *notification =[NSNotification notificationWithName:@"InfoNotification" object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        }else{
            //为一问医答消息       //咨询服务
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[NSString stringWithFormat:@"functionCode1002%@",loginModel.phone]];
            [[NSUserDefaults standardUserDefaults] synchronize];
            NSNotification *notification =[NSNotification notificationWithName:@"InfoNotification" object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //调用父类刷新未读消息数
            [blockSelf_ refreshConversationTableViewWithConversationModel:customModel];
            [super didReceiveMessageNotification:notification];
            [self notifyUpdateUnreadMessageCount];
            
            //当消息为RCContactNotificationMessage时，没有调用super，如果是最后一条消息，可能需要刷新一下整个列表。
            //原因请查看super didReceiveMessageNotification的注释。
            NSNumber *left = [notification.userInfo objectForKey:@"left"];
            if (0 == left.integerValue) {
                [super refreshConversationTableViewIfNeeded];
            }
        });
        
    } else {
        if (message.conversationType == ConversationType_GROUP) {
            //医疗圈红点设置
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[NSString stringWithFormat:@"functionCode1003%@",loginModel.phone]];
            [[NSUserDefaults standardUserDefaults] synchronize];
            NSNotification *notification =[NSNotification notificationWithName:@"InfoNotification" object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            //调用父类刷新未读消息数
            [super didReceiveMessageNotification:notification];
            [self notifyUpdateUnreadMessageCount];
        });
    }
    [self refreshConversationTableViewIfNeeded];
}

- (void)yindaoEnd{
    [self.conversationListTableView reloadData];
}

- (void)didReceiveRongMessageNotification:(NSNotification *)notification{
    
    [self.conversationListTableView reloadData];
    
}

- (void)notifyUpdateUnreadMessageCount {
    __weak typeof(self) __weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        int unreadMsgCount = [[RCIMClient sharedRCIMClient] getUnreadCount:@[
                                                                             @(ConversationType_PRIVATE),
                                                                             @(ConversationType_GROUP),
                                                                             @(ConversationType_CUSTOMERSERVICE)
                                                                             ]];
        [(WMTabBarController *)__weakSelf.tabBarController setTabBarNmuber:[NSString stringWithFormat:@"%d",unreadMsgCount]];
    });

}

@end
