//
//  WMGroupRCDataManager.m
//  Micropulse
//
//  Created by 茭白 on 2016/11/10.
//  Copyright © 2016年 iChoice. All rights reserved.
//

#import "WMGroupRCDataManager.h"
#import "WMRCIMGroupDataEntity+CoreDataClass.h"
//#import "WMGroupMemberDataEntity+CoreDataClass.h"
#import "RCDGroupInfo.h"
#import "WMGroupMessageAPIManager.h"
@implementation WMGroupRCDataManager
- (instancetype)init{
    if (self = [super init]) {
        [RCIM sharedRCIM].groupInfoDataSource = self;
        [RCIM sharedRCIM].groupMemberDataSource = self;
        [RCIM sharedRCIM].groupUserInfoDataSource = self;
        
    }
    return self;
}

+ (WMGroupRCDataManager *)shareManager{
    static WMGroupRCDataManager* manager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        manager = [[[self class] alloc] init];
    });
    return manager;
}
#pragma mark--RCIMGroupInfoDataSource
- (void)getGroupInfoWithGroupId:(NSString *)groupId
                     completion:(void (^)(RCDGroupInfo *groupInfo))completion{
    
    NSLog(@"getUserInfoWithUserId ----- %@", groupId);
    NSLog(@"[RCIM sharedRCIM].currentUserInfo=%@",[RCIM sharedRCIM].currentUserInfo);
    if (groupId == nil || [groupId length] == 0 )
    {
        
        
        completion(nil);
        return ;
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self getWMGroupInfoWithGroupId:groupId completion:^(RCDGroupInfo * group) {
                completion(group);
            }];
            /*
            [self getAllMembersOfGroup:groupId result:^(NSArray<NSString *> *userIdList) {
                NSLog(@"userIdList==%@",userIdList);
                for (int i=0; i<userIdList.count; i++) {
                    [self getUserInfoWithUserId:[userIdList objectAtIndex:i] inGroup:groupId completion:^(RCUserInfo *userInfo) {
                        //[[RCIM sharedRCIM] refreshGroupUserInfoCache:userInfo withUserId:userInfo.userId withGroupId:groupId];
                    }];
 
                }
                
            }];*/
            
        });
       
        
    }
    

    
    
    
}
#pragma mark--RCIMGroupMemberDataSource
/*
- (void)getAllMembersOfGroup:(NSString *)groupId
                      result:(void (^)(NSArray<NSString *> *userIdList))resultBlock{
    NSArray *array=[NSArray arrayWithObjects:@"910300000003352651",@"15038115676", nil];
    resultBlock(array);
    NSLog(@"resultBlock==%@",resultBlock);
}*/
#pragma mark--groupUserInfoDataSource
/*
-(void)getUserInfoWithUserId:(NSString *)userId inGroup:(NSString *)groupId completion:(void (^)(RCUserInfo *))completion{
    NSLog(@"completion==%@",completion);
    if ([userId isEqualToString:[RCIM sharedRCIM].currentUserInfo.userId]) {
        RCUserInfo *aUser =[RCIM sharedRCIM].currentUserInfo;
        completion(aUser);
    }
    else{
       
        [self getGroupMemberInfoWithGroupId:groupId withUserId:userId completion:^(RCUserInfo * userInfo) {
            completion(userInfo);
        }];
        
    }
   
    
}*/

-(void)getWMGroupInfoWithGroupId:(NSString *)groupId completion:(void (^)(RCDGroupInfo *))completion{
    
    /**
     *  1:先检查本地本地数据库有没有 有就拿
     *  2:如果没有， 请求我们数据库里面请求获得
     *  3:如果侧滑删除的时候，记得删除本地缓存
     */
    //其实主要是获取三个数据   RCUserInfo  userId这个Id是对方的Id.
    
   
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"groupId = %@ and userId=%@",groupId,[RCIM sharedRCIM].currentUserInfo.userId];
    RCDGroupInfo *group=[WMRCIMGroupDataEntity selectRCGroupInfo:predicate];
    NSLog(@"groupName = %@\ngroupId = %@", group.groupName, group.groupId);
    if (stringIsEmpty(group.groupId)) {
        
        WMGroupMessageAPIManager *groupMessageAPIManager = [[WMGroupMessageAPIManager alloc] init];
        NSDictionary *param = @{
                                @"groupId" : groupId
                                };
        [groupMessageAPIManager loadDataWithParams:param withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"群信息data = %@", responseObject);
            WMIMGroupModel *group = [[WMIMGroupModel alloc] initWithDictionary:responseObject error:nil];
            RCDGroupInfo *groupInfo = [[RCDGroupInfo alloc]init];
            groupInfo.groupName = group.groupName;
            groupInfo.groupId = groupId;
            groupInfo.portraitUri = group.groupPicture;
            [WMRCIMGroupDataEntity saveRCGroupInfo:groupInfo];
            completion(groupInfo);
        } withFailure:^(ResponseResult *errorResult) {
            NSLog(@"群信息error = %@", errorResult);
        }];
    }
    else{
        
        RCDGroupInfo *groupInfo=[[RCDGroupInfo alloc] init];
        groupInfo=group;
        [[RCIM sharedRCIM] refreshGroupInfoCache:groupInfo withGroupId:groupId];
        completion(group);
    }
   
    
}
-(void)getGroupMemberInfoWithGroupId:(NSString *)groupId withUserId:(NSString*)userId completion:(void (^)(RCUserInfo*))canshu{
    
    
    /**
     *  1:先检查本地本地数据库有没有 有就拿
     *  2:如果没有， 请求我们数据库里面请求获得
     *  3:如果侧滑删除的时候，记得删除本地缓存
     */
    /*
    //其实主要是获取三个数据   RCUserInfo  userId这个Id是对方的Id.
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"groupId = %@ and membersId=%@ and userId=%@",groupId,userId,[RCIM sharedRCIM].currentUserInfo.userId];
    RCUserInfo *groupMember= [WMGroupMemberDataEntity selectGroupMemberInfo:predicate];
    
    if (stringIsEmpty(groupMember.userId)) {
        //网络请求  暂时写死
        RCUserInfo *aUser =[[RCUserInfo alloc]init];
        aUser.name=@"玛卡";
        aUser.portraitUri=@"http://pic6.huitu.com/res/20130116/84481_20130116142820494200_1.jpg";
        aUser.userId=@"910300000003352651";
        canshu(aUser);
    }
    else{
        RCUserInfo *aUser =[[RCUserInfo alloc]init];
        aUser=groupMember;
        canshu(aUser);
    }
    */
    
}

@end
