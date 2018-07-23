//
//  ZCUICore.m
//  SobotKit
//
//  Created by zhangxy on 2018/1/29.
//  Copyright © 2018年 zhichi. All rights reserved.
//

#import "ZCUICore.h"
#import "ZCPlatformTools.h"
#import "ZCLibServer.h"
#import "ZCIMChat.h"
#import "ZCLibClient.h"
#import "ZCLIbGlobalDefine.h"
#import "ZCUIToastTools.h"
#import "ZCStoreConfiguration.h"
#import "ZCUICustomActionSheet.h"
#import "ZCUIAskTableController.h"
#import "ZCUISkillSetView.h"
#import "ZCUILeaveMessageController.h"

#define VoiceLocalPath zcLibGetDocumentsFilePath(@"/sobot/")

@interface ZCUICore()<ZCMessageDelegate>{
    
    ZCLibMessage                *recordModel;
    
    NSMutableDictionary *allFaceDict;
    
    ///////////////////////定时器相关/////////////////////////////////
    int     userTipTime;        // 用户不说话
    BOOL    isUserTipTime;      // 是否提醒了
    
    int     adminTipTime;       // 客服超时
    BOOL    isAdminTipTime;     // 是否已经提醒
    
    int     lowMinTime;         // 不足1分钟，提醒
    
    UITextView *inputTextView;   // 输入框
    int        inputCount;       // 循环计数
    NSString   *lastMessage;     // 上次计数时的内容
    BOOL       isSendInput;
    
    BOOL        isComment;  // 正在调用提交评价接口
}
@property(nonatomic,strong) ZCUISkillSetView *skillSetView;



@property(nonatomic,strong) NSString *curCid;
@property(nonatomic,strong) ZCLibInitInfo *libInfo;

@property(nonatomic,strong) ZCLibServer *apiServer;

@property(nonatomic,strong) NSTimer *tipTimer;


@property(nonatomic,assign) BOOL isCidLoading;




/** 未知说辞计数*/
@property (nonatomic, assign) NSUInteger       unknownWordsCount;

/** 是否正在执行转人工 */
@property (nonatomic, assign) BOOL             isTurnLoading;

@end

@implementation ZCUICore

static ZCUICore *_instance = nil;
static dispatch_once_t onceToken;
+(ZCUICore *)getUICore{
    dispatch_once(&onceToken, ^{
        if(_instance == nil){
            _instance = [[ZCUICore alloc] initPrivate];
        }
    });
    return _instance;
}

-(id)initPrivate{
    self=[super init];
    if(self){
        _apiServer = [ZCLibServer getLibServer];
        _listArray = [[NSMutableArray alloc] init];
    }
    return self;
}

-(id)init{
    return [[self class] getUICore];
}

-(ZCPlatformInfo *) getPlatfromInfo{
    return [[ZCPlatformTools sharedInstance] getPlatformInfo];
}

-(ZCLibConfig *) getLibConfig{
    return [self getPlatfromInfo].config;
}

-(NSMutableArray *) chatMessages{
    return _listArray;
}

-(void)openSDKWith:(ZCLibInitInfo *)info uiInfo:(ZCKitInfo *)zckitInfo Delegate:(id<ZCUICoreDelegate>)delegate blcok:(initResultBlock )resultBlock{
    _libInfo = info;
    _kitInfo = zckitInfo;
    _ResultBlock = resultBlock;
    [[NSUserDefaults standardUserDefaults] setValue:info.skillSetId forKey:@"UserDefaultGroupID"];
    [[NSUserDefaults standardUserDefaults] setValue:info.skillSetName forKey:@"UserDefaultGroupName"];
    
    // 评价页面是否消失
    _isDismissSheetPage = YES;
    [[ZCIMChat getZCIMChat] setChatPageState:ZCChatPageStateActive];
    
    // 判断是否需要重新初始化
    if([ZCPlatformTools checkInitParameterChanged]){
        if (_listArray == nil) {
            _listArray = [NSMutableArray arrayWithCapacity:0];
        }
        if(_ResultBlock){
            _ResultBlock(ZCInitStatusLoading,_listArray,@"开始初始化");
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(showSoketConentStatus:)]) {
            [self.delegate showSoketConentStatus:201];
        }
        
//        if (self.delegate && [self.delegate respondsToSelector:@selector(onPageStatusChanged:message:obj:)]) {
//            [self.delegate onPageStatusChanged:ZCInitStatusConnecting message:@"201" obj:nil];
//        }
        [ZCLogUtils logHeader:LogHeader debug:@"初始化方法调用"];
        self.isInitLoading = YES;
        // 清理数据
        [self clearData];
        self.isSayHello = NO;
        self.isShowRobotHello = NO;
        self.delegate = delegate;
        _isCidLoading = NO;
        __weak ZCUICore * safeCore = self;
        [_apiServer initSobotSDK:^(ZCLibConfig *config) {
            [ZCLogUtils logHeader:LogHeader debug:@"%@",config];
            _isShowForm = NO;
            // 必须设置，不然收不到消息
            [ZCIMChat getZCIMChat].delegate = nil;
            [ZCIMChat getZCIMChat].delegate = self;
            
            
            // 此处为赋值设备ID 为未读消息数做处理
            [ZCLibClient getZCLibClient].libInitInfo = config.zcinitInfo;
            _curCid = config.cid;
            
            ZCPlatformInfo *info = [self getPlatfromInfo];
            info.config = config;
            [[ZCPlatformTools sharedInstance] savePlatformInfo:info];
            
            [self configInitView];
            
            if(_ResultBlock){
                _ResultBlock(ZCInitStatusLoadSuc,_listArray,@"初始化成功");
            }
            
            
            if(zcLibIs_null(_cids) || _cids.count == 0){
                // 获取历史记录
                [self getChatMessages];
                
                // 获取cid列表
                [self getCids];
            }
            
        } error:^(ZCNetWorkCode status) {
            
            if(_ResultBlock){
                _ResultBlock(ZCInitStatusFail,_listArray,@"初始化失败");
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (safeCore.delegate && [safeCore.delegate respondsToSelector:@selector(onPageStatusChanged:message:obj:)]) {
                    [safeCore.delegate onPageStatusChanged:ZCShowStatusGoBack message:nil obj:nil];
                }
            });
            safeCore.isInitLoading = NO;
        } appIdIncorrect:^(NSString *appId) {
            
            if(_ResultBlock){
                _ResultBlock(ZCInitStatusFail,_listArray,@"请输入正确的appkey");
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (self.delegate && [self.delegate respondsToSelector:@selector(onPageStatusChanged:message:obj:)]) {
                    [safeCore.delegate onPageStatusChanged:ZCShowStatusGoBack message:nil obj:nil];
                }
            });
            safeCore.isInitLoading = NO;
        }];
    }else{
        if(_ResultBlock){
            _ResultBlock(ZCInitStatusLoading,_listArray,@"开始初始化");
        }
        self.delegate = delegate;
        [self configInitView];// 设置键盘
        
        // 必须设置，不然收不到消息
        [ZCIMChat getZCIMChat].delegate = nil;
        [ZCIMChat getZCIMChat].delegate = self;
        
        
        if([self getPlatfromInfo].messageArr!=nil && [self getPlatfromInfo].messageArr.count > 0){
            if (_listArray == nil) {
                _listArray = [NSMutableArray arrayWithCapacity:0];
            }
            [_listArray addObjectsFromArray:[self getPlatfromInfo].messageArr];
        }
        
        if (_cids == nil) {
            _cids = [NSMutableArray arrayWithCapacity:0];
        }
        _cids = [self getPlatfromInfo].cidsArray;
        if(_cids !=nil && _cids.count>0){
            _curCid = [_cids lastObject];
            [_cids removeAllObjects];
        }else{
            _curCid = nil;
        }
        
        _isCidLoading = YES;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if(_ResultBlock){
                _ResultBlock(ZCInitStatusLoadSuc,_listArray,@"初始化成功");
            }
        });
        
        
        int index = -1;
        if(_listArray!=nil && _listArray.count>0){
            
            
            for (int i = 0; i< _listArray.count; i++) {
                ZCLibMessage *libMassage = _listArray[i];
                // 删除上一次商品信息
                if(libMassage.tipStyle == ZCReceivedMessageUnKonw){
                    index = i;
                    break;
                }
            }
            
            if(index >= 0){
                [_listArray removeObjectAtIndex:index];
            }
        }else{
            if(self.delegate && [self.delegate respondsToSelector:@selector(onPageStatusChanged:message:obj:)]){
                
                [self.delegate onPageStatusChanged:ZCInitStatusCompleteNoMore message:@"加载历史消息完成" obj:nil];
            }
        }
        
        if([self getPlatfromInfo].config.isArtificial){
            // 设置昵称
            [self setTitleName:[self getPlatfromInfo].config.senderName];
        }
        
        /**
         *  todo 判断未读消息数
         */
        // 此处需要在 ZCUIKitManager类中处理标记，解决ZCUIConfigManager中为空的问题  先清理掉原来的商品信息，在添加未读消息数
        int unReadNum = [[ZCIMChat getZCIMChat] getUnReadNum];
        BOOL changedMessage = NO;
        if (unReadNum >=1 && _listArray.count >= unReadNum) {
            _lineModel = [self createMessageToArrayByAction:ZCTipCellMessageNewMessage type:0 name:@"" face:@"" tips:2 content:nil];
            [_listArray insertObject:_lineModel atIndex:_listArray.count - unReadNum];
            changedMessage = YES;
        }
        
        if(unReadNum >= 10){
            if(self.delegate && [self.delegate respondsToSelector:@selector(onPageStatusChanged:message:obj:)]){
                [self.delegate onPageStatusChanged:ZCShowStatusUnRead message:[NSString stringWithFormat:@" %d%@",unReadNum,[NSString stringWithFormat:@"%@",ZCSTLocalString(@"条未读消息")]] obj:nil];
            }
        }
        
        
        // 显示商品信息
        if(_kitInfo.productInfo!=nil && [self getPlatfromInfo].config.isArtificial  && ![@"" isEqualToString:_kitInfo.productInfo.title] && ![@"" isEqualToString:_kitInfo.productInfo.link]){
            ZCLibMessage *msg = [self createMessageToArrayByAction:ZCTipCellMessageNullMessage type:0 name:@"" face:@"" tips:ZCReceivedMessageUnKonw content:nil];
            [_listArray addObject:msg];
            
            changedMessage = YES;
        }
        
        if(self.delegate && [self.delegate respondsToSelector:@selector(onPageStatusChanged:message:obj:)]){
            
            [self.delegate onPageStatusChanged:ZCShowStatusMessageChanged message:nil obj:nil];
        }
    }
}

-(void)setTitleName:(NSString *) title{
    // 设置昵称
    if(self.delegate && [self.delegate respondsToSelector:@selector(onPageStatusChanged:message:obj:)]){
        [self.delegate onPageStatusChanged:ZCShowStatusChangedTitle message:title obj:nil];
    }
}


-(void)getChatMessages{
    if(zcLibIs_null(_curCid) && !_isCidLoading){
        [self getCids];
        return;
    }
    
    if(zcLibIs_null(_curCid) && _isCidLoading){
        if(_cids!=nil && _cids.count>0){
            _curCid = [_cids lastObject];
        }else{
            
            if(self.delegate && [self.delegate respondsToSelector:@selector(onPageStatusChanged:message:obj:)]){
                
                [self.delegate onPageStatusChanged:ZCInitStatusCompleteNoMore message:@"加载历史消息完成" obj:nil];
            }
            return;
        }
    }
    
    
    [_apiServer getHistoryMessages:_curCid withUid:zcLibConvertToString([self getPlatfromInfo].config.uid) start:^{
        if(self.delegate && [self.delegate respondsToSelector:@selector(onPageStatusChanged:message:obj:)]){
            
            [self.delegate onPageStatusChanged:ZCInitStatusStartMessages message:@"开始加载历史记录" obj:nil];
        }
    } success:^(NSMutableArray *messages, ZCNetWorkCode sendCode) {
        
        if(messages && messages.count>0){
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:
                                    NSMakeRange(0,[messages count])];
            
            [_listArray insertObjects:messages atIndexes:indexSet];
        }
        
        if(_isCidLoading && _cids!=nil && _cids.count>0){
            NSString *lastCid = [_cids lastObject];
            if([_curCid isEqual:lastCid]){
                [_cids removeLastObject];
            }
            _curCid = [_cids lastObject];
            [_cids removeLastObject];
        }else{
            _curCid = nil;
        }
        
        if(!_isShowRobotHello){
            // 判断是否显示机器人欢迎语
            // 不是人工、不是人工优先，不是仅人工、不是在线状态、不是排队状态、没显示过欢迎语  (ustatus = -1 时不要显示欢迎语)
            if(![self getLibConfig].isArtificial
               && [self getLibConfig].type!=4
               && [self getLibConfig].type !=2
               && [self getLibConfig].ustatus!=1
               && [self getLibConfig].ustatus!=-2
               && !_isSayHello
               && [self getLibConfig].ustatus != -1){
                
                // 添加机器人欢迎语
                _isShowRobotHello = YES;
                [self keyboardOnClickAddRobotHelloWolrd];
            }
        }
        
        if(_isCidLoading && _cids.count == 0){
            if(self.delegate && [self.delegate respondsToSelector:@selector(onPageStatusChanged:message:obj:)]){
                
                [self.delegate onPageStatusChanged:ZCInitStatusCompleteNoMore message:@"加载历史消息完成" obj:nil];
            }
        }else{
            if(self.delegate && [self.delegate respondsToSelector:@selector(onPageStatusChanged:message:obj:)]){
                
                [self.delegate onPageStatusChanged:ZCShowStatusMessageChanged message:@"加载历史消息完成" obj:nil];
            }
        }
    } failed:^(NSString *errorMessage, ZCNetWorkCode errorCode) {
        
    }];
}

-(void)getCids{
    if(_isCidLoading){
        return;
    }
    
    if(zcLibIs_null(_cids)){
        _cids  = [[NSMutableArray alloc] init];
    }else{
        [_cids removeAllObjects];
    }
    
    [_apiServer getChatUserCids:_libInfo.scopeTime config:[self getPlatfromInfo].config start:^{
         _isCidLoading = NO;
    } success:^(NSDictionary *dict, ZCNetWorkCode sendCode) {
        _isCidLoading = YES;
        NSArray *arr = dict[@"data"][@"cids"];
        if(!zcLibIs_null(arr)  && arr.count > 0){
            for (NSString *itemCid in arr) {
                if(!zcLibIs_null(_curCid) && [itemCid isEqual:_curCid]){
                    continue;
                }
                [_cids addObject:itemCid];
                
            }
            
            if(zcLibIs_null(_curCid)){
                _curCid = [_cids lastObject];
                [self getChatMessages];
            }else{
                if(self.delegate && [self.delegate respondsToSelector:@selector(onPageStatusChanged:message:obj:)]){
                    
                    [self.delegate onPageStatusChanged:ZCInitStatusCompleteNoMore message:@"加载历史消息完成" obj:nil];
                }
            }
        }
    } failed:^(NSString *errorMessage, ZCNetWorkCode errorCode) {
        
    }];
}


-(void)checkUserServiceWithObject:(id)obj{
    ZCPlatformInfo *info = [[ZCPlatformTools sharedInstance] getPlatformInfo];
    // 没有初始化
    if(zcLibIs_null(info.config) || zcLibConvertToString(info.config.uid).length == 0){
        return;
    }
    
    // 正在执行转人工
    if(_isTurnLoading){
        return;
    }
    
    // 被拉黑
    if(info.config.isblack){
        // 如果是被拉黑的用户在仅人工的模式直接跳到留言
        if (info.config.type == 2 && info.config.msgFlag == 0) {
            if(_delegate && [_delegate respondsToSelector:@selector(jumpNewPageVC:IsExist:isShowToat:tipMsg:Dict: )]){
                //  跳转到留言不直接退出SDK
                [self.delegate jumpNewPageVC:ZC_LeaveMsgPage IsExist:LeaveExitTypeISCOLSE isShowToat:YES tipMsg:@"" Dict:nil];
            }
            return;
        }
    }
    
    
    // 如果有指定的客服ID 先传客服ID
    if (_kitInfo!= nil && zcLibConvertToString([ZCLibClient getZCLibClient].libInitInfo.receptionistId).length>0) {
        [self turnUserService:nil object:obj];
        return;
    }
    
    
    if(_kitInfo!=nil && zcLibConvertToString([ZCLibClient getZCLibClient].libInitInfo.skillSetId).length>0){
        // 设置外部技能组
        [[ZCUICore getUICore] turnUserService:nil object:obj];
        return;
    }
    
    if (self.isShowForm) {
        [[ZCUICore getUICore] turnUserService:nil object:obj];
        return;
    }
    
    //判断是否需要显示技能组
    //1、根据初始化信息直接判断，不显示技能组
    if(![self getLibConfig].groupflag){
        [[ZCUICore getUICore] turnUserService:nil object:obj];
        return;
    }
    
    // 加载动画K
    [[ZCUIToastTools shareToast] showProgress:@"" with:(UIView *)_delegate];
    
    [_apiServer getSkillSet:info.config start:^{
        
    } success:^(NSMutableArray *messages, ZCNetWorkCode sendCode) {
        // 加载动画
        [[ZCUIToastTools shareToast] dismisProgress];
        [ZCLogUtils logHeader:LogHeader debug:@"%@",messages];
        
        if(sendCode != ZC_NETWORK_FAIL){
            // 根据结果判定显示转人工操作
            [self showSkillSetView:messages];
        }
    } failed:^(NSString *errorMessage, ZCNetWorkCode errorCode) {
        // 加载动画
        [[ZCUIToastTools shareToast] dismisProgress];
    }];
}

-(void)turnUserService:(void (^)(int, NSMutableArray *, NSString *))ResultBlock object:(id)obj{
    ZCPlatformInfo *info = [[ZCPlatformTools sharedInstance] getPlatformInfo];
    if(zcLibIs_null(info.config)){
        return;
    }
    
    if(_isTurnLoading){
        return;
    }
    
    // 2.4.2新增询前表单
    // 在转人工的事件进行操作
    if (!_isShowForm) {
        // 关闭加载动画
        [[ZCUIToastTools shareToast] dismisProgress];
        [_apiServer getAskTabelWithUid:[self getPlatfromInfo].config.uid start:^{
            
        } success:^(NSDictionary *dict, ZCNetWorkCode sendCode) {
            @try{
                if ([zcLibConvertToString(dict[@"code"]) intValue] == 1 && [zcLibConvertToString(dict[@"data"][@"openFlag"]) intValue] == 1) {
                    if (self.delegate && [self.delegate respondsToSelector:@selector(jumpNewPageVC:IsExist:isShowToat:tipMsg:Dict:)]) {
                        [self.delegate jumpNewPageVC:ZC_AskTabelPage IsExist:LeaveExitTypeISCOLSE isShowToat:NO tipMsg:(NSString*)obj Dict:dict];
                    }                    
                }else{
                    // 去执行转人工的操作
                    [self doConnectUserService];
                }
                
            } @catch (NSException *exception) {
                
            } @finally {
                
            }
            
            self.isShowForm = YES;
        } failed:^(NSString *errorMessage, ZCNetWorkCode errorCode) {
            
        }];
        
    }else{
        [self doConnectUserService];
    }
}


#pragma mark -- 判断是否需要显示技能组(以及点击技能组后的加载动画)
/**
 判断显示技能组

 @param groupArr 技能组列表
 */
-(void)showSkillSetView:(NSMutableArray *) groupArr{
    /**
     *  技能组没有数据
     */
    if(groupArr == nil || groupArr.count==0){
        [[ZCUICore getUICore] turnUserService:nil object:@""];
        
        return;
    }
    
    // 只有一个技能组
    if(groupArr.count==1){
        ZCLibSkillSet  *setModel = [groupArr objectAtIndex:0];
        [ZCLibClient getZCLibClient].libInitInfo.skillSetId = setModel.groupId;
        [ZCLibClient getZCLibClient].libInitInfo.skillSetName = setModel.groupName;
        [[ZCUICore getUICore] turnUserService:nil object:@""];
        return;
    }
    
    // 计数
    NSInteger flagCount = 0;
    for(ZCLibSkillSet *set in groupArr) {
        if (set.isOnline) {
            [ZCLibClient getZCLibClient].libInitInfo.skillSetName = set.groupName;
            [ZCLibClient getZCLibClient].libInitInfo.skillSetId = set.groupId;
            flagCount ++;
        }
    }
    // 所有客服都不在线
    if(flagCount==0 ){
        [ZCLibClient getZCLibClient].libInitInfo.skillSetName = @"";
        [ZCLibClient getZCLibClient].libInitInfo.skillSetId = @"";
        // 仅人工模式，直接留言
        if ([self getLibConfig].msgFlag == 1 && [self getLibConfig].type == 2) {
            if(_delegate && [_delegate respondsToSelector:@selector(jumpNewPageVC:IsExist:isShowToat:tipMsg: Dict:)]){
                //  跳转到留言不直接退出SDK
                [self.delegate jumpNewPageVC:ZC_LeaveMsgPage IsExist:LeaveExitTypeISNOCOLSE isShowToat:YES tipMsg:@"" Dict:nil];
            }
        }else{
            // 添加暂无客服在线提醒
            [self keyboardOnClickAddLeavemeg];
            return;
        }
    }else{
        // 回收键盘
        [ZCLibClient getZCLibClient].libInitInfo.skillSetName = @"";
        [ZCLibClient getZCLibClient].libInitInfo.skillSetId = @"";
        
        __weak ZCUICore * keyboard = self;
       _skillSetView  = [[ZCUISkillSetView alloc] initActionSheet:groupArr  withView:(UIView *)_delegate];
        
        [_skillSetView setItemClickBlock:^(ZCLibSkillSet *itemModel) {
            [ZCLogUtils logHeader:LogHeader debug:@"选择一个技能组"];
            // 客服不在线且开启了留言开关
            if(!itemModel.isOnline ){
                // 点击技能组弹框上的留言跳转
                if ([keyboard getLibConfig].msgFlag == 0) {
                    if ([keyboard getLibConfig].type == 2) {
                        if (keyboard.delegate && [keyboard.delegate respondsToSelector:@selector(jumpNewPageVC:IsExist:isShowToat:tipMsg:Dict:)]) {
                            [keyboard.delegate jumpNewPageVC:ZC_LeaveMsgPage IsExist:LeaveExitTypeISBACKANDUPDATE isShowToat:YES tipMsg:@"" Dict:nil];
                        }
                        
                        
                        return ;
                    }
                    if ([keyboard getLibConfig].type == 3) {
            
                        if (keyboard.delegate && [keyboard.delegate respondsToSelector:@selector(jumpNewPageVC:IsExist:isShowToat:tipMsg: Dict:)]) {
                            [keyboard.delegate jumpNewPageVC:ZC_LeaveMsgPage IsExist:LeaveExitTypeISROBOT isShowToat:YES tipMsg:@"" Dict:nil];
                        }
                        return;
                    }
                    if ([keyboard getLibConfig].type == 4) {
                        
                        if (keyboard.delegate && [keyboard.delegate respondsToSelector:@selector(jumpNewPageVC:IsExist:isShowToat:tipMsg: Dict:)]) {
                            [keyboard.delegate jumpNewPageVC:ZC_LeaveMsgPage IsExist:LeaveExitTypeISUSER isShowToat:YES tipMsg:@"" Dict:nil];
                        }
                        
                        return ;
                    }
                    if (keyboard.delegate && [keyboard.delegate respondsToSelector:@selector(jumpNewPageVC:IsExist:isShowToat:tipMsg: Dict:)]) {
                        [keyboard.delegate jumpNewPageVC:ZC_LeaveMsgPage IsExist:LeaveExitTypeISNOCOLSE isShowToat:YES tipMsg:@"" Dict:nil];
                    }
                }
                
            }else{
                // 点击之后就影藏
                [keyboard.skillSetView tappedCancel:NO];
                
                [ZCLibClient getZCLibClient].libInitInfo.skillSetName = itemModel.groupName;
                [ZCLibClient getZCLibClient].libInitInfo.skillSetId = itemModel.groupId;
                
                // 加载动画
                [[ZCUIToastTools shareToast] showProgress:@"" with:(UIView *)keyboard.delegate];
                
                // 执行转人工
                [keyboard checkUserServiceWithObject:@"clearskillId"];
            }
        }];
        
        __weak  ZCUICore * safeCore = self;
        // 直接关闭技能组
        [_skillSetView setCloseBlock:^{
            
            // 关闭技能组（取消按钮）选项，如果是仅人工模式和人工优先 退出   // 2.4.2 只有仅人工模式起效
            if([self getPlatfromInfo].config.type == 2){
                if(keyboard.delegate && [_delegate respondsToSelector:@selector(onPageStatusChanged:message:obj:)]){
                    [keyboard.delegate onPageStatusChanged:ZCInitStatusCloseSkillSet message:@"直接关闭技能组" obj:nil];
                }
            }else if([self getPlatfromInfo].config.type == 4){
                // 添加机器人欢迎语
                [safeCore keyboardOnClickAddRobotHelloWolrd];
                // 设置机器人的键盘样式
                if (safeCore.delegate && [safeCore.delegate respondsToSelector:@selector(onPageStatusChanged:message:obj:)]) {
                    [safeCore.delegate onPageStatusChanged:ZCSetKeyBoardStatus message:@"ZCKeyboardStatusRobot" obj:nil];
                }
            }
            
            
        }];
        
        // 关闭技能组页面 和机器人会话并提示留言
        [_skillSetView closeSkillToRobotBlock:^{
            // 添加暂无客服在线提醒
            [self keyboardOnClickAddLeavemeg];
        }];
        
        [_skillSetView showInView:(UIView *)_delegate];
    }
}



/**
 隐藏技能组
 */
-(void)dismissSkillSetView{
    if(_skillSetView){
        // 点击之后就影藏
        [_skillSetView tappedCancel:NO];
    }
}



/**
 执行转人工操作
 */
-(void)doConnectUserService{
    
    _isTurnLoading = YES;
    __weak ZCUICore *safeVC = self;
    NSString *groupId = zcLibConvertToString([ZCLibClient getZCLibClient].libInitInfo.skillSetId);
    NSString *groupName = zcLibConvertToString([ZCLibClient getZCLibClient].libInitInfo.skillSetName);
    
    NSString  *aid = [ZCLibClient getZCLibClient].libInitInfo.receptionistId ;
    
    // 如果指定客服，客服不在线是否还要继续往下转，tranFlag=0往下转，默认为0
    int  tranFlag = [ZCLibClient getZCLibClient].libInitInfo.tranReceptionistFlag;
    if (self.isDoConnectedUser) {
        aid = @"";
        tranFlag = 0;
        self.isDoConnectedUser = NO;
    }
    
    BOOL isWaiting = NO;
    // [ZCIMChat getZCIMChat].waitMessage!=nil &&  [[self getZCLibConfig].cid isEqual:[ZCIMChat getZCIMChat].waitMessage.cid]
    if([self getPlatfromInfo].waitintMessage!=nil &&  [[self getLibConfig].cid isEqual:[self getPlatfromInfo].waitintMessage.cid]){
        isWaiting = YES;
    }
    
    [_apiServer connectOnlineCustomer:groupId groupName:groupName config:[self getLibConfig] Aid:aid TranFlag:tranFlag current:isWaiting start:^{
        if (safeVC.delegate && [self.delegate respondsToSelector:@selector(onPageStatusChanged:message:obj:)]) {
            [safeVC.delegate onPageStatusChanged:ZCShowStatusConnectingUser message:@"开始转人工" obj:nil];
        }
    } result:^(NSDictionary *dict, ZCConnectUserStatusCode status) {
        if (safeVC.delegate && [self.delegate respondsToSelector:@selector(onPageStatusChanged:message:obj:)]) {
            [safeVC.delegate onPageStatusChanged:ZCShowStatusConnectFinished message:@"转人工完成" obj:nil];
        }
        
        safeVC.isTurnLoading = NO;
        
        
        [[ZCUIToastTools shareToast] dismisProgress];
        
        safeVC.receivedName = [safeVC getPlatfromInfo].config.robotName;
        
        [self cleanUserCount];
        [self cleanAdminCount];
        
        [ZCLogUtils logHeader:LogHeader debug:@"连接完成！状态：%zd %@",status,dict];
        [safeVC configConnectedResult:dict code:status];
        
        
    }];
}


// 转人工数据解析
-(void)configConnectedResult:(NSDictionary *) dict code:(ZCConnectUserStatusCode) status{
    if([dict[@"data"][@"status"] intValue]==5){
        // 用户长时间没有说话，已经超时 （做机器人超时下线的操作显示新会话的键盘样式）
        [ZCUICore getUICore].isShowForm = NO;
        return;
    }
    
    // status = 6 说明当前对接的客服转人工没有成功
    if ([dict[@"data"][@"status"] intValue] == 6) {
        self.isDoConnectedUser = YES;
        [ZCUICore getUICore].isShowForm = NO;
        // 回复原始值，在次转人工时，重新走转人工逻辑，不在直接转其他客服
        [ZCLibClient getZCLibClient].libInitInfo.receptionistId = @"";
        // 执行转人工的操作
        [self checkUserServiceWithObject:nil];
        return;
    }
    //[dict[@"data"][@"status"] intValue] == 7   status == ZCConnectUserWaitingThreshold
    if (status == ZCConnectUserWaitingThreshold) {
        [ZCLibClient getZCLibClient].libInitInfo.skillSetId = @"";
        // 排队达到阀值
        // 1.留言开关是否开启
        // 2.各种接待模式
        // 3.键盘的切换
        // 4.添加提示语
        // 5.设置键盘样式
        [ZCUICore getUICore].isShowForm = NO;
        if ([self getPlatfromInfo].config.type ==2){
            if (self.delegate && [self.delegate respondsToSelector:@selector(onPageStatusChanged:message:obj:)]) {
                [self.delegate onPageStatusChanged:ZCSetKeyBoardStatus message:@"ZCKeyboardStatusNewSession" obj:nil];
            }
            
            // 设置昵称
            self.receivedName =ZCSTLocalString(@"排队已满");

        }
        // 设置昵称
        if (self.delegate && [self.delegate respondsToSelector:@selector(setTitleName:)]) {
            [self.delegate setTitleName:_receivedName];
        }
        // 添加提示语
        if ([self getPlatfromInfo].config.msgFlag == 0) {
            //  跳转到留言不直接退出SDK
            if (self.delegate && [self.delegate respondsToSelector:@selector(jumpNewPageVC:IsExist:isShowToat:tipMsg: Dict:)]) {
                [self.delegate jumpNewPageVC:ZC_LeaveMsgPage  IsExist:LeaveExitTypeISNOCOLSE isShowToat:YES tipMsg:zcLibConvertToString(dict[@"msg"]) Dict:nil];
            }
            
        }
        return;
    }
    
    // 排队
    if([self getPlatfromInfo].config.isArtificial || status == ZCConnectUserOfWaiting){
        for(ZCLibMessage *item in self.listArray){
            if(item.tipStyle>0){
                item.sysTips=[item.sysTips stringByReplacingOccurrencesOfString:ZCSTLocalString(@"您可以留言") withString:@""];
            }
        }
        if(self.delegate && [self.delegate respondsToSelector:@selector(onPageStatusChanged:message:obj:)]){
            [self.delegate onPageStatusChanged:ZCShowStatusMessageChanged message:@"" obj:_listArray];
        }
    }
    
    // 转人工成功或者已经是人工状态
    if(status == ZCConnectUserBeBlock){// 说明当前用户是黑名单用户
        [self addTipsListenerMessage:ZCTipCellMessageIsBlock];
        
    }else if(status==ZCConnectUserSuccess || status == ZCConnectUserBeConnected){
        self.receivedName = zcLibConvertToString(dict[@"data"][@"aname"]);
        ZCLibConfig *libConfig = [self getPlatfromInfo].config;
        libConfig.isArtificial = YES;
        libConfig.senderFace = zcLibConvertToString(dict[@"data"][@"aface"]);
        libConfig.senderName = self.receivedName;
        
        int messageType=ZCReceivedMessageNews;
        
        ZCLibMessage *message = [_apiServer  setLocalDataToArr:ZCTipCellMessageOnline type:messageType duration:@"" style:ZCReceivedMessageOnline send:NO name:_receivedName content:_receivedName config:libConfig];
        message.senderFace = zcLibConvertToString(dict[@"data"][@"aface"]);
        
        // 是否设置语音开关
        if (self.delegate && [self.delegate respondsToSelector:@selector(onPageStatusChanged:message:obj:)]) {
            [self.delegate onPageStatusChanged:ZCSetKeyBoardStatus message:@"ZCKeyboardStatusUser" obj:nil];
        }
        
        // 添加上线消息
        [self addReceivedNameMessageToList:message];
        
        // 欢迎语客服
        message = [_apiServer setLocalDataToArr:ZCTipCellMessageAdminHelloWord type:0 duration:@"" style:0 send:NO name:self.receivedName content:nil config:libConfig];
        message.senderFace = zcLibConvertToString(dict[@"data"][@"aface"]);
        
        [self addReceivedNameMessageToList:message];
        // 连接失败
    }else if(status==ZCConnectUserOfWaiting){
        int messageType = ZCReceivedMessageWaiting;
        if ([self getPlatfromInfo].config.type == 2) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 if (self.delegate && [self.delegate respondsToSelector:@selector(onPageStatusChanged:message:obj:)]) {
                    [self.delegate onPageStatusChanged:ZCSetKeyBoardStatus message:@"ZCKeyboardStatusWaiting" obj:nil];
                }
                
            });
        }else{
            self.receivedName = zcLibConvertToString(dict[@"data"][@"aname"]);
          
            if (self.delegate && [self.delegate respondsToSelector:@selector(onPageStatusChanged:message:obj:)]) {
                [self.delegate onPageStatusChanged:ZCSetKeyBoardStatus message:@"ZCKeyboardStatusRobot" obj:nil];
            }
        }
        
        ZCLibMessage *message = [_apiServer setLocalDataToArr:ZCTipCellMessageWaiting type:ZCReceivedMessageWaiting duration:@"" style:messageType send:NO name:self.receivedName content:zcLibConvertToString(dict[@"data"][@"count"]) config:[self getPlatfromInfo].config];
        [self addReceivedNameMessageToList:message];
        //        [ZCIMChat getZCIMChat].waitMessage = message;
        [self getPlatfromInfo].waitintMessage = message;
        // 如果没有机器人欢迎语，添加机器人欢迎语 (只在转人工不成功的情况下添加) 仅人工模式不添加
        if ([self getPlatfromInfo].config.type != 2 ) {
            // 添加机器人欢迎语
            [self keyboardOnClickAddRobotHelloWolrd];
        }
        
        // 没有客服在线
    } else if(status==ZCConnectUserNoAdmin){
        [ZCUICore getUICore].isShowForm = NO;
        if (self.listArray.count != 0) {
            int index = 0;
            for (int i = 0; i< self.listArray.count; i++) {
                ZCLibMessage *libmeg = self.listArray[i];
                if ([[self getPlatfromInfo].config.robotHelloWord isEqual:libmeg.sysTips] || [[self getPlatfromInfo].config.robotHelloWord isEqual:libmeg.richModel.msg]) {
                    index ++;
                }
            }
            if (index == 0) {
                // 如果没有机器人欢迎语，添加机器人欢迎语 (只在转人工不成功的情况下添加) 仅人工模式不添加
                if ([self getPlatfromInfo].config.type != 2 ) {
                    // 添加机器人欢迎语
                    [self keyboardOnClickAddRobotHelloWolrd];
                }
            }
        }
        
        // 设置机器人的键盘样式
        if (self.delegate && [self.delegate respondsToSelector:@selector(onPageStatusChanged:message:obj:)]) {
            [self.delegate onPageStatusChanged:ZCSetKeyBoardStatus message:@"ZCKeyboardStatusRobot" obj:nil];
        }
        
#pragma mark -- 刷新的问题 太快键盘没有刷新状态
        // 添加暂无客服在线说辞
        [self addTipsListenerMessage:ZCTipCellMessageUserNoAdmin];
        
        // 针对仅人工模式 是否开启留言并没有接入成功 设置 未接入 键盘的区别
        if ([self getPlatfromInfo].config.type ==2){
            if([self getPlatfromInfo].config.msgFlag == 1){

                if (self.delegate && [self.delegate respondsToSelector:@selector(onPageStatusChanged:message:obj:)]) {
                    [self.delegate onPageStatusChanged:ZCSetKeyBoardStatus message:@"ZCKeyboardStatusNewSession" obj:nil];
                }
            }else if([self getPlatfromInfo].config.msgFlag == 0){
                if (self.delegate && [self.delegate respondsToSelector:@selector(onPageStatusChanged:message:obj:)]) {
                    [self.delegate onPageStatusChanged:ZCSetKeyBoardStatus message:@"ZCKeyboardStatusNewSession" obj:nil];
                }
                
            }
            // 设置昵称
            self.receivedName = ZCSTLocalString(@"暂无客服在线");
        }
    }else if(status == ZCConnectUserServerFailed){
        [ZCUICore getUICore].isShowForm = NO;
        // status == -1 重连
        if ([self getPlatfromInfo].config.type ==2){
            if([self getPlatfromInfo].config.msgFlag == 1){
                // 添加暂无客服在线说辞
                [self addTipsListenerMessage:ZCTipCellMessageUserNoAdmin];
            }
            if (self.delegate && [self.delegate respondsToSelector:@selector(onPageStatusChanged:message:obj:)]) {
                [self.delegate onPageStatusChanged:ZCSetKeyBoardStatus message:@"ZCKeyboardStatusNewSession" obj:nil];
            }
            // 设置昵称
            self.receivedName = ZCSTLocalString(@"暂无客服在线");
        }
        
    }
    
    // 设置昵称
    if (self.delegate && [self.delegate respondsToSelector:@selector(setTitleName:)]) {
        [self.delegate setTitleName:_receivedName];
    }
}


/**
 根据当前条件类型，封装消息实体，并添加到当前集合中展现
 
 @param action 提示类型
 @param msgType 消息类型
 @param uname 当前发送名称
 @param face 头像
 @param tipStyle 是不是提醒，不是0都是提示语
 @param messageText 消息内容
 @return ZCLibMessage对象
 */
-(ZCLibMessage *)createMessageToArrayByAction:(ZCTipCellMessageType) action type:(int)msgType name:(NSString *) uname face:(NSString *) face tips:(int) tipStyle content:(NSString *)messageText{
    
    if (action == ZCTipCellMessageRobotHelloWord) {
        if(_isSayHello){
            return nil;
        }
        _isSayHello = YES;
    }
    
    ZCLibConfig *conf = [self getPlatfromInfo].config;
    
    
    ZCLibMessage *temModel=[[ZCLibMessage alloc] init];
    temModel.date         = zcLibDateTransformString(FormateTime, [NSDate date]);
    //    temModel.contentTemp  = text;
    temModel.cid          = conf.cid;
    temModel.action       = 0;
    temModel.sender       = conf.uid;
    temModel.senderName   = uname;
    temModel.senderFace   = face;
    
    NSString *msg ;
    
    if (action == ZCTipCellMessageRobotHelloWord) {
        msg = [self getPlatfromInfo].config.robotHelloWord;
    }else if (action == ZCTipCellMessageUserTipWord){
        msg = [self getPlatfromInfo].config.userTipWord;
    }else if (action == ZCTipCellMessageAdminTipWord){
        msg = [self getPlatfromInfo].config.adminTipWord;
    }else if (action == ZCTipCellMessageUserOutWord){
        msg = [self getPlatfromInfo].config.userOutWord;
    }else if (action == ZCTipCellMessageAdminHelloWord){
        msg = [self getPlatfromInfo].config.adminHelloWord;
    }else if (action == ZCTipCellMessageUserNoAdmin){
        msg = [temModel getTipMsg:action content:conf.adminNonelineTitle isOpenLeave:conf.msgFlag];
    }else{
        msg = [temModel getTipMsg:action content:messageText isOpenLeave:conf.msgFlag];
    }
    
    if(conf.isArtificial){
        // 都是人工客服
        temModel.senderType = 2;
        if([@"" isEqual:face]){
            temModel.senderFace = conf.senderFace;
        }
    }else if(action == 0){
        // 当前发送的是转人工的消息
        temModel.senderFace = conf.senderFace;
        temModel.senderType = 0;
    }else{
        temModel.senderType = 1;
    }
    temModel.t=[NSString stringWithFormat:@"%ld",(long)[[NSDate date] timeIntervalSince1970]];
    temModel.ts           = zcLibDateTransformString(FormateTime, [NSDate date]);
    temModel.receiver     = conf.companyName;
    temModel.receiverName = conf.uid;
    temModel.offlineType  = @"1";
    temModel.receiverFace = @"";
    
    if(tipStyle>0){
        temModel.tipStyle=tipStyle;
        temModel.sysTips=msg;
        
    }else if(tipStyle == ZCReceivedMessageUnKonw){
        temModel.tipStyle = tipStyle;
    }else{
        // 人工回复时，等于7是富文本
        if(msgType==7){
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:[msg dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
            ZCLibRich *richModel=[[ZCLibRich alloc] initWithMyDict:@{@"answer":dict}WithSenderType:temModel.senderType IsHistory:NO isHotGuide:NO];
            temModel.richModel=richModel;
        }else{
            ZCLibRich *richModel=[ZCLibRich new];
            richModel.msgType = msgType;
            richModel.msg = msg;
            temModel.richModel = richModel;
        }
    }
    
    if(tipStyle==2){
        temModel.cid = @"";
    }
    // 排除以下为新消息
    if(tipStyle != 2 && tipStyle != ZCReceivedMessageUnKonw){
        [_listArray addObject:temModel];
        // 去执行刷新列表和滑动到最底部
        if (self.delegate && [self.delegate respondsToSelector:@selector(onPageStatusChanged:message:obj:)]) {
            [self.delegate onPageStatusChanged:ZCShowStatusMessageChanged message:@"" obj:nil];
        }
    }
    return temModel;
}


#pragma mark -- 网络状态监听
-(void)onConnectStatusChanged:(ZCConnectStatusCode) status{
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(onPageStatusChanged:message:obj:)]){
        [self.delegate onPageStatusChanged:ZCInitStatusConnecting message:[NSString stringWithFormat:@"%d",(int)status] obj:nil];
    }
}

#pragma mark 实现智齿消息监听
-(void)onReceivedMessage:(ZCLibMessage *)message unReaded:(int)num object:(id)obj showType:(ZCReceivedMessageType)type{
    if(![[self getPlatfromInfo].appkey isEqual:zcLibConvertToString(obj[@"appId"])]){
        return;
    }
    
    if(type==ZCReceivedMessageUnKonw){
        return;
    }
    
    _receivedName = message.senderName;
    
    if ([self getPlatfromInfo].config.type == 2 && ![self getPlatfromInfo].config.isArtificial) {
        // 设置昵称
        if(self.delegate && [self.delegate respondsToSelector:@selector(onPageStatusChanged:message:obj:)]){
            [self.delegate onPageStatusChanged:ZCShowStatusChangedTitle message:ZCSTLocalString(@"暂无客服在线") obj:nil];
        }
    }
    
    if(type == ZCReceivedMessageTansfer){
        return;
    }
    
    
    if(type==ZCReceivedMessageOnline){
        // 转人工成功
        if(self.delegate && [self.delegate respondsToSelector:@selector(onPageStatusChanged:message:obj:)]){
            [self.delegate onPageStatusChanged:ZCShowStatusUserStyle message:_receivedName obj:nil];
        }
    }
    
    if(type==ZCReceivedMessageOfflineBeBlack ||
       type==ZCReceivedMessageOfflineByAdmin ||
       type==ZCReceivedMessageOfflineByClose ||
       type== ZCReceivedMessageOfflineToLong ||
       type == ZCReceivedMessageToNewWindow){
        // 设置昵称
        if(self.delegate && [self.delegate respondsToSelector:@selector(onPageStatusChanged:message:obj:)]){
            [self.delegate onPageStatusChanged:ZCShowStatusChangedTitle message:@"" obj:nil];
        }
        
        // 设置重新接入时键盘样式
        if(self.delegate && [self.delegate respondsToSelector:@selector(onPageStatusChanged:message:obj:)]){
            [self.delegate onPageStatusChanged:ZCShowStatusReConnected message:@"" obj:nil];
        }
        
        
        if ( obj !=nil && ![obj[@"isServer"] boolValue]) {
            // 记录新会话之前是否是人工的状态  和人工超下线
            _isOffline = NO;
        }else{
            _isOffline = YES;
        }
        
        if (type == ZCReceivedMessageOfflineByAdmin || type == ZCReceivedMessageOfflineByClose) {
            _isOffline = YES;
        }
        // 拉黑
        if (type == ZCReceivedMessageOfflineBeBlack) {
            [self getPlatfromInfo].config.isblack = YES;
            [[ZCPlatformTools sharedInstance] savePlatformInfo:[self getPlatfromInfo] cache:NO];
        }
        
        for(ZCLibMessage *item in [self getPlatfromInfo].messageArr){
            if(item.tipStyle>0){
                item.sysTips=[item.sysTips stringByReplacingOccurrencesOfString:@"重新接入" withString:@""];
            }
        }
        
    }
    
    if (type == ZCReceivedMessageEvaluation){
        BOOL isUser = self.isSendToUser;
        
        [ZCLogUtils logHeader:LogHeader debug:@"当前发送状态：%d",isUser];
        // 是否转接过人工  或者当前是否是人工 （人工的评价逻辑）
        if ((_isOffline
             || [self getPlatfromInfo].config.isArtificial)
            && isUser
            && !_isAddServerSatifaction) {
            // 209 客服主动邀请评价
            _isAddServerSatifaction = YES;
        }else{
            return;
        }
        
    }
    
    [self addReceivedNameMessageToList:message];
    
}

/**
 添加消息到列表
 
 @param message 当前要添加的消息
 */
-(void)addReceivedNameMessageToList:(ZCLibMessage *) message{
    if(message==nil){
        return;
    }
    ZCLibConfig *conf = [self getPlatfromInfo].config;
    // 排队 和  接入人工成功
    if (message.tipStyle == ZCReceivedMessageWaiting) {
        // [ZCIMChat getZCIMChat].libConfig.isArtificial
        if([self getPlatfromInfo].config.isArtificial){
            //            _receivedName = [ZCIMChat getZCIMChat].libConfig.robotName;
            _receivedName = [self getPlatfromInfo].config.robotName;
            
            
            
            // 设置重新接入时键盘样式
            if(self.delegate && [self.delegate respondsToSelector:@selector(onPageStatusChanged:message:obj:)]){
                [self.delegate onPageStatusChanged:ZCShowStatusRobotStyle message:_receivedName obj:nil];
            }
            conf.isArtificial = NO;
            
        }
        
        if (conf.type == 2 && !conf.isArtificial) {
            // 设置昵称
            _receivedName = ZCSTLocalString(@"排队中...");
            // 设置重新接入时键盘样式
            if(self.delegate && [self.delegate respondsToSelector:@selector(onPageStatusChanged:message:obj:)]){
                [self.delegate onPageStatusChanged:ZCShowStatusChangedTitle message:_receivedName obj:nil];
            }
        }
        // 先清掉人工不在时的留言Tipcell
        if (_listArray !=nil && _listArray.count>0 && !conf.isArtificial) {
            NSMutableArray *indexs = [[NSMutableArray alloc] init];
            for (int i = (int)_listArray.count-1; i>=0 ; i--) {
                ZCLibMessage *libMassage = _listArray[i];
                if ( [libMassage.sysTips hasSuffix:ZCSTLocalString(@"留言")] || [libMassage.sysTips hasPrefix:ZCSTLocalString(@"排队中，您在队伍中")] ) {
                    [indexs addObject:[NSString stringWithFormat:@"%d",i]];
                }
                
            }
            if(indexs.count>0){
                for (NSString *index in indexs) {
                    [_listArray removeObjectAtIndex:[index intValue]];
                }
            }
            [indexs removeAllObjects];
        }
        
        
        if (_listArray!=nil && _listArray.count>0) {
            int index = -1;
            for (int i = ((int)_listArray.count-1); i >= 0 ; i--) {
                //注意 libMassage 和 message 之间的区别
                ZCLibMessage *libMassage = _listArray[i];
                if (libMassage.tipStyle == ZCReceivedMessageWaiting) {
                    
                    index = i;
                    break;
                }
            }
            if (index>=0) {
                [_listArray removeObjectAtIndex:index];
            }
            
        }
    }
    
    
    // 转人工成功之后清理掉所有的留言入口
    if (message.tipStyle == ZCReceivedMessageOnline) {
        
        if (_listArray !=nil) {
            NSString *indexs = @"";
            for (int i = (int)_listArray.count-1; i>=0; i--) {
                ZCLibMessage *libMassage = _listArray[i];
                
                // 删除上一条留言信息
                if ([libMassage.sysTips hasSuffix:ZCSTLocalString(@"留言")] || [libMassage.sysTips isEqualToString:conf.adminNonelineTitle]) {
                    indexs = [indexs stringByAppendingFormat:@",%d",i];
                }else if(libMassage.tipStyle == ZCReceivedMessageUnKonw){
                    // 删除上一次商品信息
                    indexs = [indexs stringByAppendingFormat:@",%d",i];
                }
            }
            if(indexs.length>0){
                indexs = [indexs substringFromIndex:1];
                for (NSString *index in [indexs componentsSeparatedByString:@","]) {
                    [_listArray removeObjectAtIndex:[index intValue]];
                }
            }
        }
        
    }
    
    
    // 过滤多余的满意度cell
    if (message.tipStyle == ZCReceivedMessageEvaluation) {
        if (_listArray !=nil && _listArray.count>0 ) {
            NSMutableArray *indexs = [[NSMutableArray alloc] init];
            for (int i = (int)_listArray.count-1; i>=0 ; i--) {
                ZCLibMessage *libMassage = _listArray[i];
                if ( libMassage.tipStyle == ZCReceivedMessageEvaluation) {
                    [indexs addObject:[NSString stringWithFormat:@"%d",i]];
                }
                
            }
            if(indexs.count>0){
                for (NSString *index in indexs) {
                    [_listArray removeObjectAtIndex:[index intValue]];
                }
            }
            [indexs removeAllObjects];
        }
    }
    [_listArray addObject:message];
    
    // 是否添加商品信息
    if(message.richModel!=nil && message.richModel.msgType == 0 && [message.richModel.msg isEqual:conf.adminHelloWord]){
        if(_kitInfo.productInfo!=nil && ![@"" isEqualToString:_kitInfo.productInfo.title] && ![@"" isEqualToString:_kitInfo.productInfo.link]){
            [_listArray addObject:[self createMessageToArrayByAction:ZCTipCellMessageEvaluation type:0 name:@"" face:@"" tips:ZCReceivedMessageUnKonw content:nil]];
        }
    }
    
    ZCPlatformInfo *platinfo = [self getPlatfromInfo];
    platinfo.config = conf;
    [[ZCPlatformTools sharedInstance] savePlatformInfo:platinfo cache:NO];
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(onPageStatusChanged:message:obj:)]){
        [self.delegate onPageStatusChanged:ZCShowStatusMessageChanged message:@"" obj:_listArray];
    }
}


// 清理数据
-(void)clearData{
//    [[ZCIMChat getZCIMChat] setChatPageState:ZCChatPageStateBack];
    if (_animateView) {
        [_animateView stopAnimating];
    }
    
    if (_playModel) {
        _playModel.isPlaying = NO;
    }
    
//    [_listArray removeAllObjects];
//    [_cids removeAllObjects]
    
    if(_tipTimer){
        [_tipTimer invalidate];
    }
    
    if(_delegate){
        _delegate   = nil;
    }
    
    [self clearPropertyData];
    
    // 清理本地存储文件
    dispatch_async(dispatch_queue_create("com.sobot.cache", DISPATCH_QUEUE_SERIAL), ^{
        NSFileManager *_fileManager = [NSFileManager new];
        NSDirectoryEnumerator *fileEnumerator = [_fileManager enumeratorAtPath:VoiceLocalPath];
        
        for (NSString *fileName in fileEnumerator) {
            NSString *filePath = [VoiceLocalPath stringByAppendingPathComponent:fileName];
            // 未过期，添加到排序列表
            if(![ZCUITools videoIsValid:filePath]){
                // 过期，直接删除
                [_fileManager removeItemAtPath:filePath error:nil];
            }
        }
    });
    
//        [ZCIMChat getZCIMChat].delegate   = self;
}


-(void)clearPropertyData{
//    _isSayHello = NO;
//    _isSendToUser = NO;
//    _isSendToRobot = NO;
    allFaceDict  = nil;
    _isOffline = NO;
//    _isShowForm = NO;
    _isShowRobotHello = NO;
    _isOfflineBeBlack = NO;
}

-(void)desctory{
    [self clearData];
        _isSayHello = NO;
        _isSendToUser = NO;
        _isSendToRobot = NO;
        _isShowForm = NO;
    [[ZCPlatformTools sharedInstance] cleanCacheDataByAppkey:[ZCLibClient getZCLibClient].libInitInfo.appKey userId:[ZCLibClient getZCLibClient].libInitInfo.userId];
    
    [ZCLibClient getZCLibClient].libInitInfo.skillSetId = @"";
    [ZCLibClient getZCLibClient].libInitInfo.skillSetName = @"";
    
    onceToken=0;
    _instance = nil;
    
}

-(void)initConfigData:(BOOL)isFrist IsNewChat:(BOOL) isNew{
    // 评价页面是否消失
    _isDismissSheetPage = YES;
    if (isNew) {
        // 重新赋值技能组ID和昵称（初始化传入字段）
        [ZCLibClient getZCLibClient].libInitInfo.skillSetId = zcLibConvertToString([[NSUserDefaults standardUserDefaults] valueForKey:@"UserDefaultGroupID"]);
        [ZCLibClient getZCLibClient].libInitInfo.skillSetName = zcLibConvertToString([[NSUserDefaults standardUserDefaults] valueForKey:@"UserDefaultGroupName"]);
        // 重新设置判定参数
        self.isSendToUser = NO;
        self.isSendToRobot = NO;
        self.isEvaluationService = NO;
        self.isEvaluationRobot = NO;
        self.isShowRobotHello = NO;
        
        [ZCLibClient getZCLibClient].isShowTurnBtn = NO;
    }
    
    [ZCLogUtils logHeader:LogHeader debug:@"初始化方法调用"];
    _isCidLoading = YES;
    self.isDoConnectedUser = NO;
    // 清理参数
//    [[ZCIMChat getZCIMChat] setChatPageState:ZCChatPageStateBack];

    _isSayHello = NO;
    _isSendToUser = NO;
    _isSendToRobot = NO;
    
    if(_tipTimer){
        [_tipTimer invalidate];
    }
 
    allFaceDict  = nil;
    _isOffline = NO;
    _isShowForm = NO;
    _isShowRobotHello = NO;

    
    // 清理本地存储文件
    dispatch_async(dispatch_queue_create("com.sobot.cache", DISPATCH_QUEUE_SERIAL), ^{
        NSFileManager *_fileManager = [NSFileManager new];
        NSDirectoryEnumerator *fileEnumerator = [_fileManager enumeratorAtPath:VoiceLocalPath];
        
        for (NSString *fileName in fileEnumerator) {
            NSString *filePath = [VoiceLocalPath stringByAppendingPathComponent:fileName];
            // 未过期，添加到排序列表
            if(![ZCUITools videoIsValid:filePath]){
                // 过期，直接删除
                [_fileManager removeItemAtPath:filePath error:nil];
            }
        }
    });
    
    
    if(!isFrist){
        // 清理参数
        _isCidLoading = NO;
        [_listArray removeAllObjects];
        if (self.delegate && [self.delegate respondsToSelector:@selector(onPageStatusChanged:message:obj:)]) {
            [self.delegate onPageStatusChanged:ZCSetListTabelRoad message:@"" obj:nil];
        }
    }
    
    if ([self getPlatfromInfo].config.type == 2) {
        self.isSayHello = YES;
    }else{
        self.isSayHello = NO;
    }
    
#pragma mark ---TODO   排队的model的存储
    self.isInitLoading = YES;
    [self getPlatfromInfo].waitintMessage = nil;

    __weak ZCUICore *safeSelf = self;
    [_apiServer initSobotSDK:^(ZCLibConfig *config) {
        
//        if (self.delegate && [self.delegate respondsToSelector:@selector(onPageStatusChanged:message:obj:)]) {
//            [self.delegate onPageStatusChanged:ZCInitStatusConnecting message:@"200" obj:nil];
//        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(showSoketConentStatus:)]) {
            [self.delegate showSoketConentStatus:200];
        }
        [ZCLogUtils logHeader:LogHeader debug:@"%@",config];
        NSString *isblack = @"0";
        self.isOfflineBeBlack = NO;
        if (config.isblack == YES) {
            isblack = @"1";
            self.isOfflineBeBlack = YES;
        }
   
        // 必须设置，不然收不到消息
        [ZCIMChat getZCIMChat].delegate = nil;
        [ZCIMChat getZCIMChat].delegate = safeSelf;
        
        
        [safeSelf configInitView];
        
        // 此处为赋值设备ID 为未读消息数做处理
        [ZCLibClient getZCLibClient].libInitInfo = config.zcinitInfo;
        
        _curCid = config.cid;
        
        if (isFrist) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                // 获取历史记录
                [self getChatMessages];
                // 获取cid列表
                [self getCids];
            });
        }
        
    } error:^(ZCNetWorkCode status) {
  
//        if (self.delegate && [self.delegate respondsToSelector:@selector(onPageStatusChanged:message:obj:)]) {
//            [self.delegate onPageStatusChanged:ZCInitStatusConnecting message:@"2000" obj:nil];
//        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(showSoketConentStatus:)]) {
            [self.delegate showSoketConentStatus:2000];
        }
        if(!isFrist){
            if (self.delegate && [self.delegate respondsToSelector:@selector(onPageStatusChanged:message:obj:)]) {
                [self.delegate onPageStatusChanged:ZCSetKeyBoardStatus message:@"ZCKeyboardStatusNewSession" obj:nil];
            }
            
        }else{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                // TODO   需要处理
                [safeSelf clearData];
            });
        }
        safeSelf.isInitLoading=NO;
    } appIdIncorrect:^(NSString *appId) {
        if(!isFrist){
 
            if (self.delegate && [self.delegate respondsToSelector:@selector(onPageStatusChanged:message:obj:)]) {
                [self.delegate onPageStatusChanged:ZCSetKeyBoardStatus message:@"ZCKeyboardStatusNewSession" obj:nil];
            }
            
        }else{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                // TODO   需要处理
                [safeSelf clearData];
            });
        }
        safeSelf.isInitLoading=NO;
    }];
    
}

-(void)keyboardOnClick:(ZCShowStatus)status{
    if(status == ZCShowStatusSatisfaction){
        // 去评价  非返回的状态触发的
        [self keyboardOnClickSatisfacetion:NO];
    }
    
    if(status == ZCShowStatusRobotStyle){
        [self keyboardOnClickAddRobotHelloWolrd];
    }
}



/**
 *
 *   处理评价的事件
 *   是否是点击返回触发的评价
 **/
-(void)keyboardOnClickSatisfacetion:(BOOL)isBcak{
    BOOL isUser = NO;
    if (self.isSendToUser) {
        isUser = YES;
    }
    
    BOOL isRobot = NO;
    if (self.isSendToRobot) {
        isRobot = YES;
    }
    
    [ZCLogUtils logHeader:LogHeader debug:@"当前发送状态：%d,%d",isUser,isRobot];
    
    //1.只和机器人聊过天 评价机器人
    //2.只和人工聊过天 评价人工
    //3.机器人的评价和人工的评价做区分，互不相干。
    
    // 是否转接过人工  或者当前是否是人工 （人工的评价逻辑） // [[ZCStoreConfiguration getZCParamter:KEY_ZCISOFFLINE] intValue] == 1
    if (self.isOffline || [self getPlatfromInfo].config.isArtificial) {
        // 拉黑不能评价客服添加提示语(只有在评价人工的情景下，并且被拉黑，评价机器人不触发此条件) // [[ZCStoreConfiguration getZCParamter:KEY_ZCISOFFLINEBEBLACK] intValue] == 1
        if ([[self getPlatfromInfo].config isblack]||self.isOfflineBeBlack) {
            [self addTipsListenerMessage:ZCTipCellMessageTemporarilyUnableToEvaluate];
            return;
        }
        
        // 之前评价过人工，提示已评价过。
        if (self.isEvaluationService) {
            [self addTipsListenerMessage:ZCTipCellMessageEvaluationCompleted];
            return;
        }
        
        if (isUser) {
            [self CustomActionSheet:ServerSatisfcationNolType andDoBack:NO isInvitation:1 Rating:5 IsResolved:0];
        }else{
            self.isEvaluationService = NO;
            [self addTipsListenerMessage:ZCTipCellMessageAfterConsultingEvaluation];
        }
        
    }else{
        // 之前评价过机器人，提示已评价。（机器人的评价逻辑）
        if (self.isEvaluationRobot) {
            [self addTipsListenerMessage:ZCTipCellMessageEvaluationCompleted];
            return;
        }
        
        if (isRobot) {
            [self CustomActionSheet:RobotSatisfcationNolType andDoBack:NO isInvitation:1 Rating:5 IsResolved:0];
        }else{
            self.isEvaluationRobot = NO;
            [self addTipsListenerMessage:ZCTipCellMessageAfterConsultingEvaluation];
        }
    }
}

#pragma mark -- 调用评价页面
-(void)CustomActionSheet:(int) sheetType andDoBack:(BOOL) isBack isInvitation:(int) invitationType Rating:(int)rating IsResolved:(int)isResolve{
    if (self.isDismissSheetPage) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(JumpCustomActionSheet:andDoBack:isInvitation:Rating:IsResolved:)]) {
            [self.delegate JumpCustomActionSheet:sheetType andDoBack:isBack isInvitation:invitationType Rating:rating IsResolved:isResolve];
        }
    }
}

#pragma mark -- 评价页面的代理实现


- (void)thankFeedBack:(int)type rating:(float)rating IsResolve:(int)isresolve{

    // 邀请评价结束后替换满意度cell
    ZCLibMessage *temModel=[[ZCLibMessage alloc] init];
    temModel.date         = zcLibDateTransformString(FormateTime, [NSDate date]);
    temModel.cid          = [self getLibConfig].cid;
    temModel.action       = 0;
    temModel.sender       = [self getLibConfig].uid;
    temModel.senderName   = _receivedName;
    temModel.senderFace   = @"";
    temModel.t=[NSString stringWithFormat:@"%ld",(long)[[NSDate date] timeIntervalSince1970]];
    temModel.ts           = zcLibDateTransformString(FormateTime, [NSDate date]);
    temModel.receiver     = [self getLibConfig].companyName;
    temModel.receiverName = [self getLibConfig].uid;
    temModel.offlineType  = @"1";
    temModel.receiverFace = @"";
    temModel.tipStyle = 209;
    temModel.ratingCount = rating;
    temModel.satisfactionCommtType =  isresolve;
    temModel.isQuestionFlag = [NSString stringWithFormat:@"%d",isresolve];
    [self addReceivedNameMessageToList:temModel];

    _isAddServerSatifaction = NO;
}


-(void)dimissCustomActionSheetPage{
    _isDismissSheetPage = YES;
}


// 感谢您的评价
-(void)thankFeedBack{
    

    if([self getLibConfig].isArtificial && self.kitInfo.isCloseAfterEvaluation){
        // 调用离线接口
        //        [[self getZCAPIServer] logOut:[ZCIMChat getZCIMChat].libConfig];
        [_apiServer logOut:[self getLibConfig]];
        
        // 添加离线消息
        [self addTipsListenerMessage:ZCTipCellMessageOverWord];
        
        // 关闭通道
        [[ZCIMChat getZCIMChat] closeConnection];
        
        // 清理页面缓存
        [self clearData];
        
        // 清空标记加载历史记录会再次显示机器人欢迎语
        // 是否转接过人工
//        [ZCStoreConfiguration setZCParamter:KEY_ZCISROBOTHELLO value:@"1"];
//        [ZCStoreConfiguration setZCParamter:KEY_ZCISOFFLINE value:@"1"];
        self.isSayHello = YES;
        self.isOffline = YES;
        if (self.delegate && [self.delegate respondsToSelector:@selector(onPageStatusChanged:message:obj:)]) {
            [self.delegate onPageStatusChanged:ZCSetKeyBoardStatus message:@"ZCKeyboardStatusNewSession" obj:nil];
        }
        
    }
}

// 提交评价
- (void)commitSatisfactionWithIsResolved:(int)isResolved Rating:(int)rating{
    if(isComment){
        return;
    }
    if (isResolved == 2) {
        // 没有选择 按已解决处理
        isResolved = 0;
    }
    //  此处要做是否评价过人工或者是机器人的区分
    if (self.isOffline || [self getLibConfig].isArtificial) {
        // 评价过客服了，下次不能再评价人工了
        self.isEvaluationService = YES;
    }else{
        // 评价过机器人了，下次不能再评价了
        self.isEvaluationRobot = YES;
    }
    NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
    [dict setObject:@"" forKey:@"problem"];
    [dict setObject:[self getLibConfig].cid forKey:@"cid"];
    [dict setObject:[self getLibConfig].uid forKey:@"userId"];
    
    
    [dict setObject:@"1" forKey:@"type"];
    [dict setObject:[NSString stringWithFormat:@"%d",rating] forKey:@"source"];
    [dict setObject:@"" forKey:@"suggest"];
    [dict setObject:[NSString stringWithFormat:@"%d",isResolved] forKey:@"isresolve"];
    // commentType  评价类型 主动评价 1 邀请评价0
    [dict setObject:@"0" forKey:@"commentType"];
    isComment = YES;
    [_apiServer doComment:dict result:^(ZCNetWorkCode code, int status, NSString *msg) {
        isComment = NO;
    }];
    [self thankFeedBack:0 rating:rating IsResolve:1];
    
}


#pragma mark -- 添加提示消息
-(void)addTipsListenerMessage:(int)action{
    [ZCLogUtils logHeader:LogHeader debug:@"========%d ========",action];
    if(action == ZCTipCellMessageUserTipWord || action == ZCTipCellMessageAdminTipWord){
        if ([self getPlatfromInfo].config.isArtificial) {
            // 当前人工客服的昵称(在会话保持的模式下，返回再进入SDK ，昵称变成机器人昵称的问题)
            _receivedName = [self getPlatfromInfo].config.senderName;
        }
        [self createMessageToArrayByAction:action type:0 name:_receivedName face:@"" tips:0 content:@""];
    }else{
        
        // 设置昵称
        if(_delegate && [_delegate respondsToSelector:@selector(setTitleName:)]){
            [_delegate setTitleName:_receivedName];
        }
        // 转人工成功之后清理掉所有的留言入口
        if (_listArray.count>=1) {
            
            if (_listArray !=nil) {
                NSString *indexs = @"";
                for (int i = (int)_listArray.count-1; i>=0; i--) {
                    ZCLibMessage *model = _listArray[i];
                    // 删除上一条留言信息
                    if ([model.sysTips hasPrefix:zcLibConvertToString([self getPlatfromInfo].config.adminNonelineTitle)] && (action == ZCTipCellMessageUserNoAdmin)) {
                        indexs = [indexs stringByAppendingFormat:@",%d",i];
                    }else if([model.sysTips hasPrefix:ZCSTLocalString(@"您已完成评价")] && (action == ZCTipCellMessageEvaluationCompleted)){
                        // 删除上一次商品信息
                        indexs = [indexs stringByAppendingFormat:@",%d",i];
                    }else if ([model.sysTips hasPrefix:ZCSTLocalString(@"咨询后才能评价服务质量")] && (action == ZCTipCellMessageAfterConsultingEvaluation)){
                        indexs = [indexs stringByAppendingFormat:@",%d",i];
                    }else if ([model.sysTips hasPrefix:ZCSTLocalString(@"暂时无法转接人工客服")] && (action == ZCTipCellMessageIsBlock)){
                        indexs = [indexs stringByAppendingFormat:@",%d",i];
                    }else if ([model.richModel.msg isEqual:[self getPlatfromInfo].config.robotHelloWord] && [self getPlatfromInfo].config.type !=2){
                        [ZCStoreConfiguration setZCParamter:KEY_ZCISROBOTHELLO value:@"1"];
                    }else if ([model.sysTips hasPrefix:ZCSTLocalString(@"您好,本次会话已结束")] && (action == ZCTipCellMessageOverWord)){
                        indexs = [indexs stringByAppendingFormat:@",%d",i];
                    }
                }
                if(indexs.length>0){
                    indexs = [indexs substringFromIndex:1];
                    for (NSString *index in [indexs componentsSeparatedByString:@","]) {
                        [_listArray removeObjectAtIndex:[index intValue]];
                    }
                }
            }
        }
        [self createMessageToArrayByAction:action type:2 name:_receivedName face:@"" tips:1 content:@""];
    }
}

/**
 根据初始化结构，设置页面
 
 isStartTipTime 是否启动页面定时器
 */
-(void)configInitView{
    
    ZCLibConfig * config = [self getPlatfromInfo].config;
    if(config.type ==1 || config.type == 3 || (config.type == 4 && ![self getPlatfromInfo].config.isArtificial)){
        _receivedName = config.robotName;
        // 设置昵称
        if (self.delegate && [self.delegate respondsToSelector:@selector(setTitleName:)]) {
            [self.delegate setTitleName:_receivedName];
        }
    }
    
    // 启动计时器
    [self startTipTimer];

    _isInitLoading = NO;
    
    // 设置输入框
    if (self.delegate && [self.delegate respondsToSelector:@selector(onPageStatusChanged:message:obj:)]) {
        [self.delegate onPageStatusChanged:ZCSetKeyBoardStatus message:nil obj:config];
    }
    
    // 设置仅人工，人工不在线，并且是在黑名单中。
    if (config.type == 2  && config.isblack) {
        
        // 手动添加，无需修改业务逻辑。
        [self addTipsListenerMessage:ZCTipCellMessageIsBlock];
        // 设置昵称
        
        if (_delegate && [self.delegate respondsToSelector:@selector(setTitleName:)]) {
            [self.delegate setTitleName:ZCSTLocalString(@"暂无客服在线")];
        }
    }
}

#pragma mark -- 执行发送消息
-(void) sendMessage:(NSString *)text questionId:(NSString*)question type:(ZCMessageType) type duration:(NSString *) time{
    // 发送空的录音样式
    if (type == ZCMessagetypeStartSound) {
        if(recordModel == nil){
            recordModel = [_apiServer  setLocalDataToArr:0 type:2 duration:@"0" style:0 send:NO name:[self getPlatfromInfo].config.zcinitInfo.nickName content:@"" config:[self getPlatfromInfo].config];
            
            recordModel.progress     = 0;
            recordModel.sendStatus   = 0;
            recordModel.senderType   = 0;
            
            NSString *msg = @"";
            // 封装消息数据
            ZCLibRich *richModel=[ZCLibRich new];
            richModel.msg = msg;
            richModel.msgType = 2;
            richModel.duration = @"0";
            recordModel.richModel=richModel;
            [_listArray addObject:recordModel];
            // 回到主线程刷新UI
            dispatch_async(dispatch_get_main_queue(), ^{
                if(self.delegate && [self.delegate respondsToSelector:@selector(onPageStatusChanged:message:obj:)]){
                    [self.delegate onPageStatusChanged:ZCShowStatusMessageChanged message:@"" obj:_listArray];
                }
            });
        }
        return;
    }
    
    if (type == ZCMessagetypeCancelSound) {
        if(recordModel!=nil){
            [_listArray removeObject:recordModel];
            recordModel = nil;
        }
        if(self.delegate && [self.delegate respondsToSelector:@selector(onPageStatusChanged:message:obj:)]){
            [self.delegate onPageStatusChanged:ZCShowStatusMessageChanged message:@"" obj:_listArray];
        }
        return;
    }
    
    if(type == ZCMessageTypeSound){
        if(recordModel!=nil){
            [_listArray removeObject:recordModel];
            recordModel = nil;
        }
    }
    
    
    // 发送完成再计数
    [self cleanUserCount];
    
    if(self.kitInfo.isOpenActiveUser && type == ZCMessageTypeText && ![self getPlatfromInfo].config.isArtificial && [self getPlatfromInfo].config.type!=1){
        if(!zcLibIs_null(self.kitInfo.activeKeywords) && [self.kitInfo.activeKeywords objectForKey:text]){
            
            //        ZCLibMessage *sendModel = nil;
            // action 为0
            [self createMessageToArrayByAction:0 type:0 name:_receivedName face:[self getPlatfromInfo].config.face tips:0 content:text];
            // 刷新页面，在去转人工
            [self turnUserService:nil object:nil];
            return;
        }
    }
    
    /** 正在发送的消息对象，方便更新状态 */
    __block ZCLibMessage    *sendMessage;
    
    __weak ZCUICore *safeVC = self;
    
    [_apiServer sendMessage:text questionId:question msgType:type duration:time config:[self getPlatfromInfo].config robotFlag:[ZCLibClient getZCLibClient].libInitInfo.robotId start:^(ZCLibMessage *message) {
        sendMessage  = message;
        sendMessage.sendStatus=1;
        
        [safeVC.listArray addObject:sendMessage];
        
        if(self.delegate && [self.delegate respondsToSelector:@selector(onPageStatusChanged:message:obj:)]){
            [self.delegate onPageStatusChanged:ZCShowStatusMessageChanged message:@"" obj:safeVC.listArray];
        }
        
    } success:^(ZCLibMessage *message, ZCMessageSendCode sendCode) {
        if([self getPlatfromInfo].config.isArtificial){
            self.isSendToUser = YES;
            self.isSendToRobot = NO;
        }else{
            self.isSendToRobot = YES;
            self.isSendToUser = NO;
        }
        
        if(sendCode==ZC_SENDMessage_New){
            if(message.richModel
               && (message.richModel.answerType==3
                   ||message.richModel.answerType==4)
               && !safeVC.kitInfo.isShowTansfer
               && ![ZCLibClient getZCLibClient].isShowTurnBtn){
                safeVC.unknownWordsCount ++;
                if([safeVC.kitInfo.unWordsCount integerValue]==0) {
                    safeVC.kitInfo.unWordsCount =@"1";
                }
                if (safeVC.unknownWordsCount >= [safeVC.kitInfo.unWordsCount integerValue]) {
                    
                    // 仅机器人的模式不做处理
                    if ([safeVC getPlatfromInfo].config.type != 1) {
                        // 设置键盘的样式 （机器人，转人工按钮显示）
                        if (safeVC.delegate && [safeVC.delegate respondsToSelector:@selector(onPageStatusChanged:message:obj:)]) {
                            [safeVC.delegate onPageStatusChanged:ZCSetKeyBoardStatus message:@"ZCKeyboardStatusRobot" obj:nil];
                        }
                        
                        // 保存在本次有效的会话中显示转人工按钮
                        [ZCLibClient getZCLibClient].isShowTurnBtn = YES;
                    }
                }
                
            }
            
            NSInteger index = [_listArray indexOfObject:sendMessage];
            
            // 如果返回的数据是最后一轮，当前的多轮会话的cell不可点击
            // 记录下标
            if ( [zcLibConvertToString([NSString stringWithFormat:@"%d",message.richModel.answerType]) hasPrefix:@"15"]  && message.richModel.multiModel.endFlag) {
                for (ZCLibMessage *message in _listArray) {
                    if ([zcLibConvertToString([NSString stringWithFormat:@"%d",message.richModel.answerType]) hasPrefix:@"15"] && !message.richModel.multiModel.endFlag && !message.richModel.multiModel.isHistoryMessages ) {
                        message.richModel.multiModel.isHistoryMessages = YES;// 变成不可点击，成为历史
                    }
                }
            }
            
            [_listArray insertObject:message atIndex:index+1];
            
            if(self.delegate && [self.delegate respondsToSelector:@selector(onPageStatusChanged:message:obj:)]){
                [self.delegate onPageStatusChanged:ZCShowStatusMessageChanged message:@"" obj:safeVC.listArray];
            }

        }else if(sendCode==ZC_SENDMessage_Success){
            sendMessage.sendStatus=0;
            sendMessage.richModel.msgtranslation = message.richModel.msgtranslation;
            if(self.delegate && [self.delegate respondsToSelector:@selector(onPageStatusChanged:message:obj:)]){
                [self.delegate onPageStatusChanged:ZCShowStatusMessageChanged message:@"" obj:safeVC.listArray];
            }

        }else {
            sendMessage.sendStatus=2;
            if(self.delegate && [self.delegate respondsToSelector:@selector(onPageStatusChanged:message:obj:)]){
                [self.delegate onPageStatusChanged:ZCShowStatusMessageChanged message:@"" obj:safeVC.listArray];
            }

            if(sendCode == ZC__SENDMessage_FAIL_STATUS){
                /**
                 *   给人工发消息没有成功，说明当前已经离线
                 *   1.回收键盘
                 *   2.添加结束语
                 *   3.添加新会话键盘样式
                 *   4.中断计时
                 *
                 **/
                [self cleanUserCount];
                [self cleanAdminCount];

                if (safeVC.delegate && [safeVC.delegate respondsToSelector:@selector(onPageStatusChanged:message:obj:)]) {
                    [safeVC.delegate onPageStatusChanged:ZCSetKeyBoardStatus message:@"ZCKeyboardStatusNewSession" obj:nil];
                }
                [self addTipsListenerMessage:ZCTipCellMessageOverWord];
            }
        }
    } progress:^(ZCLibMessage *message) {
        if([self getPlatfromInfo].config.isArtificial){
            self.isSendToRobot = NO;
            self.isSendToUser = YES;
        }else{
            self.isSendToRobot = YES;
            self.isSendToUser = NO;
        }
        
        [ZCLogUtils logText:@"上传进度：%f",message.progress];
        sendMessage.progress = message.progress;
        if(self.delegate && [self.delegate respondsToSelector:@selector(onPageStatusChanged:message:obj:)]){
            [self.delegate onPageStatusChanged:ZCShowStatusMessageChanged message:@"" obj:safeVC.listArray];
        }
    } fail:^(ZCLibMessage *message, ZCMessageSendCode errorCode) {
        if([self getPlatfromInfo].config.isArtificial){
            self.isSendToRobot = NO;
            self.isSendToUser = YES;
        }else{
            self.isSendToRobot = YES;
            self.isSendToUser = NO;
        }
        
        sendMessage.sendStatus=2;
        if(self.delegate && [self.delegate respondsToSelector:@selector(onPageStatusChanged:message:obj:)]){
            [self.delegate onPageStatusChanged:ZCShowStatusMessageChanged message:@"" obj:safeVC.listArray];
        }
    }];
}


/**
 *  把本地数据，封装到展示Model上
 *
 *  @param action  类型
 *  @param msgType 数据类型0文本 1图片 2音频 3富文本
 *  @param voiceDuration 声音时长
 *  @param content   消息内容
 *  @param isOpen  1关闭 0开启
 *  @param _config 初始化对象
 *  @return
 */
-(ZCLibMessage *)setLocalDataToArr:(int) action
                              type:(int)msgType
                          duration:(NSString *) voiceDuration
                             style:(NSInteger) style
                              send:(BOOL) isSend
                              name:(NSString *)nickname
                           content:(NSString *)content
                            config:(ZCLibConfig *) _config{
    
    ZCLibMessage *temModel=[[ZCLibMessage alloc] init];
    temModel.date         = zcLibDateTransformString(FormateTime, [NSDate date]);
    //    temModel.contentTemp  = text;
    temModel.senderFace = _config.zcinitInfo.avatarUrl;
    temModel.cid          = _config.cid;
    temModel.action       = 0;
    temModel.sender       = _config.uid;
    if(nickname!=nil && ![@"" isEqual:zcLibConvertToString(nickname)]){
        temModel.senderName   = nickname;
    }else{
        temModel.senderName   = _config.senderName;
    }
    
    temModel.senderFace   = _config.robotLogo;
    temModel.t=[NSString stringWithFormat:@"%ld",(long)[[NSDate date] timeIntervalSince1970]];
    temModel.ts           = zcLibDateTransformString(FormateTime, [NSDate date]);
    temModel.receiver     = _config.cid;
    temModel.receiverName = _config.robotName;
    temModel.offlineType  = @"1";
    temModel.receiverFace = _config.robotLogo;
    temModel.progress     = 0;
    temModel.sendStatus   = 1;
    if(isSend){
        temModel.senderType   = 0;
    }else{
        if(_config.isArtificial){
            // 都是人工客服
            temModel.senderType = 2;
            temModel.senderFace = _config.senderFace;
        }else{
            temModel.senderType = 1;
            temModel.senderName = _config.robotName;
            temModel.senderFace = _config.robotLogo;
        }
    }
    
    NSString *msg = @"";
    
    if (action == ZCTipCellMessageRobotHelloWord) {
        msg = _config.robotHelloWord;
    }else if (action == ZCTipCellMessageUserTipWord){
        msg = _config.userTipWord;
    }else if (action == ZCTipCellMessageAdminTipWord){
        msg = _config.adminTipWord;
    }else if (action == ZCTipCellMessageUserOutWord){
        msg = _config.userOutWord;
    }else if (action == ZCTipCellMessageAdminHelloWord){
        msg = _config.adminHelloWord;
    }else{
        msg = [temModel getTipMsg:action content:content isOpenLeave:_config.msgFlag];
    }
    if(style>0){
        temModel.tipStyle=(int)style;
        temModel.sysTips = msg;
    }else{
        // 人工回复时，等于7是富文本
        if(msgType==7){
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:[msg dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
            ZCLibRich *richModel=[[ZCLibRich alloc] initWithMyDict:@{@"answer":dict} WithSenderType:temModel.senderType IsHistory:NO isHotGuide:NO];
            temModel.richModel=richModel;
        }else{
            // 封装消息数据
            ZCLibRich *richModel=[ZCLibRich new];
            richModel.msg = msg;
            richModel.msgType=msgType;
            richModel.duration=voiceDuration;
            
            temModel.richModel=richModel;
        }
    }
    return temModel;
}


/**
 *
 *  添加机器人欢迎语
 *
 **/
-(void)keyboardOnClickAddRobotHelloWolrd{
    // 添加机器人欢迎语
    ZCLibMessage *msg = [self createMessageToArrayByAction:ZCTipCellMessageRobotHelloWord type:0 name:[self getPlatfromInfo].config.robotName face:[self getPlatfromInfo].config.robotLogo tips:0 content:nil];
    
    // 返回空说明已经显示过了
    if(msg == nil){
        //        NSLog(@"已经显示过了不在显示机器人欢迎语");
        return ;
    }
    
    // 获取机器人欢迎语引导语
    if([self getPlatfromInfo].config.guideFlag == 1){
       
        __weak ZCUICore * safeVC = self;
        [_apiServer getRobotGuide:[self getPlatfromInfo].config robotFlag:[ZCLibClient getZCLibClient].libInitInfo.robotId start:^(ZCLibMessage *message) {
            
        } success:^(ZCLibMessage *message, ZCMessageSendCode sendCode) {
            
            [safeVC.listArray addObject:message];
         
            if(safeVC.delegate && [safeVC.delegate respondsToSelector:@selector(onPageStatusChanged:message:obj:)]){
                [safeVC.delegate onPageStatusChanged:ZCShowStatusMessageChanged message:@"" obj:safeVC.listArray];
            }
            
            // 添加机器人热点引导语
            [safeVC getHotGuideWord];
            
        } fail:^(ZCLibMessage *message, ZCMessageSendCode errorCode) {
            
        }];
    }else{
        if(_delegate && [_delegate respondsToSelector:@selector(onPageStatusChanged:message:obj:)]){
            [_delegate onPageStatusChanged:ZCShowStatusMessageChanged message:@"" obj:_listArray];
        }
    }

}

-(void)getHotGuideWord{
    
    if (![ZCLibClient getZCLibClient].libInitInfo.isEnableHotGuide) {
        return;
    }
    NSMutableDictionary * param = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString * margs = @"";
    // 用户自定义字段 2.2.1版本新增
    @try {
        if ([ZCLibClient getZCLibClient].libInitInfo.hotguideDict != nil && [[ZCLibClient getZCLibClient].libInitInfo.hotguideDict isKindOfClass:[NSDictionary class]]) {
            margs = [ZCLocalStore DataTOjsonString:[ZCLibClient getZCLibClient].libInitInfo.hotguideDict];
            
            [param setObject:zcLibConvertToString(margs) forKey:@"margs"];
        }else{
            [param setObject:@"" forKey:@"margs"];
        }
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    __weak ZCUICore *safeVC = self;
    [_apiServer getHotGuide:[self getPlatfromInfo].config Parms:param start:^(ZCLibMessage *message) {
        
    } success:^(ZCLibMessage *message, ZCMessageSendCode sendCode) {
        [safeVC.listArray addObject:message];
        
        if(safeVC.delegate && [safeVC.delegate respondsToSelector:@selector(onPageStatusChanged:message:obj:)]){
            [safeVC.delegate onPageStatusChanged:ZCShowStatusMessageChanged message:@"" obj:safeVC.listArray];
        }

    } fail:^(ZCLibMessage *message, ZCMessageSendCode errorCode) {
        
    }];
    
}


/**
 *
 *  转人工不成功，添加提示留言消息
 *
 **/
-(void)keyboardOnClickAddLeavemeg{
    // 设置昵称
    _receivedName = [self getPlatfromInfo].config.robotName;
    
    // 暂无客服在线
    [self addTipsListenerMessage:ZCTipCellMessageUserNoAdmin];
    
    // 仅人工，客服不在线直接提示
    if ([self getPlatfromInfo].config.type == 2){
        // 设置昵称
        _receivedName = ZCSTLocalString(@"暂无客服在线");
        if (self.delegate && [self.delegate respondsToSelector:@selector(setTitleName:)]) {
            [self.delegate setTitleName:_receivedName];
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(onPageStatusChanged:message:obj:)]) {
            [self.delegate onPageStatusChanged:ZCSetKeyBoardStatus message:@"ZCKeyboardStatusNewSession" obj:nil];
        }
        
        return;
    }
    
    // 如果没有机器人欢迎语，添加机器人欢迎语
    if ([self getPlatfromInfo].config.type !=2) {
        [self keyboardOnClickAddRobotHelloWolrd];
    }
    
    if ([self getPlatfromInfo].config.type == 4 && ![self getPlatfromInfo].config.isArtificial ) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(onPageStatusChanged:message:obj:)]) {
            [self.delegate onPageStatusChanged:ZCSetKeyBoardStatus message:@"ZCKeyboardStatusRobot" obj:nil];
        }
    }
    
    // 设置昵称
    if (self.delegate && [self.delegate respondsToSelector:@selector(setTitleName:)]) {
        [self.delegate setTitleName:_receivedName];
    }
    
    [self cleanUserCount];
    [self cleanAdminCount];
}

////////////////////////////////////////////////

#pragma mark 定时器相关
-(void)startTipTimer{
    if(_tipTimer){
        [_tipTimer invalidate];
        _tipTimer = nil;
    }
    _tipTimer       = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerCount) userInfo:nil repeats:YES];
    
    // 定时器相关
    lowMinTime = 0;
    //    isAdminTipTime = YES;
    //    isUserTipTime  = NO;
    userTipTime = 0;
    adminTipTime = 0;
}
-(void)cleanAdminCount{
    isUserTipTime  = NO;
    isAdminTipTime = YES;
    adminTipTime   = 0;
    userTipTime    = 0;
}

-(void)cleanUserCount{
    isUserTipTime  = YES;
    isAdminTipTime = NO;
    userTipTime    = 0;
    adminTipTime   = 0;
}

-(void)pauseCount{
    if(_tipTimer){
        if (_tipTimer && ![_tipTimer isValid]) {
            return ;
        }
        [_tipTimer setFireDate:[NSDate distantFuture]];
    }
}

-(void)pauseToStartCount{
    if(_tipTimer){
        if (_tipTimer && ![_tipTimer isValid]) {
            return ;
        }
        [_tipTimer setFireDate:[NSDate date]];
    }
}

-(void)setInputListener:(UITextView *)textView{
    inputTextView = textView;
}


/**
 *  计数，计算提示信息
 */
-(void)timerCount{
    ZCLibConfig *libConfig = [self getLibConfig];
    
    lowMinTime=lowMinTime+1;
    
    // 用户超时，此处不处理了，改由服务器判断
    
    // 用户长时间不说话,人工才添加提示语
    if(!isUserTipTime && libConfig.isArtificial){
        userTipTime=userTipTime+1;
        if(userTipTime>=libConfig.userTipTime*60){
            // 用户超时应答语
            if(_delegate && [_delegate respondsToSelector:@selector(onPageStatusChanged:message:obj:)]){
                [_delegate onPageStatusChanged:ZCShowNSTimerUserTimeOut message:@"" obj:nil];
            }
            userTipTime   = 0;
            isUserTipTime = YES;
        }
    }
    
    // 人工时才提醒，客服不说话
    if(!isAdminTipTime && libConfig.isArtificial){
        adminTipTime=adminTipTime+1;
        if(adminTipTime>libConfig.adminTipTime*60){
            @try {
                if(_delegate && [_delegate respondsToSelector:@selector(onPageStatusChanged:message:obj:)]){
                    [_delegate onPageStatusChanged:ZCShowNSTimerAdminTimeOut message:@"" obj:nil];
                }
            } @catch (NSException *exception) {
                
            } @finally {
                
            }
            
            adminTipTime   = 0;
            isAdminTipTime = YES;
            
        }
    }
    
    // 间隔指定时间，发送正在输入内容，并且是人工客服时
    if(inputTextView && libConfig.isArtificial){
        inputCount = inputCount + 1;
        
        if(inputCount > 3){
            inputCount = 0;
            // 发送正输入
            NSString *text = inputTextView.text;
            if(![text isEqual:lastMessage]){
                lastMessage = text;
                [ZCLogUtils logHeader:LogHeader debug:@"发送正在输入内容...%@",lastMessage];
                if(isSendInput){
                    return;
                }
                isSendInput = YES;
                // 正在输入
                [_apiServer
                 sendInputContent:libConfig
                 content:lastMessage
                 success:^(ZCNetWorkCode sendCode) {
                     isSendInput = NO;
                 } failed:^(NSString *errorMessage, ZCNetWorkCode errorCode) {
                     isSendInput = NO;
                 }];
            }
        }
    }
}


-(NSDictionary *)allExpressionDict{
    if(allFaceDict==nil || allFaceDict.allKeys.count == 0){
        NSArray *faceArr = [ZCUITools allExpressionArray];
        if(faceArr && faceArr.count > 0){
            allFaceDict = [NSMutableDictionary dictionary];
            for (NSDictionary *item in faceArr) {
                [allFaceDict setObject:item[@"VALUE"] forKey:item[@"KEY"]];
            }
        }
    }
    return allFaceDict;
}


@end
