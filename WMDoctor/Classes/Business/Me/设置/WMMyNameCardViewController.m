//
//  WMMyNameCardViewController.m
//  WMDoctor
//  我的名片
//  Created by JacksonMichael on 2016/12/30.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import "WMMyNameCardViewController.h"
#import "WMGetCardInfoAPIManager.h"
#import "WMCardInfoModel.h"
#import <UShareUI/UShareUI.h>
#import <QuartzCore/QuartzCore.h>
#import "AppConfig.h"
#import "WMCardPopupView.h"

@interface WMMyNameCardViewController ()<UMSocialShareMenuViewDelegate>
{
    UIImage * _shareImage;   //全局分享图片
    WMCardInfoModel * _cardInfo;    //医生信息model
    WorkEnvironment _currentEnvir;  //接口库版本
}
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *organizationLabel;
@property (weak, nonatomic) IBOutlet UILabel *keshiLabel;
@property (weak, nonatomic) IBOutlet UILabel *hospitalLabel;
@property (weak, nonatomic) IBOutlet UIImageView *qrcodeImageView;
@property (weak, nonatomic) IBOutlet UIView *nameCardView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHWConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageWHConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLenth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeight;


@end

@implementation WMMyNameCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupData];
    [self setupView];
    
    
    BOOL flag = [[NSUserDefaults standardUserDefaults] objectForKey:@"coming"];
    if (!flag) {
        [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:@"coming"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        WMCardPopupView *shopView = [[[NSBundle mainBundle] loadNibNamed:@"WMCardPopupView" owner:nil options:nil] firstObject];
        
        shopView.frame = CGRectMake(0, 0, kScreen_width, kScreen_height);
        
        [self.view addSubview:shopView];
        
        
    }
    
    
    
    // Do any additional setup after loading the view.
}


- (void)setupData{
    _cardInfo = [[WMCardInfoModel alloc]init];
    WMGetCardInfoAPIManager * manager = [[WMGetCardInfoAPIManager alloc]init];
    [manager loadDataWithParams:nil withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"response = %@",responseObject);
        WMCardInfoBaseModel * infoModel = [[WMCardInfoBaseModel alloc]initWithDictionary:responseObject error:nil];
        _cardInfo = (WMCardInfoModel *)infoModel.cardInfo;
        [self setViewValue:_cardInfo];
        
    } withFailure:^(ResponseResult *errorResult) {
        
    }];
}

- (void)setupView{
    
    
    
    _currentEnvir = [AppConfig currentEnvir];   //获取当前运行环境
    self.nameCardView.layer.cornerRadius = 5;
    self.nameCardView.layer.shadowColor=[UIColor colorWithHexString:@"999999"].CGColor;
    self.nameCardView.layer.shadowOffset=CGSizeMake(5, 5);
    self.nameCardView.layer.shadowOpacity=0.5;
    self.nameCardView.layer.shadowRadius=2.5;
    
    
    self.headImageView.layer.cornerRadius = 50;
//    self.headImageView.backgroundColor = [UIColor colorWithHexString:@"a7a7a7"];
    self.headImageView.layer.masksToBounds = YES;
    
    if (kScreen_width != 375) { //屏幕适配
        _imageHWConstraint.constant = 190 + (kScreen_width - 375);
        _imageWHConstraint.constant = 190 + (kScreen_width - 375);
    }
    
    if(kScreen_width < 321){
        _topLenth.constant = 10;
        _viewHeight.constant = 500;
    }
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.nameCardView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:-80]];

    
    
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_UnKnown)]];
    
    [UMSocialUIManager addCustomPlatformWithoutFilted:UMSocialPlatformType_UserDefine_Begin+1 withPlatformIcon:[UIImage imageNamed:@"umsocial_wechat"] withPlatformName:@"微信"];
    [UMSocialUIManager addCustomPlatformWithoutFilted:UMSocialPlatformType_UserDefine_Begin+2 withPlatformIcon:[UIImage imageNamed:@"umsocial_wechat_timeline"] withPlatformName:@"微信朋友圈"];
    [UMSocialUIManager addCustomPlatformWithoutFilted:UMSocialPlatformType_UserDefine_Begin+3 withPlatformIcon:[UIImage imageNamed:@"umsocial_qzone"] withPlatformName:@"QQ空间"];
    
    //设置分享面板的显示和隐藏的代理回调
    [UMSocialUIManager setShareMenuViewDelegate:self];
    
    [UMSocialShareUIConfig shareInstance].sharePageGroupViewConfig.sharePageGroupViewPostionType = UMSocialSharePageGroupViewPositionType_Bottom;
    [UMSocialShareUIConfig shareInstance].sharePageScrollViewConfig.shareScrollViewPageItemStyleType = UMSocialPlatformItemViewBackgroudType_None;
    
    //右上分享
    UIBarButtonItem * rightBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ic_top_share"] style:UIBarButtonItemStyleDone target:self action:@selector(openSharePad)];
    rightBtn.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
}


/**
 弹出分享面板
 */
- (void)openSharePad{
    [self screenShotAction];        //准备截图分享图片
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
//        [self shareImageToPlatformType:typeTemp];     //改为网页分享    1月20日
        
        // 网页分享
        [self shareWebPageToPlatformType:typeTemp];
    }];
}

-(void)screenShotAction
{
    UIGraphicsBeginImageContext(self.view.bounds.size);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    _shareImage= UIGraphicsGetImageFromCurrentImageContext();
    
}


//网页分享
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
//    //创建UIimage转NSData
//    UIImage * image = [UIImage imageNamed:@"ShareIcon"];
//    NSData *imageData = UIImagePNGRepresentation(image);
    
    //创建网页内容对象  (正式环境中imageUrl不管用)
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:[NSString stringWithFormat:@"%@医生的二维码名片",_cardInfo.doctorName] descr:[NSString stringWithFormat:@"您好，我是%@医生，为了方便联系，请去\"微脉\"关注我",_cardInfo.doctorName] thumImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_cardInfo.photo]]]];
    //设置网页地址    暂时只给了正式库地址与预发布库地址
    shareObject.webpageUrl = (_currentEnvir == WorkInRelease)?[NSString stringWithFormat:@"http://h5.myweimai.com/wemay_ys/static/share/qrcode.html?key=%@",_cardInfo.workerId]:[NSString stringWithFormat:@"http://pre.myweimai.com/h5page/wemay_ys/static/share/qrcode.html?key=%@",_cardInfo.workerId];
    
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

//分享图片
- (void)shareImageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建图片内容对象
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    //如果有缩略图，则设置缩略图本地
//    shareObject.thumbImage = [UIImage imageNamed:@"AppIcon"];
    
    [shareObject setShareImage:_shareImage];
    
    // 设置Pinterest参数
    if (platformType == UMSocialPlatformType_Pinterest) {
        [self setPinterstInfo:messageObject];
    }
    
    // 设置Kakao参数
    if (platformType == UMSocialPlatformType_KakaoTalk) {
        messageObject.moreInfo = @{@"permission" : @1}; // @1 = KOStoryPermissionPublic
    }
    
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

- (void)setPinterstInfo:(UMSocialMessageObject *)messageObj
{
    messageObj.moreInfo = @{@"source_url": @"http://www.myweimai.com",
                            @"app_name": @"微脉医生端",
                            @"suggested_board_name": @"UShareProduce",
                            @"description": @"欢迎您使用微脉医生端"};
}

/**
 设置View的值

 @param model 医生信息Model
 */
- (void)setViewValue:(WMCardInfoModel *)model{
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:[UIImage imageNamed:@"ic_head_doc"]];
    self.nameLabel.text = model.doctorName;
    self.organizationLabel.text = model.title;
    self.keshiLabel.text = model.keshiName;
    if (stringIsEmpty(model.title)) {    //如果没有职称调整他的位置
        self.labelConstraint.constant = 0;
    }
    self.hospitalLabel.text = model.organization;      //此处命名有问题，或缺少字段
    model.qrcode = [NSString stringWithFormat:@"%@",model.qrcode];
    [self.qrcodeImageView sd_setImageWithURL:[NSURL URLWithString:model.qrcode] placeholderImage:nil];
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
