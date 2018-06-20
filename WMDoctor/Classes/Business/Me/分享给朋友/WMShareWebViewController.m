//
//  WMShareWebViewController.m
//  WMDoctor
//  分享给朋友
//  Created by JacksonMichael on 2017/1/9.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMShareWebViewController.h"
#import <UShareUI/UShareUI.h>
#import <UMSocialCore/UMSocialCore.h>

@interface WMShareWebViewController ()<UMSocialShareMenuViewDelegate>
{
    LoginModel * _loginModel;
    NSString * _urlStr;
}


@end

@implementation WMShareWebViewController

- (void)viewDidLoad {
    self.webTitle = @"邀请有礼";
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
    self.webView.frame = CGRectMake(0, 0, kScreen_width, kScreen_height-70);
    _loginModel = [WMLoginCache getMemoryLoginModel];
}

- (void)setupView{
    UIView * theView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreen_height-70, kScreen_width, 70)];
    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(50, 0, kScreen_width-100, 50)];
    button.titleLabel.textColor = [UIColor whiteColor];
    button.layer.cornerRadius = 5;
    button.backgroundColor = [UIColor colorWithHexString:@"4296e7"];
    [button setTitle:@"邀请好友加入微脉医生 >" forState:UIControlStateNormal];
    [button addTarget:self
                          action:@selector(BtnClick)
                forControlEvents:UIControlEventTouchUpInside];
    [theView addSubview:button];
//    [self.view addSubview:theView];       //改为医生分享医生后按钮由H5提供
    
    //右上分享          //医生分享医生版本内容中去掉
//    UIBarButtonItem * rightBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ic_top_share"] style:UIBarButtonItemStyleDone target:self action:@selector(BtnClick)];
//    rightBtn.tintColor = [UIColor whiteColor];
//    self.navigationItem.rightBarButtonItem = rightBtn;
    
//    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),
//                                               @(UMSocialPlatformType_WechatTimeLine),
////                                               @(UMSocialPlatformType_QQ),
//                                               @(UMSocialPlatformType_Qzone),
//                                               @(UMSocialPlatformType_Sms),
//                                               @(UMSocialPlatformType_Email)
//                                               ]];
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_UnKnown)]];
    
    [UMSocialUIManager addCustomPlatformWithoutFilted:UMSocialPlatformType_UserDefine_Begin+1 withPlatformIcon:[UIImage imageNamed:@"umsocial_wechat"] withPlatformName:@"微信"];
    [UMSocialUIManager addCustomPlatformWithoutFilted:UMSocialPlatformType_UserDefine_Begin+2 withPlatformIcon:[UIImage imageNamed:@"umsocial_wechat_timeline"] withPlatformName:@"微信朋友圈"];
    [UMSocialUIManager addCustomPlatformWithoutFilted:UMSocialPlatformType_UserDefine_Begin+3 withPlatformIcon:[UIImage imageNamed:@"umsocial_qzone"] withPlatformName:@"QQ空间"];
//
//    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_UserDefine_Begin+1),
//                                               @(UMSocialPlatformType_UserDefine_Begin+2),
//                                               @(UMSocialPlatformType_UserDefine_Begin+3)
//                                               ]];
    
    //设置分享面板的显示和隐藏的代理回调
    [UMSocialUIManager setShareMenuViewDelegate:self];
    [UMSocialShareUIConfig shareInstance].sharePageScrollViewConfig.shareScrollViewPageMaxColumnCountForPortraitAndBottom = 3;
    
    //    [UMSocialUIManager addCustomPlatformWithoutFilted:UMSocialPlatformType_UserDefine_Begin+2
    //                                     withPlatformIcon:[UIImage imageNamed:@"icon_circle"]
    //                                     withPlatformName:@"演示icon"];
    
    [UMSocialShareUIConfig shareInstance].sharePageGroupViewConfig.sharePageGroupViewPostionType = UMSocialSharePageGroupViewPositionType_Bottom;
    [UMSocialShareUIConfig shareInstance].sharePageScrollViewConfig.shareScrollViewPageItemStyleType = UMSocialPlatformItemViewBackgroudType_None;
    

    __weak typeof(self) weakself = self;
    [self.bridge registerHandler:@"SendInvitation" handler:^(id data, WVJBResponseCallback responseCallback) {
//        NSLog(@"%@", responseData);
        NSDictionary * urldata = (NSDictionary *)data;
        _urlStr = urldata[@"url"];
        
        [weakself BtnClick];
    }];

}


- (void)BtnClick{
    
    
    //显示分享面板
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        int typeTemp = 0;
        if (platformType == UMSocialPlatformType_UserDefine_Begin+1) {      //微信聊天
            typeTemp = UMSocialPlatformType_WechatSession;
        }else if(platformType == UMSocialPlatformType_UserDefine_Begin+2){      //微信朋友圈
            typeTemp = UMSocialPlatformType_WechatTimeLine;
        }else{      //QQ空间
            typeTemp = UMSocialPlatformType_Qzone;
        }
        
        //判断是否安装平台
        if(![[UMSocialManager defaultManager] isInstall:typeTemp]){
            [WMHUDUntil showMessageToWindow:@"您没有安装此平台"];
            return;
        }
        
        // 根据获取的platformType确定所选平台进行下一步操作
        [self shareWebPageToPlatformType:typeTemp];
    }];
}

//网页分享
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建UIimage转NSData
    UIImage * image = [UIImage imageNamed:@"ShareIcon"];
    NSData *imageData = UIImagePNGRepresentation(image);
    
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:NSLocalizedString(@"kText_me_shareTitle", nil) descr:NSLocalizedString(@"kText_me_shareContent", nil) thumImage:imageData];
    
    NSString * typeStr;
    
    if (platformType == UMSocialPlatformType_WechatSession) {
        typeStr = @"2";
    }else if(platformType == UMSocialPlatformType_WechatTimeLine){
        typeStr = @"5";
    }else{
        typeStr = @"6";
    }
    
    //设置网页地址
    shareObject.webpageUrl = [NSString stringWithFormat:@"%@?invitetype=%@&weimaihao=%@#isshared",_urlStr,typeStr,_loginModel.userId];
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
        
    }];
}



#pragma mark - UMSocialShareMenuViewDelegate
- (void)UMSocialShareMenuViewDidAppear
{
    NSLog(@"UMSocialShareMenuViewDidAppear");
}
- (void)UMSocialShareMenuViewDidDisappear
{
    NSLog(@"UMSocialShareMenuViewDidDisappear");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
