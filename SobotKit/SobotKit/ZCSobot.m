//
//  ZCSobot.m
//  SobotKit
//
//  Created by zhangxy on 15/11/12.
//  Copyright © 2015年 zhichi. All rights reserved.
//

#import "ZCSobot.h"
#import "ZCLibClient.h"
#import "ZCLogUtils.h"

#import "ZCIMChat.h"

@implementation ZCSobot


+(void)startZCChatView:(ZCKitInfo *)info with:(UIViewController *)byController target:(id<ZCUIChatDelagete>)delegate pageBlock:(void (^)(ZCUIChatController *, ZCPageBlockType))pageClick messageLinkClick:(void (^)(NSString *))messagelinkBlock{
    if(byController==nil){
       
        return;
    }
    if(info == nil){
        return;
    }
    
    if([@"" isEqual:zcLibConvertToString([ZCLibClient getZCLibClient].libInitInfo.appKey)]){
        return;
    }
    
    ZCUIChatController *chat=[[ZCUIChatController alloc] initWithInitInfo:info];
    chat.hidesBottomBarWhenPushed=YES;
    chat.chatDelegate = delegate;
    
    [chat setPageBlock:^(ZCUIChatController *object, ZCPageBlockType type) {
        if(type == ZCPageBlockLoadFinish){
            object.backButton.hidden = YES;
        }
    } messageLinkClick:nil];
    
    
    [chat setPageBlock:pageClick messageLinkClick:messagelinkBlock];
    
    if(byController.navigationController==nil){
        chat.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;    // 设置动画效果
        [byController presentViewController:chat animated:YES completion:^{
            
        }];
    }else{
        [byController.navigationController pushViewController:chat animated:YES];
    }
}

+(void)startZCChatVC:(ZCKitInfo *) info
                with:(UIViewController *) byController
            loaction:(CGRect) location
              target:(id<ZCChatControllerDelegate>) delegate
           pageBlock:(void (^)(ZCChatController *object,ZCPageBlockType type))pageClick
    messageLinkClick:(void (^)(NSString *link)) messagelinkBlock{
    
    if(byController==nil){
        
        return;
    }
    if(info == nil){
        return;
    }
    
    if([@"" isEqual:zcLibConvertToString([ZCLibClient getZCLibClient].libInitInfo.appKey)]){
        return;
    }
    
    ZCChatController *chat=[[ZCChatController alloc] initWithInitInfo:info];
    chat.info = info;
    chat.chatdelegate = delegate;
    chat.hidesBottomBarWhenPushed = YES;
    
    [chat setPageBlock:^(ZCChatController *object, ZCPageBlockType type) {
        if(type == ZCPageBlockLoadFinish){
//            object..hidden = YES;
        }
    } messageLinkClick:nil];
    
    
    [chat setPageBlock:pageClick messageLinkClick:messagelinkBlock];
    
    if(byController.navigationController==nil){
        UINavigationController * navc = [[UINavigationController alloc]initWithRootViewController: chat];
        chat.isNoPush = YES;
        // 设置动画效果
        [byController presentViewController:navc animated:YES completion:^{
            
        }];
    }else{
        if(!byController.navigationController.navigationBarHidden){
//           ZCNavChatController *chat=[[ZCNavChatController alloc] init];
            byController.navigationController.hidesBottomBarWhenPushed = YES;
            [byController.navigationController setToolbarHidden:YES];
            [byController.navigationController pushViewController:chat animated:YES];
            chat.isBarHidden = NO;
        }else{
            chat.isBarHidden = YES;
            [byController.navigationController pushViewController:chat animated:YES];
        }
    }
}


+(void)startZCChatListView:(ZCKitInfo *)info with:(UIViewController *)byController{
    if(byController==nil){
        return;
    }
    if(info == nil){
        return;
    }
    ZCUIChatListController *chat=[[ZCUIChatListController alloc] init];
    chat.hidesBottomBarWhenPushed=YES;
    chat.kitInfo = info;
    
    if(byController.navigationController==nil){
        chat.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;    // 设置动画效果
        [byController presentViewController:chat animated:YES completion:^{
            
        }];
    }else{
        [byController.navigationController pushViewController:chat animated:YES];
    }
}


+(NSString *)getVersion {
    return zcGetSDKVersion();
}


+(NSString *)getChannel{
    return zcGetAppChannel();
}



+(void)setShowDebug:(BOOL)isShowDebug{
     [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",isShowDebug] forKey:ZCKey_ISDEBUG];
}

+(NSString *)getsystorm{
    return zcGetSystemVersion();
}

@end
