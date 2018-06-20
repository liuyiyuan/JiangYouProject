//
//  WMRCCommonUtil.m
//  Micropulse
//
//  Created by 茭白 on 2017/8/3.
//  Copyright © 2017年 iChoice. All rights reserved.
//

#import "WMRCCommonUtil.h"
#import "WMGroupRCDataManager.h"
#import "WMRCDataManager.h"

#import "WMRCBusinessCardMessage.h"
#import "WMRCGroupNewsMessage.h"
#import "WMRCBusinessCardMessage.h"
#import "WMPatientsInfoAPIManager.h"
#import "WMPatientsInfoModel.h"
#import "WMPatientsInfoParamModel.h"
#import "WMReplyMessage.h"


@implementation WMRCCommonUtil
+(void)jumpToChatVCWithTargetId:(NSString *)targetId
                  withTitleName:(NSString * )titleName
                 withDingdanhao:(NSString * )dingdanhao
                       withType:(BOOL )isNormalType
                 withSendRemind:(BOOL )isSendRemind
           isFromDelegateDoctor:(BOOL )delegateDoctor
       withNavigationController:(UINavigationController *)navigationController{
    [[WMRCDataManager shareManager] getUserInfoWithUserId:targetId completion:^(RCUserInfo *userInfo) {
        
//        WMConversationViewController *_conversationVC = [[WMConversationViewController alloc]init];
//        _conversationVC.conversationType = ConversationType_PRIVATE;
//        _conversationVC.targetId = targetId;
//        _conversationVC.isNormalType=isNormalType;
//        _conversationVC.isSendRemind=isSendRemind;
//        _conversationVC.titleName =userInfo.name;
//        _conversationVC.isFromDelegateDoctor = delegateDoctor;
//        _conversationVC.hidesBottomBarWhenPushed = YES;
//        [navigationController showViewController:_conversationVC sender:nil];
    }];
    
}

+(void)jumpToGroupVCWithGroupId:(NSString *)groupId
                       withType:(BOOL )isNormalType
       withNavigationController:(UINavigationController *)navigationController;{
    [[WMGroupRCDataManager shareManager] getGroupInfoWithGroupId:groupId completion:^(RCDGroupInfo *groupInfo) {
        // 如果 isNormalType 是No的情况下 必须要写明白来源
//        WMRCIMGroupViewController  *_groupViewController=[[WMRCIMGroupViewController alloc] init];
//        _groupViewController.targetId = groupId;
//        _groupViewController.conversationType = ConversationType_GROUP;
//        _groupViewController.title = groupInfo.groupName;
//        _groupViewController.isNormalType = isNormalType;
//        _groupViewController.hidesBottomBarWhenPushed = YES;
//        [navigationController showViewController:_groupViewController sender:nil];
        
    }];
    

}

+(void)chatListDetailShowWith:(RCConversation *)model detailStr:(void (^)(NSString*))detailStr{
   
/******************-基础类（融云封装好的聊天类）-******************/
    //1:文字信息
    if ([model.lastestMessage isKindOfClass:[RCTextMessage class]]) {
        detailStr([model.lastestMessage valueForKey:@"content"]);
        
    }
    //2:灰色提示语 用于提示消息
    //灰色提示语
    else if ([model.lastestMessage isKindOfClass:[RCInformationNotificationMessage class]]){
        
        RCInformationNotificationMessage *lastestMessage=(RCInformationNotificationMessage *)model.lastestMessage;
        if (!stringIsEmpty(lastestMessage.message)) {
            
             detailStr(lastestMessage.message);
            
        }
        else{
            detailStr(@"");

        }
        
    }
    
    
     //3:灰色提示语  用于撤销消息 （自己加的 20170731）
     else if ([model.lastestMessage isKindOfClass:[RCRecallNotificationMessage class]]){
     
     RCRecallNotificationMessage *lastestMessage=(RCRecallNotificationMessage *)model.lastestMessage;
         
     if (!stringIsEmpty(lastestMessage.operatorId)) {
     
         if ([lastestMessage.operatorId isEqualToString:[RCIMClient sharedRCIMClient].currentUserInfo.userId]) {
             NSString *str = [NSString  stringWithFormat:@"%@撤回了一条消息",@"你"];
             detailStr(str);
         }
         else{
            [[WMRCDataManager shareManager] getUserInfoWithUserId:lastestMessage.operatorId completion:^(RCUserInfo *userInfo) {
                NSString * str1 = [NSString  stringWithFormat:@"%@撤回了一条消息",userInfo.name];
                detailStr(str1);
             }];
             
         }
       }
     
     }
    
    //4:图片消息  用于展示图片消息
     else if ([model.lastestMessage isKindOfClass:[RCImageMessage class]]){
         
         detailStr (@"图片消息");
     }
    //5:语音信息
     else if ([model.lastestMessage isKindOfClass:[RCVoiceMessage class]]){
          detailStr (@"语音消息");
         
     }
    //6:定位信息
     else if ([model.lastestMessage isKindOfClass:[RCLocationMessage class]]){
         
          detailStr (@"位置消息");
     }



/******************-添加类（基于业务需求自定义类）-******************/
   
    //1：图文咨询 （自己加的 20160914）
    else if ([model.lastestMessage isKindOfClass:[RCRichContentMessage class]]){
        detailStr( @"图文咨询");
    }
    //2：名片消息 （自己加的 20160914）
    else if ([model.lastestMessage isKindOfClass:[WMRCBusinessCardMessage class]]){
        WMRCBusinessCardMessage *inquiryMessag=(WMRCBusinessCardMessage *)model.lastestMessage;
        NSLog(@"model.lastestMessage=%@",model.lastestMessage);
        detailStr( [NSString stringWithFormat:@"[%@的名片]",inquiryMessag.name]);
    }
    //3：医患群的 新闻 咨询消息
    else if ([model.lastestMessage isKindOfClass:[WMRCGroupNewsMessage class]]){
        WMRCGroupNewsMessage *lasConversationMsg=(WMRCGroupNewsMessage *)model.lastestMessage;
         detailStr( lasConversationMsg.title);
       
    }
    //群聊回复内容
    else if ([model.lastestMessage isKindOfClass:[WMReplyMessage class]]){
        WMReplyMessage *replyMsg = (WMReplyMessage *)model.lastestMessage;
        [[WMRCDataManager shareManager] getUserInfoWithUserId:model.senderUserId completion:^(RCUserInfo *userInfo) {
            NSString * str1 = [NSString  stringWithFormat:@"%@:%@",userInfo.name,replyMsg.replyMessage];
            detailStr(str1);
        }];
    }
    
}

+(void)groupChatListDetailShowWith:(RCConversation *)model detailStr:(void (^)(NSString*))detailStr{
    
    /**
     * 群组需要分为 自己  他人 和提醒类
     **/
    
    
    if (model.lastestMessageDirection==MessageDirection_RECEIVE) {
        
         //接收方
        /******************-基础类（融云封装好的聊天类）-******************/
        
        RCMessageContent *messageContent  =model.lastestMessage;
        
        
        //1:文字信息
        if ([model.lastestMessage isKindOfClass:[RCTextMessage class]]) {
            
                [[WMRCDataManager shareManager] getUserInfoWithUserId:model.senderUserId completion:^(RCUserInfo *userInfo) {
                    NSString * str1 = [NSString  stringWithFormat:@"%@:%@",userInfo.name,[model.lastestMessage valueForKey:@"content"]];
                    detailStr(str1);
            
                }];
                 }
        //2:灰色提示语 用于提示消息
        //灰色提示语
        else if ([model.lastestMessage isKindOfClass:[RCInformationNotificationMessage class]]){
            
            RCInformationNotificationMessage *lastestMessage=(RCInformationNotificationMessage *)model.lastestMessage;
            if (!stringIsEmpty(lastestMessage.message)) {
                
                detailStr(lastestMessage.message);
                
            }else{
                detailStr(@"");
            }
            
        }
        
        
        //3:灰色提示语  用于撤销消息 （自己加的 20170731）
        else if ([model.lastestMessage isKindOfClass:[RCRecallNotificationMessage class]]){
            
            RCRecallNotificationMessage *lastestMessage=(RCRecallNotificationMessage *)model.lastestMessage;
            
            if (!stringIsEmpty(lastestMessage.operatorId)) {
                
                if ([lastestMessage.operatorId isEqualToString:[RCIMClient sharedRCIMClient].currentUserInfo.userId]) {
                    NSString *str = [NSString  stringWithFormat:@"%@撤回了一条消息",@"你"];
                    detailStr(str);
                }
                else{
                    [[WMRCDataManager shareManager] getUserInfoWithUserId:lastestMessage.operatorId completion:^(RCUserInfo *userInfo) {
                        NSString * str1 = [NSString  stringWithFormat:@"%@撤回了一条消息",userInfo.name];
                        detailStr(str1);
                    }];
                    
                }
            }
            
        }
        
        //4:图片消息  用于展示图片消息
        else if ([model.lastestMessage isKindOfClass:[RCImageMessage class]]){
            

                [[WMRCDataManager shareManager] getUserInfoWithUserId:model.senderUserId completion:^(RCUserInfo *userInfo) {
                    NSString * str1 = [NSString  stringWithFormat:@"%@:%@",userInfo.name,@"图片消息"];
                    detailStr(str1);
                }];
                
           
            
        }
        //5:语音信息
        else if ([model.lastestMessage isKindOfClass:[RCVoiceMessage class]]){
            
            
                [[WMRCDataManager shareManager] getUserInfoWithUserId:model.senderUserId completion:^(RCUserInfo *userInfo) {
                    NSString * str1 = [NSString  stringWithFormat:@"%@:%@",userInfo.name,@"语音消息"];
                    detailStr(str1);
                }];
            
            
        }
        //6:定位信息
        else if ([model.lastestMessage isKindOfClass:[RCLocationMessage class]]){
            
                [[WMRCDataManager shareManager] getUserInfoWithUserId:model.senderUserId completion:^(RCUserInfo *userInfo) {
                    NSString * str1 = [NSString  stringWithFormat:@"%@:%@",userInfo.name,@"位置消息"];
                    detailStr(str1);
                }];
           
            
        }
        
        
        
        /******************-添加类（基于业务需求自定义类）-******************/
        
        //1：图文咨询 （自己加的 20160914）
        else if ([model.lastestMessage isKindOfClass:[RCRichContentMessage class]]){
            
            
                [[WMRCDataManager shareManager] getUserInfoWithUserId:model.targetId completion:^(RCUserInfo *userInfo) {
                    NSString * str1 = [NSString  stringWithFormat:@"%@:%@",userInfo.name,@"图文咨询"];
                    detailStr(str1);
                }];

           
        }
        //2：名片消息 （自己加的 20160914）
        else if ([model.lastestMessage isKindOfClass:[WMRCBusinessCardMessage class]]){
            
            WMRCBusinessCardMessage *inquiryMessag=(WMRCBusinessCardMessage *)model.lastestMessage;

                [[WMRCDataManager shareManager] getUserInfoWithUserId:model.targetId completion:^(RCUserInfo *userInfo) {
                    NSString * str1 = [NSString  stringWithFormat:@"%@:[%@的名片]",userInfo.name,inquiryMessag.name];
                    detailStr(str1);
                }];
           
        }
        //3：医患群的 新闻 咨询消息
        else if ([model.lastestMessage isKindOfClass:[WMRCGroupNewsMessage class]]){
            
            WMRCGroupNewsMessage *lasConversationMsg=(WMRCGroupNewsMessage *)model.lastestMessage;

                [[WMRCDataManager shareManager] getUserInfoWithUserId:model.senderUserId completion:^(RCUserInfo *userInfo) {
                    NSString * str1 = [NSString  stringWithFormat:@"%@:%@",userInfo.name,lasConversationMsg.title];
                    detailStr(str1);
                }];
          
            
        }
        //群消息回复
        else if ([model.lastestMessage isKindOfClass:[WMReplyMessage class]]){
            WMReplyMessage *replyMsg = (WMReplyMessage *)model.lastestMessage;
            [[WMRCDataManager shareManager] getUserInfoWithUserId:model.senderUserId completion:^(RCUserInfo *userInfo) {
                NSString * str1 = [NSString  stringWithFormat:@"%@:%@",userInfo.name,replyMsg.replyMessage];
                detailStr(str1);
            }];
        }

        
    }
    else{
       
        //发送方
        /******************-基础类（融云封装好的聊天类）-******************/
        //1:文字信息
        if ([model.lastestMessage isKindOfClass:[RCTextMessage class]]) {
            
            
            
            detailStr([model.lastestMessage valueForKey:@"content"]);
            
        }
        //2:灰色提示语 用于提示消息
        //灰色提示语
        else if ([model.lastestMessage isKindOfClass:[RCInformationNotificationMessage class]]){
            
            RCInformationNotificationMessage *lastestMessage=(RCInformationNotificationMessage *)model.lastestMessage;
            if (!stringIsEmpty(lastestMessage.message)) {
                
                detailStr(lastestMessage.message);
                
            }
            else{
                detailStr(@"");

            }
            
        }
        
        
        //3:灰色提示语  用于撤销消息 （自己加的 20170731）
        else if ([model.lastestMessage isKindOfClass:[RCRecallNotificationMessage class]]){
            
            RCRecallNotificationMessage *lastestMessage=(RCRecallNotificationMessage *)model.lastestMessage;
            
            if (!stringIsEmpty(lastestMessage.operatorId)) {
                
                if ([lastestMessage.operatorId isEqualToString:[RCIMClient sharedRCIMClient].currentUserInfo.userId]) {
                    NSString *str = [NSString  stringWithFormat:@"%@撤回了一条消息",@"你"];
                    detailStr(str);
                }
                else{
                    [[WMRCDataManager shareManager] getUserInfoWithUserId:lastestMessage.operatorId completion:^(RCUserInfo *userInfo) {
                        NSString * str1 = [NSString  stringWithFormat:@"%@撤回了一条消息",userInfo.name];
                        detailStr(str1);
                    }];
                    
                }
            }
            
        }
        
        //4:图片消息  用于展示图片消息
        else if ([model.lastestMessage isKindOfClass:[RCImageMessage class]]){
            
            detailStr (@"图片消息");
        }
        //5:语音信息
        else if ([model.lastestMessage isKindOfClass:[RCVoiceMessage class]]){
            detailStr (@"语音消息");
            
        }
        //6:定位信息
        else if ([model.lastestMessage isKindOfClass:[RCLocationMessage class]]){
            
            detailStr (@"位置消息");
        }
        
        
        
        /******************-添加类（基于业务需求自定义类）-******************/
        
        //1：图文咨询 （自己加的 20160914）
        else if ([model.lastestMessage isKindOfClass:[RCRichContentMessage class]]){
            detailStr( @"图文咨询");
        }
        //2：名片消息 （自己加的 20160914）
        else if ([model.lastestMessage isKindOfClass:[WMRCBusinessCardMessage class]]){
            WMRCBusinessCardMessage *inquiryMessag=(WMRCBusinessCardMessage *)model.lastestMessage;
            NSLog(@"model.lastestMessage=%@",model.lastestMessage);
            detailStr( [NSString stringWithFormat:@"[%@的名片]",inquiryMessag.name]);
        }
        //3：医患群的 新闻 咨询消息
        else if ([model.lastestMessage isKindOfClass:[WMRCGroupNewsMessage class]]){
            WMRCGroupNewsMessage *lasConversationMsg=(WMRCGroupNewsMessage *)model.lastestMessage;
            detailStr( lasConversationMsg.title);
            
        }
        //群消息回复
        else if ([model.lastestMessage isKindOfClass:[WMReplyMessage class]]){
            WMReplyMessage *replyMsg = (WMReplyMessage *)model.lastestMessage;
            [[WMRCDataManager shareManager] getUserInfoWithUserId:model.senderUserId completion:^(RCUserInfo *userInfo) {
                NSString * str1 = [NSString  stringWithFormat:@"%@:%@",userInfo.name,replyMsg.replyMessage];
                detailStr(str1);
            }];
        }

        
    }
    
    
    
    
    
    
}


+(void)chatListDetailShowWithKit:(RCConversationModel *)model detailStr:(void (^)(NSString*))detailStr{
    /******************-基础类（融云封装好的聊天类）-******************/
    //1:文字信息
    if ([model.lastestMessage isKindOfClass:[RCTextMessage class]]) {
        detailStr([model.lastestMessage valueForKey:@"content"]);
        
    }
    //2:灰色提示语 用于提示消息
    //灰色提示语
    else if ([model.lastestMessage isKindOfClass:[RCInformationNotificationMessage class]]){
        
        RCInformationNotificationMessage *lastestMessage=(RCInformationNotificationMessage *)model.lastestMessage;
        if (!stringIsEmpty(lastestMessage.message)) {
            
            detailStr(lastestMessage.message);
            
        }
        else{
            detailStr(@"");
        }
        
        
    }
    
    
    //3:灰色提示语  用于撤销消息 （自己加的 20170731）
    else if ([model.lastestMessage isKindOfClass:[RCRecallNotificationMessage class]]){
        
        RCRecallNotificationMessage *lastestMessage=(RCRecallNotificationMessage *)model.lastestMessage;
        
        if (!stringIsEmpty(lastestMessage.operatorId)) {
            
            if ([lastestMessage.operatorId isEqualToString:[RCIMClient sharedRCIMClient].currentUserInfo.userId]) {
                NSString *str = [NSString  stringWithFormat:@"%@撤回了一条消息",@"你"];
                detailStr(str);
            }
            else{
                [[WMRCDataManager shareManager] getUserInfoWithUserId:lastestMessage.operatorId completion:^(RCUserInfo *userInfo) {
                    NSString * str1 = [NSString  stringWithFormat:@"%@撤回了一条消息",userInfo.name];
                    detailStr(str1);
                }];
                
            }
        }
        
    }
    
    //4:图片消息  用于展示图片消息
    else if ([model.lastestMessage isKindOfClass:[RCImageMessage class]]){
        
        detailStr (@"图片消息");
    }
    //5:语音信息
    else if ([model.lastestMessage isKindOfClass:[RCVoiceMessage class]]){
        detailStr (@"语音消息");
        
    }
    //6:定位信息
    else if ([model.lastestMessage isKindOfClass:[RCLocationMessage class]]){
        
        detailStr (@"位置消息");
    }
    
    
    
    /******************-添加类（基于业务需求自定义类）-******************/
    
    //1：图文咨询 （自己加的 20160914）
    else if ([model.lastestMessage isKindOfClass:[RCRichContentMessage class]]){
        detailStr( @"图文咨询");
    }
    //2：名片消息 （自己加的 20160914）
    else if ([model.lastestMessage isKindOfClass:[WMRCBusinessCardMessage class]]){
        WMRCBusinessCardMessage *inquiryMessag=(WMRCBusinessCardMessage *)model.lastestMessage;
        NSLog(@"model.lastestMessage=%@",model.lastestMessage);
        detailStr( [NSString stringWithFormat:@"[%@的名片]",inquiryMessag.name]);
    }
    //3：医患群的 新闻 咨询消息
    else if ([model.lastestMessage isKindOfClass:[WMRCGroupNewsMessage class]]){
        WMRCGroupNewsMessage *lasConversationMsg=(WMRCGroupNewsMessage *)model.lastestMessage;
        detailStr( lasConversationMsg.title);
        
    }

}


+(void)groupChatListDetailShowWithKit:(RCConversationModel *)model detailStr:(void (^)(NSString*))detailStr{
    
    /**
     * 群组需要分为 自己  他人 和提醒类
     **/
    
    
    if (model.lastestMessageDirection==MessageDirection_RECEIVE) {
        
        //接收方
        /******************-基础类（融云封装好的聊天类）-******************/
        
        RCMessageContent *messageContent  =model.lastestMessage;
        
        NSLog(@"[model.lastestMessage class]11=%@",[model.lastestMessage class]);
        //1:文字信息
        if ([model.lastestMessage isKindOfClass:[RCTextMessage class]]) {
            //首先判断 是否有值 因为安卓没有传信息
            NSString *detail;
            
                [[WMRCDataManager shareManager] getUserInfoWithUserId:model.senderUserId completion:^(RCUserInfo *userInfo) {
                    NSString * str1 = [NSString  stringWithFormat:@"%@:%@",userInfo.name,[model.lastestMessage valueForKey:@"content"]];
                    detailStr(str1);
                }];
            
            
        }
        //2:灰色提示语 用于提示消息
        //灰色提示语
        else if ([model.lastestMessage isKindOfClass:[RCInformationNotificationMessage class]]){
            
            RCInformationNotificationMessage *lastestMessage=(RCInformationNotificationMessage *)model.lastestMessage;
            if (!stringIsEmpty(lastestMessage.message)) {
                
                detailStr(lastestMessage.message);
                
            }
            else{
                detailStr(@"");
            }
            
        }
        
        
        //3:灰色提示语  用于撤销消息 （自己加的 20170731）
        else if ([model.lastestMessage isKindOfClass:[RCRecallNotificationMessage class]]){
            
            RCRecallNotificationMessage *lastestMessage=(RCRecallNotificationMessage *)model.lastestMessage;
            
            if (!stringIsEmpty(lastestMessage.operatorId)) {
                
                if ([lastestMessage.operatorId isEqualToString:[RCIMClient sharedRCIMClient].currentUserInfo.userId]) {
                    NSString *str = [NSString  stringWithFormat:@"%@撤回了一条消息",@"你"];
                    detailStr(str);
                }
                else{
                    [[WMRCDataManager shareManager] getUserInfoWithUserId:lastestMessage.operatorId completion:^(RCUserInfo *userInfo) {
                        NSString * str1 = [NSString  stringWithFormat:@"%@撤回了一条消息",userInfo.name];
                        detailStr(str1);
                    }];
                    
                }
            }
            
        }
        
        //4:图片消息  用于展示图片消息
        else if ([model.lastestMessage isKindOfClass:[RCImageMessage class]]){
            
            
                [[WMRCDataManager shareManager] getUserInfoWithUserId:model.senderUserId completion:^(RCUserInfo *userInfo) {
                    NSString * str1 = [NSString  stringWithFormat:@"%@:%@",userInfo.name,@"图片消息"];
                    detailStr(str1);
                }];
            
            
        }
        //5:语音信息
        else if ([model.lastestMessage isKindOfClass:[RCVoiceMessage class]]){
            
            
                [[WMRCDataManager shareManager] getUserInfoWithUserId:model.senderUserId completion:^(RCUserInfo *userInfo) {
                    NSString * str1 = [NSString  stringWithFormat:@"%@:%@",userInfo.name,@"语音消息"];
                    detailStr(str1);
                }];
            
        }
        //6:定位信息
        else if ([model.lastestMessage isKindOfClass:[RCLocationMessage class]]){
            
                [[WMRCDataManager shareManager] getUserInfoWithUserId:model.senderUserId completion:^(RCUserInfo *userInfo) {
                    NSString * str1 = [NSString  stringWithFormat:@"%@:%@",userInfo.name,@"位置消息"];
                    detailStr(str1);
                }];
           
        }
        
        
        
        /******************-添加类（基于业务需求自定义类）-******************/
        
        //1：图文咨询 （自己加的 20160914）
        else if ([model.lastestMessage isKindOfClass:[RCRichContentMessage class]]){
            
            
                [[WMRCDataManager shareManager] getUserInfoWithUserId:model.targetId completion:^(RCUserInfo *userInfo) {
                    NSString * str1 = [NSString  stringWithFormat:@"%@:%@",userInfo.name,@"图文咨询"];
                    detailStr(str1);
                }];
                
           
        }
        //2：名片消息 （自己加的 20160914）
        else if ([model.lastestMessage isKindOfClass:[WMRCBusinessCardMessage class]]){
            
            WMRCBusinessCardMessage *inquiryMessag=(WMRCBusinessCardMessage *)model.lastestMessage;
            
                [[WMRCDataManager shareManager] getUserInfoWithUserId:model.targetId completion:^(RCUserInfo *userInfo) {
                    NSString * str1 = [NSString  stringWithFormat:@"%@:[%@的名片]",userInfo.name,inquiryMessag.name];
                    detailStr(str1);
                }];
           
            
            
        }
        //3：医患群的 新闻 咨询消息
        else if ([model.lastestMessage isKindOfClass:[WMRCGroupNewsMessage class]]){
            
            WMRCGroupNewsMessage *lasConversationMsg=(WMRCGroupNewsMessage *)model.lastestMessage;
            
                [[WMRCDataManager shareManager] getUserInfoWithUserId:model.senderUserId completion:^(RCUserInfo *userInfo) {
                    NSString * str1 = [NSString  stringWithFormat:@"%@:[%@的名片]",userInfo.name,lasConversationMsg.title];
                    detailStr(str1);
                }];
            
        }
        else if ([model.lastestMessage isKindOfClass:[WMReplyMessage class]]){
            WMReplyMessage *replyMsg = (WMReplyMessage *)model.lastestMessage;
            [[WMRCDataManager shareManager] getUserInfoWithUserId:model.senderUserId completion:^(RCUserInfo *userInfo) {
                NSString * str1 = [NSString  stringWithFormat:@"%@:%@",userInfo.name,replyMsg.replyMessage];
                detailStr(str1);
            }];
        }
        
        
    }
    else{
         NSLog(@"[model.lastestMessage class]222=%@",[model.lastestMessage class]);
        //发送方
        /******************-基础类（融云封装好的聊天类）-******************/
        //1:文字信息
        if ([model.lastestMessage isKindOfClass:[RCTextMessage class]]) {
            
            
            
            detailStr([model.lastestMessage valueForKey:@"content"]);
            
        }
        //2:灰色提示语 用于提示消息
        //灰色提示语
        else if ([model.lastestMessage isKindOfClass:[RCInformationNotificationMessage class]]){
            
            RCInformationNotificationMessage *lastestMessage=(RCInformationNotificationMessage *)model.lastestMessage;
            if (!stringIsEmpty(lastestMessage.message)) {
                
                detailStr(lastestMessage.message);
                
            }
            else{
                detailStr(@"");

            }
            
        }
        
        
        //3:灰色提示语  用于撤销消息 （自己加的 20170731）
        else if ([model.lastestMessage isKindOfClass:[RCRecallNotificationMessage class]]){
            
            RCRecallNotificationMessage *lastestMessage=(RCRecallNotificationMessage *)model.lastestMessage;
            
            if (!stringIsEmpty(lastestMessage.operatorId)) {
                
                if ([lastestMessage.operatorId isEqualToString:[RCIMClient sharedRCIMClient].currentUserInfo.userId]) {
                    NSString *str = [NSString  stringWithFormat:@"%@撤回了一条消息",@"你"];
                    detailStr(str);
                }
                else{
                    [[WMRCDataManager shareManager] getUserInfoWithUserId:lastestMessage.operatorId completion:^(RCUserInfo *userInfo) {
                        NSString * str1 = [NSString  stringWithFormat:@"%@撤回了一条消息",userInfo.name];
                        detailStr(str1);
                    }];
                    
                }
            }
            
        }
        
        //4:图片消息  用于展示图片消息
        else if ([model.lastestMessage isKindOfClass:[RCImageMessage class]]){
            
            detailStr (@"图片消息");
        }
        //5:语音信息
        else if ([model.lastestMessage isKindOfClass:[RCVoiceMessage class]]){
            detailStr (@"语音消息");
            
        }
        //6:定位信息
        else if ([model.lastestMessage isKindOfClass:[RCLocationMessage class]]){
            
            detailStr (@"位置消息");
        }
        
        
        
        /******************-添加类（基于业务需求自定义类）-******************/
        
        //1：图文咨询 （自己加的 20160914）
        else if ([model.lastestMessage isKindOfClass:[RCRichContentMessage class]]){
            detailStr( @"图文咨询");
        }
        //2：名片消息 （自己加的 20160914）
        else if ([model.lastestMessage isKindOfClass:[WMRCBusinessCardMessage class]]){
            WMRCBusinessCardMessage *inquiryMessag=(WMRCBusinessCardMessage *)model.lastestMessage;
            NSLog(@"model.lastestMessage=%@",model.lastestMessage);
            detailStr( [NSString stringWithFormat:@"[%@的名片]",inquiryMessag.name]);
        }
        //3：医患群的 新闻 咨询消息
        else if ([model.lastestMessage isKindOfClass:[WMRCGroupNewsMessage class]]){
            WMRCGroupNewsMessage *lasConversationMsg=(WMRCGroupNewsMessage *)model.lastestMessage;
            detailStr( lasConversationMsg.title);
            
        }
        //群消息回复
        else if ([model.lastestMessage isKindOfClass:[WMReplyMessage class]]){
            WMReplyMessage *replyMsg = (WMReplyMessage *)model.lastestMessage;
            [[WMRCDataManager shareManager] getUserInfoWithUserId:model.senderUserId completion:^(RCUserInfo *userInfo) {
                NSString * str1 = [NSString  stringWithFormat:@"%@:%@",userInfo.name,replyMsg.replyMessage];
                detailStr(str1);
            }];
        }
    }
}
+ (void)getPatientsInfoWithUserId:(NSString *)userId loadSuccessed:(void (^)(void))loadSuccessed{
    WMPatientsInfoAPIManager *patientsInfoAPIManager=[[WMPatientsInfoAPIManager alloc]init];
    WMPatientsInfoParamModel *patientsInfoParamModel=[[WMPatientsInfoParamModel alloc]init];
    patientsInfoParamModel.weimaihao=userId;
    [patientsInfoAPIManager loadDataWithParams:patientsInfoParamModel.toDictionary withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSLog(@"群消息的data = %@", responseObject);
        WMPatientsInfoModel *patientsInfoModel=(WMPatientsInfoModel *)responseObject;//[[WMPatientsInfoModel alloc] initWithDictionary:responseObject error:nil];
        RCUserInfo *info=[[RCUserInfo alloc]init];
        info.userId=userId;
        info.name=patientsInfoModel.xingming;
        info.sex=patientsInfoModel.xingbie;
        info.type=patientsInfoModel.type;
        info.vip=patientsInfoModel.vip;
        info.tagNames = patientsInfoModel.tagNames;
        if (stringIsEmpty(patientsInfoModel.url)) {
            //为空 这个时候的根据性别判断
            if ([patientsInfoModel.xingbie intValue]==1) {
                //男
                info.portraitUri=WM_LISTDEFAULT_URL;
            }
            else if ([patientsInfoModel.xingbie intValue]==2){
                //女
                info.portraitUri=WM_LISTDEFAULT_URL;
                
            }
            else {
                //未知
                info.portraitUri=WM_LISTDEFAULT_URL;
            }
        }
        else{
            info.portraitUri=patientsInfoModel.url;
        }
        [[RCIM sharedRCIM] refreshUserInfoCache:info withUserId:userId];
        [WMRCUserInfoEntitys savePatientEntity:info];
        loadSuccessed();
        
        
    } withFailure:^(ResponseResult *errorResult) {
        
        
    }];
}

@end
