//
//  ZCUICore.h
//  SobotKit
//
//  Created by zhangxy on 2018/1/29.
//  Copyright © 2018年 zhichi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZCKitInfo.h"
#import "ZCLibInitInfo.h"
#import "ZCButton.h"
#import "ZCUIKeyboard.h"
#import "ZCLibConfig.h"
#import "ZCUIAskTableController.h"
#import "ZCUILeaveMessageController.h"
#import "ZCChatView.h"
typedef NS_ENUM(NSInteger,ZCInitStatus) {
    ZCInitStatusLoading           = 1,  // 正在调用接口初始化
    ZCInitStatusLoadSuc           = 2,  // 初始化完成
    ZCInitStatusFail              = 3,  // 初始化失败
};

typedef NS_ENUM(NSInteger,ZCShowStatus) {
    ZCShowStatusWaiting          = 1,  // 排队
    ZCShowStatusUnRead           = 2,  // 有未读消息
    ZCShowStatusAddMessage       = 3,  // 新增了一条消息
    ZCShowStatusChangedTitle     = 4,  // 更新标题,如果为空就显示原始文案
    ZCShowStatusRobotStyle       = 5,  // 机器人模式
    ZCShowStatusUserStyle        = 6,  // 人工模式
    ZCShowStatusReConnected      = 7,  // 重新接入  新会话
    ZCShowStatusMessageChanged   = 8,  // 消息列表更新
    ZCInitStatusConnecting       = 9,  // 链接中
    ZCInitStatusConnectSuc       = 10,  // 链接成功
    ZCInitStatusConnectFail      = 11,  // 链接失败
    ZCInitStatusOpenNewWindow    = 12,  // 打开新窗口
    ZCShowStatusSatisfaction     = 13,  // 点击新会话键盘 中的满意度按钮 去评价
    ZCShowStatusLeaveMsgPage     = 14,  // 点击新会话键盘 中的留言按钮 去留言
    ZCInitStatusCompleteNoMore   = 15,  // 获取消息完成,并且没有更多数据
    ZCInitStatusStartMessages    = 16,  // 开始获取历史消息
    ZCInitStatusCloseSkillSet    = 17,  // 关闭技能组
    ZCShowStatusConnectingUser   = 18,  // 开始转人工
    ZCShowStatusConnectFinished  = 20,  // 转人工完成,(不保证转成功)
    
    
    /** 用户长时间不说话提醒 */
    ZCShowNSTimerUserTimeOut     = 21,
    
    /** 客服长时间不说话提醒 */
    ZCShowNSTimerAdminTimeOut    = 22,
    
    /** 添加评价页面 */
    ZCShowCustomActionSheet      = 23,
    
    /** 设置键盘样式 */
    ZCSetKeyBoardStatus          = 24,
    
    /**  刷新 listTabel*/
    ZCSetListTabelRoad           = 25,
    
    ZCShowStatusGoBack           = 26,// 返回到启动页面结束会话

};

/**
 *  ExitType  ENUM
 */
typedef NS_ENUM(NSInteger,LeaveExitType) {
    /** 直接退出SDK */
    LeaveExitTypeISCOLSE         = 1,
    /** 不直接退出SDK*/
    LeaveExitTypeISNOCOLSE       = 2,
    /** 仅人工模式 点击技能组上的留言按钮后,（返回上一页面 提交退出SDK）*/
    LeaveExitTypeISBACKANDUPDATE = 3,
    /** 机器人优先，点击技能组的留言按钮后，（返回技能组 提交和机器人会话）*/
    LeaveExitTypeISROBOT         = 4,
    /** 人工优先，点击技能组的留言按钮后，（返回技能组 提交机器人会话）*/
    LeaveExitTypeISUSER          = 5,
};


typedef NS_ENUM(NSInteger,ZCPagesType) {
    ZC_LeaveMsgPage = 1,
    ZC_AskTabelPage = 2,
};

@protocol ZCUICoreDelegate <NSObject>

@optional
-(void)onPageStatusChanged:(ZCShowStatus )status message:(NSString *) message obj:(id) object;


/**
 *  设置聊天页面的title
 */
-(void)setTitleName:(NSString *)titleName;


/**
 *   聊天页面头部显示 连接中。。。
 **/
-(void)showSoketConentStatus:(ZCConnectStatusCode)statusCode;


/**
 *
 *  跳转到 留言和询前表单页面
 *
 **/
-(void)jumpNewPageVC:(ZCPagesType)type IsExist:(LeaveExitType) isExist  isShowToat:(BOOL) isShow  tipMsg:(NSString *)msg  Dict:(NSDictionary*)dict;


/**
 *
 *  跳转到评价页面 当前类中不能持有 chatView ,chatView 需要服从 ZCUICore的代理
 *
 **/
-(void)JumpCustomActionSheet:(int) sheetType andDoBack:(BOOL) isBack isInvitation:(int) invitationType Rating:(int)rating IsResolved:(int)isResolve;

@end

typedef void(^initResultBlock)(ZCInitStatus code,NSMutableArray *arr,NSString *result);

/**
 UI 相关逻辑处理类
 如：
    判断技能组
    判断是否发送消息
    判断是否显示训前表单
    转人工流程
 */
@interface ZCUICore : NSObject

@property(nonatomic,strong) id<ZCUICoreDelegate> delegate;

@property(nonatomic,strong) initResultBlock ResultBlock;

@property(nonatomic,strong) ZCKitInfo     *kitInfo;

@property(nonatomic,assign) BOOL isShowForm;// 是否直接去转人工，不在查询询前表单的接口

/** 记录对接客服ID 之后掉接口返回6 再去转人工 */
@property (nonatomic,assign) BOOL  isDoConnectedUser;

@property (nonatomic,strong) ZCChatView * chatView; // 用于评价页面添加

@property(nonatomic,assign) BOOL  isDismissSheetPage; // 评价页面是否消失

@property(nonatomic,strong) NSString   *receivedName; // 存储当前页面的title

// 评价完成之后是否要添加满意度cell(刷新客服主动邀请的cell)
@property (nonatomic,assign)  BOOL            isAddServerSatifaction;

@property(nonatomic,strong) NSMutableArray *listArray;

@property(nonatomic,strong) NSMutableArray *cids;// cid 列表

// 播放时动画展示View
@property (nonatomic,strong) UIImageView    *animateView;

// 播放临时model，用于停止播放状态改变
@property (nonatomic,strong) ZCLibMessage    *playModel;

// 记录中间变量
@property(nonatomic,assign) BOOL isSayHello;
@property(nonatomic,assign) BOOL isOffline;
@property(nonatomic,assign) BOOL isShowRobotHello; // 是否添加机器人欢迎语
@property (nonatomic,assign) BOOL isEvaluationService; // 是否评价过人工
@property (nonatomic,assign) BOOL isEvaluationRobot; // 是否评价过机器人
@property (nonatomic,assign) BOOL isOfflineBeBlack; // 是否是拉黑
@property(nonatomic,assign) BOOL isSendToUser;  // 给客服发送过消息
@property(nonatomic,assign) BOOL isSendToRobot; // 给机器人发送过消息
/** 是否正在初始化，网络变化时使用 */
@property (nonatomic,assign)  BOOL             isInitLoading;

@property(nonatomic,strong) ZCLibMessage *lineModel;

@property (nonatomic,assign) BOOL isUpFrame;// 是否重新刷新列表frame和键盘的frame

+(ZCUICore *)getUICore;

-(ZCLibConfig *) getLibConfig;

/**
 判断初始化接口
 
 @param info 当前初始化页面
 */
-(void)openSDKWith:(ZCLibInitInfo *) info uiInfo:(ZCKitInfo *) kitInfo Delegate:(id<ZCUICoreDelegate>)delegate blcok:(initResultBlock ) resultBlock ;


/**
 获取当前聊天记录

 @param appkey 那个appkey的聊天记录
 */
-(void)getChatMessages;


/**
 检查并执行转人工操作

 @return
 */
-(void)checkUserServiceWithObject:(id)obj;

/**
 转人工客户
 code :0 转接成功，1排队，2显示技能组
 arr  :技能组列表
 result:排队描述
 */
-(void)turnUserService:(void(^)(int code,NSMutableArray *arr,NSString *result)) ResultBlock object:(id)obj;


/**
 隐藏技能组

 @return
 */
-(void)dismissSkillSetView;

/**
 *
 *   聊天Value 加载数据
 *   isNew 点击新会话
 **/
-(void)initConfigData:(BOOL)isFrist IsNewChat:(BOOL) isNew;



/**
 键盘页面点击事件处理

 @param status
 */
-(void)keyboardOnClick:(ZCShowStatus ) status;


/**
 *
 *  添加提示类的消息
 *
 **/
-(void)addTipsListenerMessage:(int)action;



/**
 获取当前会话数据

 @return 会话列表
 */
-(NSMutableArray *) chatMessages;


/**
 *
 *  执行发送消息
 *
 **/
-(void) sendMessage:(NSString *)text questionId:(NSString*)question type:(ZCMessageType) type duration:(NSString *) time;




/**
 发送正在输入文本

 @param textView 文本框
 */
-(void)setInputListener:(UITextView *)textView;

/**
 退出聊天界面
 */
-(void)clearData;



/**
 销毁所有数据
 */
-(void)desctory;



-(NSDictionary *)allExpressionDict;


/**
 执行转人工操作
 */
-(void)doConnectUserService;


/**
 *
 *  执行评价逻辑
 *
 **/
-(void)keyboardOnClickSatisfacetion:(BOOL)isBcak;


/**
 *
 *  添加机器人欢迎语
 *
 **/
-(void)keyboardOnClickAddRobotHelloWolrd;


/**
 *
 *   评价页面的代理方法
 *
 **/
- (void)thankFeedBack:(int)type rating:(float)rating IsResolve:(int)isresolve;


/**
 *
 *   调用评价页面
 *
 **/
-(void)CustomActionSheet:(int) sheetType andDoBack:(BOOL) isBack isInvitation:(int) invitationType Rating:(int)rating IsResolved:(int)isResolve;

/**
 *
 *  提交评价
 *
 **/
- (void)commitSatisfactionWithIsResolved:(int)isResolved Rating:(int)rating;

// 感谢您的评价
-(void)thankFeedBack;

/**
 *
 *  清除用户计数
 *
 **/
-(void)cleanUserCount;

/**
 *
 *  清除客服计数
 *
 **/
-(void)cleanAdminCount;

@end
