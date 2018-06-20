//
//  Macro.h
//  WMDoctor
//
//  Created by choice-ios1 on 16/12/15.
//  Copyright © 2016年 Choice. All rights reserved.
//

#ifndef Macro_h
#define Macro_h

//公用通知类
/********************************************************************/
//登陆成功通知
#define kLoginInSuccessNotification   @"kLoginInSuccessNotification"
//注销登陆通知
#define kLoginOutSuccessNotification  @"kLoginOutSuccessNotification"
//接收到结束会话的通知
#define kRongCloudFinishConversationNotification @"kRongCloudFinishConversationNotification"

//接收到认证消息的通知
#define kRongCloudAuthenticationMessageNotification @"kRongCloudAuthenticationMessageNotification"



//接收到结束会话的通知
#define kRongCloudLoginInSuccessNotification @"kRongCloudLoginInSuccessNotification"

//公用userDefaults key
/*******************************************************************/
#define kUPGRADETIMESTAMPKEY @"upgradechecktimestamp"
#define kUser_LaunchImage    @"LaunchImage"



//公用变量 OR 常量
/********************************************************************/
#define kScreen_height [[UIScreen mainScreen] bounds].size.height
#define kScreen_width [[UIScreen mainScreen] bounds].size.width


#define SafeAreaTopHeight (kScreen_height == 812.0 ? 88 : 64)
#define SafeAreaTopStateHeight (kScreen_height == 812.0 ? 0 : -20)
//一页显示多少行数据
#define kPAGEROW             @"10"



//公用Func
/********************************************************************/

#define IOS9ORLATER   [[[UIDevice currentDevice] systemVersion] floatValue] >=9.0
#define IOS10ORLATER   [[[UIDevice currentDevice] systemVersion] floatValue] >=10.0

//其他...
/********************************************************************/

//状态栏高度
#define kSTATUSHEIGHT [[UIApplication sharedApplication] statusBarFrame].size.height
//导航栏高度
#define kNAVHEIGHT    44
//状态栏+导航栏高度（iPhone X为88，其他为64）
#define kSTATUSNAVHEIGHT (kSTATUSHEIGHT+kNAVHEIGHT)

#define kTABBARHEIGHT    ([[UIApplication sharedApplication] statusBarFrame].size.height>20?83:49)//适配iPhone x 底栏高度

// 底部宏
#define kSAFEAREABOTTOMHEIGHT (kSTATUSHEIGHT>20?34:0)

// 底部
#define kDevice_Is_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

//融云环境配置，融云客服的Id<测试>
#define RONGCLOUNDAPP_KEY    ISRELEASE?@"kj7swf8o7t7k2":@"qd46yzrf474qf"
#define RONGCLOUDAPP_Secret  ISRELEASE?@"ljRayMjxIiOw":@"sHaF4AHhnRXmg"

#define RONGCLOUD_SERVICE_ID ISRELEASE?@"KEFU146105467085923":@"KEFU145990985629096"

//QQ APPKEY
#define QQ_APPID @"1105862931"

//微信 APPID
#define WX_APPID @"wx61e543271f37b78c"

//微信 AppSecret
#define WX_AppSecret @"bee9a4f4caf766376ec0926b477128c7"

/***********************************************************/
//帮助页面H5 url地址
#define H5_URL_HELPPAGE @"https://pre.myweimai.com/h5page/wemay/doctor/faq/index.html"

//用户协议页面H5 url地址
#define H5_URL_REGISTRATION @"https://m.myweimai.com/yisheng/doctor_agreement.html"

//分享给朋友页面H5 url地址
#define H5_URL_SHAREPAGE @"https://pre.myweimai.com/h5page/wemay/doctor/index.html"

#define APPSTORE_WMDOCTOR_URL @"itms-apps://itunes.apple.com/app/id1192661974"

//我的钱包正式环境链接
#define H5_URL_MYWALLET_FORMAL @"https://www.weimaipay.com/mobile/wallet/doctorindex.htm"

//我的钱包非正式环境链接
#define H5_URL_MYWALLET_TEST @"http://test.weimaipay.com:7080/mobile/wallet/doctorindex.htm"

//我的钱包预发环境链接
#define H5_URL_MYWALLET_PRE @"http://pre.weimaipay.com:7070/mobile/wallet/doctorindex.htm"

//我的钱包明细正式环境链接
#define H5_URL_MYWALLETDETAIL_FORMAL @"https://www.weimaipay.com/mobile/bill/balanceList.htm"

//我的钱包明细非正式环境链接
#define H5_URL_MYWALLETDETAIL_TEST @"http://test.weimaipay.com:7080/mobile/bill/balanceList.htm"

//我的钱包明细预发环境链接
#define H5_URL_MYWALLETDETAIL_PRE @"http://pre.weimaipay.com:7070/mobile/bill/balanceList.htm"

//新手指导非正式环境链接
#define H5_URL_NEWGUIDE_TEST @"http://dev.m.myweimai.com/topic/new_person_guide.html"//@"http://60.191.3.210:8094/wemay/doctorSider/guide/index.html"

//新手指导正式环境链接
#define H5_URL_NEWGUIDE_FORMAL @"https://m.myweimai.com/topic/new_person_guide.html"//@"http://h5.myweimai.com/doctorSider/guide/index.html"

//分享给朋友网址链接     HTTP警告      正式
#define H5_URL_SHAREFRIEND @"https://m.myweimai.com/yisheng/doctor_invite_doctor.html"

//分享有礼网址链接      测试
#define H5_URL_SHAREFRIEND_TEST @"http://dev.m.myweimai.com/yisheng/doctor_invite_doctor.html"

//分享有礼网址链接      预发
#define H5_URL_SHAREFRIEND_PRE @"http://pre.m.myweimai.com/yisheng/doctor_invite_doctor.html"

//咨询赚钱网址链接  正式
#define H5_URL_COUNSELINGMAKEMONEY_FORMAL @"https://h5.myweimai.com//article/index_ys.html?aid=930700000047754777&from=singlemessage&isappinstalled=0"

//医聊圈操作指南网址链接 正式
#define H5_URL_DOCTORFINGERPOST @"https://h5.myweimai.com//article/index_ys.html?aid=912200000278547877"

//资讯详情网址链接 测试
#define H5_URL_INFORMATIONDETAIL_TEST @"http://test.m.myweimai.com/yisheng/doctor_news_record.html"

//资讯详情网址链接 预发
#define H5_URL_INFORMATIONDETAIL_PRE @"https://dev.m.myweimai.com/yisheng/doctor_news_record.html"

//资讯详情网址链接 线上
#define H5_URL_INFORMATIONDETAIL_FORMAL @"https://m.myweimai.com/yisheng/doctor_news_record.html"

//积分兑换网址    正式
#define H5_URL_BEANEXCHANGE_FORMAL @"https://m.myweimai.com/yisheng/exchange_detail.html"

//积分兑换网址    测试
#define H5_URL_BEANEXCHANGE_TEST @"http://test.m.myweimai.com/yisheng/exchange_detail.html"

//积分兑换网址    预发
#define H5_URL_BEANEXCHANGE_PRE @"https://dev.m.myweimai.com/yisheng/exchange_detail.html"

//微豆说明网址链接      正式
#define H5_URL_BEANEXPLAIN @"https://m.myweimai.com/yisheng/exchange_info.html"

//微豆说明网址链接      预发
#define H5_URL_BEANEXPLAIN_PRE @"https://dev.m.myweimai.com/yisheng/exchange_info.html"

//微豆说明网址链接      测试
#define H5_URL_BEANEXPLAIN_Test @"http://test.m.myweimai.com/yisheng/exchange_info.html"



//小脉助手的头像
#define WM_SERVICEHRADER_URL  @"https://weimai-yunyin.oss-cn-hangzhou.aliyuncs.com/weimaiyiliaopic/2017/04/25/2416c6f0-3d0d-497c-9041-6395d59943b3.png"

//小脉助手的头像
#define WM_LISTDEFAULT_URL  @"https://weimai-app.oss-cn-hangzhou.aliyuncs.com/yishengpic/touxiang/400wtf.png"


//胎心监护图标头像
#define WM_TAIXINHRADER_URL @"https://weimai-yunyin.oss-cn-hangzhou.aliyuncs.com/weimaiyiliaopic/2017/07/05/01553bab-d0a4-4198-8cfc-8bd10b8df6be.jpg"

//一问医答图标头像
#define WM_YIWENYIDAHRADER_URL @"https://weimai-yunyin.oss-cn-hangzhou.aliyuncs.com/weimaiyiliaopic/2017/11/29/c33c3d23-49ec-45a2-970a-a78ec9ff388e.png"

//胎心历史报告正式环境链接
#define TX_LISHI_URL_FORMAL @"http://m.myweimai.com/hosp/taixinjianhu.html"

//胎心历史报告预发环境链接
#define TX_LISHI_URL_PRE @"http://pre.m.myweimai.com/hosp/taixinjianhu.html"

//胎心历史报告测试环境
#define TX_LISHI_URL_TEST @"http://dev.m.myweimai.com/hosp/taixinjianhu.html"

#endif /* Macro_h */


//是否为正式库的环境
#if DEBUG

#define ISRELEASE ([AppConfig currentEnvir]==0||[AppConfig currentEnvir]==6)

#elif PRERELEASE
#define ISRELEASE ([AppConfig currentEnvir]==0)

#else
#define ISRELEASE ([AppConfig currentEnvir]==0)

#endif


/**
 *  log日志是否输出
 *
 *  @param ...  __OPTIMIZE__ 这个宏，来标识是否是release的。
 *
 */

#ifndef __OPTIMIZE__

#define NSLog(...) NSLog(__VA_ARGS__)

#else

#define NSLog(...) {}

#endif
