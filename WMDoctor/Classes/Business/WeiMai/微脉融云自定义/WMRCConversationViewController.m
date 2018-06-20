//
//  WMRCConversationViewController.m
//  WMDoctor
//
//  Created by 茭白 on 2017/1/6.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMRCConversationViewController.h"
#import "WMChatFooterView.h"
#import "WMHealthRecordView.h"
#import "WMFasterReplyViewController.h"
#import "WMPatientsCloseAPIManager.h"
#import "WMPatientsCloseParamModel.h"
#import "WMRCInquiryMessageCell.h"
#import "WMRCInquiryMessage.h"
#import "WMPatientsStateAPIManager.h"
#import "WMPatientStateParamModel.h"
#import "WMPatientsUpHuifuParamModel.h"
#import "WMRCAdvisoryEndView.h"
#import "WMShowImageViewController.h"
#import <UMMobClick/MobClick.h>
#import "WMBackButtonItem.h"
#import "WMRCDataManager.h"
#import "WMTabBarController.h"
#import "WMFollowUpAPIManager.h"
#import "WMRCBusinessCardMessage.h"
#import "WMRCBusinessCardMessageCell.h"
#import "WMDoctorCardModel.h"
#import "WMRecommenDepartViewController.h"
#import <IQKeyboardManager.h>
#import "WMQuickReplyListViewController.h"
#import "WMRCGroupNewsMessage.h"
#import "WMPatientDataViewController.h"
@interface WMRCConversationViewController ()<WMRCAdvisoryEndViewDelegate>
@property (nonatomic ,strong) WMHealthRecordView *textView;
@property (nonatomic ,strong )WMRCAdvisoryEndView *showdview;
@property (nonatomic,strong)UIView * baoyueTipView;


@end

@implementation WMRCConversationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor colorWithHexString:@"f4f4f4"];
    //扩充或者改变功能板
    //不显示对方姓名
    self.displayUserNameInCell=NO;
    //滚动到列表最下方
    //[self scrollToBottomAnimated:YES];
    [self operatePluginBoardView];
    [self changeFrame];
    [self setupData];
    //视图页面注册 消息类型和消息cell 图文问诊
    [self registerClass:[WMRCInquiryMessageCell class] forMessageClass:[WMRCInquiryMessage class]];
    [self registerClass:[WMRCBusinessCardMessageCell class] forMessageClass:[WMRCBusinessCardMessage class]];
    [self notifyUpdateUnreadMessageCount];
    //[self sendNewMessage];
    [self whenNoMessage];
    
    //页面将要展现的时候获取一下状态
    [self getPatientsHealthState];
    
    UIButton *rightBarBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 70, 30)];
    [rightBarBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightBarBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightBarBtn setTitle:@"患者信息" forState:UIControlStateNormal];
    [rightBarBtn addTarget:self action:@selector(rightBarBtnClickAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarBtnItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarBtn];
    self.navigationItem.rightBarButtonItem = rightBarBtnItem;
}

//进入患者信息页面
- (void)rightBarBtnClickAction{
    [self gotoPatientDataVCWithUserId:self.targetId];
}

- (void)backButtonAction:(UIBarButtonItem*)item{
     [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

-(void)changHeihtWhenAgreeFinish:(NSNotification*)notification{
    //必须放进主线程
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self  getPatientsHealthState];
    });
}
-(void)setupData{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changHeihtWhenAgreeFinish:)
                                                 name:kRongCloudFinishConversationNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendTextValue:) name:@"QuickReplyOftalkNotification" object:@"quickStr"];
}

- (void)sendTextValue:(NSNotification*)sender{
    RCTextMessage *testMessage=[RCTextMessage messageWithContent:[sender.userInfo objectForKey:@"theQuickStr"]];
    
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

#pragma mark--获取患者健康状态
- (void)getPatientsHealthState{
    
    WMPatientsStateAPIManager *patientsStateAPIManager=[[WMPatientsStateAPIManager alloc]init];
    
    WMPatientStateParamModel *patientStateParamModel =[[WMPatientStateParamModel alloc]init];
    patientStateParamModel.weimaihao=self.targetId;
    //患者微脉号和医生微脉号
    
    [patientsStateAPIManager loadDataWithParams:patientStateParamModel.toDictionary withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        
        WMPatientStateModel *model=(WMPatientStateModel*)responseObject;
        self.patientStateMode=model;
        [self changeChatSessionInputBarControl];
        [self UpdateDoctorInformationWith:model];
        [self buildAcceptSuccessView:model.deadlineText];
        NSLog(@"=responseObject=%@",responseObject);
        
    } withFailure:^(ResponseResult *errorResult) {
        NSLog(@"=errorResult=%@",errorResult);
    }];
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

#pragma mark--跟新医生信息
-(void)UpdateDoctorInformationWith:(WMPatientStateModel*)model{
    
    RCUserInfo *userInfo=[[RCUserInfo alloc]init];
    userInfo.name=model.xingming;
    userInfo.portraitUri=model.url;
    userInfo.sex=model.xingbie;
    userInfo.userId=self.targetId;
    userInfo.vip=model.vip;
    userInfo.type = @"0";
    userInfo.tagNames = model.tagNames;
    [WMRCUserInfoEntitys savePatientEntity:userInfo];
    [[WMRCDataManager shareManager] getUserInfoWithUserId:userInfo.userId completion:^(RCUserInfo *userInfo) {
        
    }];
}

#pragma mark-
-(void)changeChatSessionInputBarControl {
    if ([self.patientStateMode.status intValue]==0) {
       //可以聊天
        [self.showdview removeFromSuperview];
        self.showdview=nil;
        [_showdview hiddenView];
        _showdview.hidden = YES;
//        [self.chatSessionInputBarControl updateStatus:KBottomBarDefaultStatus animated:YES];
        
    }
    else{
        // 0-随访，1-主动联系
        if ([self.patientStateMode.serviceType intValue]==0) {
            self.chatSessionInputBarControl.height=50;
            if (!self.showdview) {
                self.showdview=[[WMRCAdvisoryEndView alloc]initWithFrame:CGRectMake(0, 0, kScreen_width, 50) withType:WMRCAdvisoryEndViewTypeFollowUp];
            }
            self.showdview.delegate=self;
            [self.chatSessionInputBarControl addSubview:self.showdview];
            [self.chatSessionInputBarControl updateStatus:KBottomBarDefaultStatus animated:YES];
        }
        else  if ([self.patientStateMode.serviceType intValue]==1){
            if (!self.showdview) {
                self.showdview=[[WMRCAdvisoryEndView alloc]initWithFrame:CGRectMake(0, 0, kScreen_width, 50) withType:WMRCAdvisoryEndViewTypeSayHello];
            }
            self.showdview.delegate=self;
            [self.chatSessionInputBarControl addSubview:self.showdview];
            [self.chatSessionInputBarControl updateStatus:KBottomBarDefaultStatus animated:YES];
        }
    }
}

#pragma mark--WMRCAdvisoryEndViewDelegate
-(void)followUpWithButton:(UIButton *)button{
    
    NSLog(@"随访开始了");
    [PopUpUtil confirmWithTitle:nil message:@"是否开通免费随访，开通后可点击右下角“关闭咨询”结束对话" toViewController:self buttonTitles:@[@"取消",@"确认"] completionBlock:^(NSUInteger buttonIndex) {
        if (buttonIndex==1) {
            
        button.enabled=NO;
        WMFollowUpAPIManager *followUpAPIManager=[[WMFollowUpAPIManager alloc]init];
        //yonghubh 指医生 自己
        //huanzhewmh 指患者
        NSMutableDictionary *paramDic=[[NSMutableDictionary alloc] initWithObjectsAndKeys:[RCIM sharedRCIM].currentUserInfo.userId,@"yonghubh",self.targetId,@"huanzhewmh",self.patientStateMode.serviceType,@"serviceType", nil];
        //"yonghubh":910100000000632247,
        //"huanzhewmh":100000005879
        
        [followUpAPIManager loadDataWithParams:paramDic withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
            button.enabled=YES;
            //必须放进主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self  getPatientsHealthState];
            });
            
        } withFailure:^(ResponseResult *errorResult) {
            NSLog(@"errorResult==%@",errorResult);
            button.enabled=YES;
        }];
        }
    }];
}

-(void)sayHelloWithButton:(UIButton *)button{
    NSLog(@"我回复你的打招呼了，哈哈哈");
    
    WMFollowUpAPIManager *followUpAPIManager=[[WMFollowUpAPIManager alloc]init];
    //yonghubh 指医生 自己
    //huanzhewmh 指患者
    NSMutableDictionary *paramDic=[[NSMutableDictionary alloc] initWithObjectsAndKeys:[RCIM sharedRCIM].currentUserInfo.userId,@"yonghubh",self.targetId,@"huanzhewmh",self.patientStateMode.serviceType,@"serviceType", nil];
    
    [followUpAPIManager loadDataWithParams:paramDic withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        button.enabled=YES;
        //必须放进主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            [self  getPatientsHealthState];
        });
    } withFailure:^(ResponseResult *errorResult) {
        NSLog(@"errorResult==%@",errorResult);
        button.enabled=YES;
    }];
}

//点击cell回调
- (void)didTapMessageCell:(RCMessageModel *)model{
    
    NSLog(@"点击Cell中的消息内容的回调");
    //如果不改变，切记super
    [super didTapMessageCell:model];
    if ([model.objectName isEqualToString:@"RCD:WMInquiryMsg"]) {
        WMRCInquiryMessage *inquiryMessage=(WMRCInquiryMessage *)model.content;
        NSLog(@"inquiryMessage==%@",inquiryMessage);
        int pictureIndex= [[[NSUserDefaults standardUserDefaults]objectForKey:WMRCInquiryMessageCellIndex] intValue];
        NSLog(@"pictureIndex=%d",pictureIndex);
        WMShowImageViewController *VC=[[WMShowImageViewController alloc]init];
        VC.array=inquiryMessage.inquiryPictureArr;
        VC.currentIndex=pictureIndex;
        [self.navigationController pushViewController:VC animated:YES];
    }
}

- (RCMessageContent *)willSendMessage:(RCMessageContent *)messageContent{
    return messageContent;
}


#pragma mark--即将在聊天界面插入消息的回调
- (RCMessage *)willAppendAndDisplayMessage:(RCMessage *)message{
   return message;
}

#pragma mark-- 聊天界面下方的输入工具栏的改动
-(void)operatePluginBoardView{
    //删除扩充框里面的地图
    [self.chatSessionInputBarControl.pluginBoardView removeItemWithTag:PLUGIN_BOARD_ITEM_LOCATION_TAG];
    UIImage *finishImage=[UIImage imageNamed:@"wm_im_finish"];
    UIImage *retalkImage=[UIImage imageNamed:@"wm_im_retalk"];
    UIImage *recommendDocImage=[UIImage imageNamed:@"发送名片"];
    
    //或添加到最后的：
    [self.chatSessionInputBarControl.pluginBoardView insertItemWithImage:finishImage
                                                                   title:@"结束对话"
                                                                     tag:201];
    //或添加到最后的：
    [self.chatSessionInputBarControl.pluginBoardView insertItemWithImage:retalkImage
                                                                   title:@"快捷回复"
                                                                     tag:202];
    //或添加到最后的：
    [self.chatSessionInputBarControl.pluginBoardView insertItemWithImage:recommendDocImage
                                                                   title:@"名片"
                                                                     tag:203];
}
#pragma mark-- 聊天界面下方的输入工具栏的代理事件
- (void)pluginBoardView:(RCPluginBoardView *)pluginBoardView
     clickedItemWithTag:(NSInteger)tag {
    switch (tag) {
        case 201: {
            if ([self.patientStateMode.close intValue]==0) {
                [PopUpUtil confirmWithTitle:nil message:@"此患者还在服务有效期内，暂时无法结束咨询" toViewController:nil buttonTitles:@[@"确定"] completionBlock:^(NSUInteger buttonIndex) {
                    
                }];
            }
            else{
                [PopUpUtil confirmWithTitle:nil message:@"患者的疑问都已经解决了吗？" toViewController:nil buttonTitles:@[@"未解决",@"已解决"] completionBlock:^(NSUInteger buttonIndex) {
                    if (buttonIndex==1) {
                        [self closeChat];
                    }
                }];
            }
        } break;
        case 202: {
            
            //新版快捷回复
            UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"WeiMai" bundle:nil];
            WMQuickReplyListViewController * quickVC = [storyboard instantiateViewControllerWithIdentifier:@"WMQuickReplyListViewController"];
            quickVC.typeStr = @"talk";
            [self.navigationController pushViewController:quickVC animated:YES];
            
        } break;
        case 203: {
            WMRecommenDepartViewController *fasterReplyVC=[[WMRecommenDepartViewController alloc]init];
            fasterReplyVC.targetIdStr=self.targetId;
            fasterReplyVC.dingdanhao=[NSString stringWithFormat:@"%@",self.patientStateMode.dingdanhao];
            [self.navigationController pushViewController:fasterReplyVC animated:YES];
            
        } break;
        default:
            [super pluginBoardView:pluginBoardView clickedItemWithTag:tag];
            break;
    }
}

#pragma mark-- 关闭会话的操作
-(void)closeChat{
    
    WMPatientsCloseAPIManager *patientsCloseAPIManager=[[WMPatientsCloseAPIManager alloc]init];
    WMPatientsCloseParamModel *model=[[WMPatientsCloseParamModel alloc]init];
    model.dingdanhao=[NSString stringWithFormat:@"%@",self.patientStateMode.dingdanhao];
    [patientsCloseAPIManager loadDataWithParams:model.toDictionary withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSLog(@"关闭成功了");
        //这里还需要做 1：发一个消息给 用户 2：关闭会话框
        //命令消息不是我们发送 是服务端发送。
        [self getPatientsHealthState];
        
    } withFailure:^(ResponseResult *errorResult) {
        NSLog(@"失败了");
    }];
}
- (void)changeFrame{
    self.conversationMessageCollectionView.frame=CGRectMake(0, 64, kScreen_width, kScreen_height-64);
}

- (void)healthRecordAction:(UIButton *)button{
    [self.view endEditing:YES];
    self.textView=[[WMHealthRecordView alloc]initWithFrame:CGRectMake(0, 100, kScreen_width, kScreen_height-100) withDingdanhao:[NSString stringWithFormat:@"%@",self.patientStateMode.dingdanhao]];
    [self.view addSubview:self.textView];
}

#pragma mark--包月提示(可以封装一下 拿出这个视图)
-(void)buildAcceptSuccessView:(NSString  *)baoyueDate{
    
    //先移除 试图
    if (self.baoyueTipView) {
        [self.baoyueTipView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    if (!stringIsEmpty(baoyueDate)) {
        if (!self.baoyueTipView) {
            self.baoyueTipView=[[UIView alloc]init];
        }
        self.baoyueTipView.frame=CGRectMake(0, kSTATUSNAVHEIGHT, kScreen_width, 40);
        self.baoyueTipView.backgroundColor= [UIColor colorWithHexString:@"85b9ec"];
        self.baoyueTipView.alpha=0.95;
        [self.view addSubview:self.baoyueTipView];
        
        UILabel *tipLabel=[[UILabel alloc] init];
        tipLabel.frame=CGRectMake(0, 10, self.baoyueTipView.frame.size.width, 20);
        tipLabel.font=[UIFont systemFontOfSize:14.0];
        tipLabel.textColor=[UIColor colorWithHexString:@"ffffff"];
        tipLabel.text=baoyueDate;
        tipLabel.textAlignment=NSTextAlignmentCenter;
        [self.baoyueTipView addSubview:tipLabel];
    }
    else{
        if (self.baoyueTipView) {
        [self.baoyueTipView removeFromSuperview];
        }
    }
    
}

-(void)chatAction:(UIButton *)button{
    [self.view endEditing:YES];
    [self.textView removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//点击头像
- (void)didTapCellPortrait:(NSString *)userId{
    [super didTapCellPortrait:userId];
    [self gotoPatientDataVCWithUserId:userId];
}

- (void)gotoPatientDataVCWithUserId:(NSString *)userId{
    [[WMRCDataManager shareManager] getUserInfoWithUserId:userId completion:^(RCUserInfo *userInfo) {
        NSLog(@"点击用户信息 = %@", userInfo.type);
        if ([userInfo.type isEqualToString:@"0"]) {
            NSLog(@"这个人是患者啊老铁");
            //跳转到患者资料页
            WMPatientDataViewController *patientDataViewController = [[WMPatientDataViewController alloc] init];
            patientDataViewController.userId = userId;
            [self.navigationController pushViewController:patientDataViewController animated:YES];
        }
    }];
}

#pragma mark -- 当聊天页面展示没有数据时  主动拉取数据  展示给用户。
-(void)whenNoMessage{
    if(!(self.conversationDataRepository.count > 0)){
        [[RCIMClient sharedRCIMClient] getRemoteHistoryMessages:self.conversationType targetId:self.targetId recordTime:0.00001 count:10 success:^(NSArray *messages) {
            //通过for 循环来一个个插入吗？
            for (RCMessage *message in messages) {
                [self appendAndDisplayMessage:message];
            }
            [self.conversationMessageCollectionView reloadData];
            
        } error:^(RCErrorCode status) {
            
        }];
        
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"QuickReplyOftalkNotification" object:@"quickStr"];
}

@end
