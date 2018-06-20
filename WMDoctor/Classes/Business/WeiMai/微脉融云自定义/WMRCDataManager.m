//
//  WMRCDataManager.m
//  WMDoctor
//
//  Created by 茭白 on 2016/12/29.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import "WMRCDataManager.h"
#import "WMPatientsInfoAPIManager.h"
#import "WMPatientsInfoParamModel.h"
#import "WMPatientsInfoModel.h"
#import "AppConfig.h"
#import "AppDelegate+RongCloud.h"

@implementation WMRCDataManager

+ (WMRCDataManager *)shareManager{
    static WMRCDataManager* manager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        manager = [[[self class] alloc] init];
    });
    return manager;
}
- (instancetype)init{
    if (self = [super init]) {
        [RCIM sharedRCIM].userInfoDataSource = self;
    }
    return self;
}
#pragma mark--RCIMUserInfoDataSource
- (void)getUserInfoWithUserId:(NSString *)userId
                   completion:(void (^)(RCUserInfo *userInfo))completion{
    NSLog(@"userId = %@", userId);
    int unreadMsgCount = [[RCIMClient sharedRCIMClient] getUnreadCount:@[
                                                                         @(ConversationType_PRIVATE),
                                                                         @(ConversationType_CUSTOMERSERVICE)
                                                                         ]];
    [UIApplication sharedApplication].applicationIconBadgeNumber = unreadMsgCount;
    
    if (userId == nil || [userId length] == 0 ){ //非空判断
        completion(nil);
        return ;
    }
    if ([userId isEqualToString:[RCIM sharedRCIM].currentUserInfo.userId]) { //自己判断
        
        RCUserInfo *aUser = [RCIM sharedRCIM].currentUserInfo;
        completion(aUser);
    }
    else if ([userId isEqualToString:@"system000001"] ||[userId isEqualToString:@"system000002"]){
        
        RCUserInfo *messageInfo=[[RCUserInfo alloc]initWithUserId:userId name:@"微脉消息" portrait:nil];
        NSLog(@"messageInfo.name==%@",messageInfo.name);
         completion(messageInfo);
        
        
    }
    else if ([userId isEqualToString:[NSString stringWithFormat:@"%@",RONGCLOUD_SERVICE_ID]]){
        RCUserInfo *userInfo=[[RCUserInfo alloc]init];
        userInfo.portraitUri=WM_SERVICEHRADER_URL;
        userInfo.name=@"小脉助手";
        userInfo.userId=[NSString stringWithFormat:@"%@",RONGCLOUD_SERVICE_ID];
        completion(userInfo);
        
    }else if([userId isEqualToString:@"system000003"]){     //胎心监护
        RCUserInfo *userInfo=[[RCUserInfo alloc]init];
        userInfo.portraitUri = WM_TAIXINHRADER_URL;
        userInfo.name = @"胎心监护";
        userInfo.userId = @"system000003";
        completion(userInfo);
    } else if([userId isEqualToString:@"system000004"]){    //一问医答
        RCUserInfo *userInfo = [[RCUserInfo alloc] init];
        userInfo.portraitUri = WM_YIWENYIDAHRADER_URL;
        userInfo.name = @"一问医答";
        userInfo.userId = @"system000004";
        completion(userInfo);
    }

    else { //非自己 并返回数据
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self getChatListMessageWithUserId:userId completion:^(RCUserInfo *aUser) {
                NSLog(@"aUser : %@", aUser);
                completion(aUser);
            }];
            
        });
        
    }

}
#pragma mark--获取聊天对象信息
- (void)getChatListMessageWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo*))canshu{
    
    /**
     *  1:先检查本地本地数据库有没有 有就拿
     *  2:如果没有， 请求我们数据库里面请求获得
     *  3:如果侧滑删除的时候，记得删除本地缓存
     */
    //其实主要是获取三个数据   RCUserInfo  userId这个Id是对方的Id.
    RCUserInfo *userInfo=[WMRCUserInfoEntitys getPatientEntity:userId];
    NSLog(@"userInfo.portraitUri==%@",userInfo.portraitUri);
    if (stringIsEmpty(userInfo.userId)) {
        
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
            
            [WMRCUserInfoEntitys savePatientEntity:info];
            [[RCIM sharedRCIM] refreshUserInfoCache:info withUserId:userId];

            canshu(info);
            
        } withFailure:^(ResponseResult *errorResult) {
            NSLog(@"获取数据失败error = %@", errorResult);
            
        }];

    }
    else{
        
        [[RCIM sharedRCIM] refreshUserInfoCache:userInfo withUserId:userId];
        canshu(userInfo);
    }
 
    
    
}

/**
 * 获取小脉助手信息
 */
-(void)getXiaoMaiHelpInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion{
    
    
    RCUserInfo *userInfo=[[RCUserInfo alloc]init];
    userInfo.portraitUri=WM_SERVICEHRADER_URL;
    userInfo.name=@"小脉助手";
    completion(userInfo);
}

-(void)deletePatientInfoFromLocalWithUserId:(NSString *)userId {
    [WMRCUserInfoEntitys deletePatientEntity:userId];
}


@end
