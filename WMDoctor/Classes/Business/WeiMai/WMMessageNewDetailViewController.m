//
//  WMMessageNewDetailViewController.m
//  WMDoctor
//
//  Created by 茭白 on 2017/1/12.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMMessageNewDetailViewController.h"
#import <UShareUI/UShareUI.h>

@interface WMMessageNewDetailViewController ()<UMSocialShareMenuViewDelegate>

@end

@implementation WMMessageNewDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webTitle=self.shareTitle;//和用户端保持一致
    // Do any additional setup after loading the view.
    
    //右上分享
    if (![self.hiddenRightBarBtn isEqualToString:@"1"]) {
        UIBarButtonItem * rightBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ic_top_share"] style:UIBarButtonItemStyleDone target:self action:@selector(BtnClick)];
        rightBtn.tintColor = [UIColor whiteColor];
        self.navigationItem.rightBarButtonItem = rightBtn;
    }
    
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_UnKnown)]];
    
    [UMSocialUIManager addCustomPlatformWithoutFilted:UMSocialPlatformType_UserDefine_Begin+1 withPlatformIcon:[UIImage imageNamed:@"umsocial_wechat"] withPlatformName:@"微信"];
    [UMSocialUIManager addCustomPlatformWithoutFilted:UMSocialPlatformType_UserDefine_Begin+2 withPlatformIcon:[UIImage imageNamed:@"umsocial_wechat_timeline"] withPlatformName:@"微信朋友圈"];
    [UMSocialUIManager addCustomPlatformWithoutFilted:UMSocialPlatformType_UserDefine_Begin+3 withPlatformIcon:[UIImage imageNamed:@"umsocial_qzone"] withPlatformName:@"QQ空间"];

    //设置分享面板的显示和隐藏的代理回调
    [UMSocialUIManager setShareMenuViewDelegate:self];
    [UMSocialShareUIConfig shareInstance].sharePageScrollViewConfig.shareScrollViewPageMaxColumnCountForPortraitAndBottom = 3;
    [UMSocialShareUIConfig shareInstance].sharePageGroupViewConfig.sharePageGroupViewPostionType = UMSocialSharePageGroupViewPositionType_Bottom;
    [UMSocialShareUIConfig shareInstance].sharePageScrollViewConfig.shareScrollViewPageItemStyleType = UMSocialPlatformItemViewBackgroudType_None;
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
    if (!stringIsEmpty(self.sharePictureUrl)) {
        imageData=[NSData dataWithContentsOfURL:[NSURL URLWithString:self.sharePictureUrl]];

    }
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.shareTitle descr:self.shareDetail thumImage:imageData];
    //设置网页地址
    shareObject.webpageUrl = self.shareUrl;
    
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
        //        [self alertWithError:error];
    }];
}


- (void)runShareWithType:(UMSocialPlatformType)type
{
    //    UMShareTypeViewController *VC = [[UMShareTypeViewController alloc] initWithType:type];
    //    [self.navigationController pushViewController:VC animated:YES];
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
