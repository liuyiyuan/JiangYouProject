//
//  WMLaunchAdvertViewController.m
//  WMDoctor
//
//  Created by JacksonMichael on 2016/12/26.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import "WMLaunchAdvertViewController.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
#import "WMLoginCheckAPIManager.h"

@interface WMLaunchAdvertViewController ()
{
    NSTimer * _timer;
}
@end

@implementation WMLaunchAdvertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImage * defaultImageUnder = [UIImage imageNamed:@"bg_ios"];
    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreen_width, kScreen_height)];
    imageView1.image = defaultImageUnder;
    
    
    NSString *imageName = @"iphone4";
    if (kScreen_height <500) {
        imageName = @"iphone4";
    }else if (kScreen_height <600){
        imageName = @"iphone5";
    }else if (kScreen_height <700){
        imageName = @"iphone6";
    }else{
        imageName = @"iphone6+";
    }
    
    UIImage * defaultImageAbove = [UIImage imageNamed:imageName];
    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreen_width, kScreen_height)];
    imageView2.image = defaultImageAbove;
    
    
    [self.view addSubview:imageView2];
    [self.view addSubview:imageView1];
    
    
    
    
    NSString * launchImageUrl = [[NSUserDefaults standardUserDefaults]
                                 objectForKey:@"LaunchImage"];
    if (launchImageUrl) {
        
        UIImage * currentImage = [[SDImageCache sharedImageCache]
                                  imageFromDiskCacheForKey:launchImageUrl];
        
        if (currentImage) {
            imageView1.image = currentImage;
        }else{
            imageView1.image = defaultImageUnder;
            [self downloadAndSaveImageWithURLString:launchImageUrl];
        }
        
    }else{
        imageView1.image = defaultImageUnder;
    }
    
    //目前就一套广告页
//    imageView2.hidden = YES;
    
    //计时1秒后显示loading界面
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(loginYanZheng) userInfo:nil repeats:NO];
    
    
    // Do any additional setup after loading the view.
}

- (void)loginYanZheng
{
    //根据userinfo去处理新手引导页面
    
    
    
    
    //登陆成功
    void (^loginInBlock)() = ^{
        
        
        LoginModel * model = [WMLoginCache getDiskLoginModel];
        RCUserInfo *_currentUserInfo =[[RCUserInfo alloc] initWithUserId:[NSString stringWithFormat:@"%@",model.userCode] name:model.name portrait:model.avatar];
        

        //头像跟新后，在融云的服务器跟新头像
        [RCIM sharedRCIM].currentUserInfo=_currentUserInfo;
        [[RCIM sharedRCIM]
         refreshUserInfoCache:_currentUserInfo
         withUserId:[NSString stringWithFormat:@"%@",model.userCode]];
        

        [[NSNotificationCenter defaultCenter] postNotificationName:kLoginInSuccessNotification
                                                            object:nil
                                                          userInfo:@{@"EnterType":@"CheckEnter"}];
    };
    
    //登陆失效，重新登陆<清楚对应数据>
    void (^loginOutBlock)() = ^{
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kLoginOutSuccessNotification
                                                            object:nil
                                                          userInfo:@{}];
    };
    
    
    LoginModel * model = [WMLoginCache getDiskLoginModel];
    if (!model) {   //如果没有LoginModel，直接跳入登陆页面
        loginOutBlock();
    }else if(stringIsEmpty(model.loginFlag) || [model.loginFlag isEqualToString:@"0"]){ //如果有LoginModel，但是loginFlag为空或者为0，还是跳入登陆页面
        loginOutBlock();
    }else{      //如果LoginModel一切正常，调用登陆验证
        WMLoginCheckAPIManager * manager = [[WMLoginCheckAPIManager alloc] init];
        [manager loadDataWithParams:nil withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
            
            NSLog(@"haha = %@",responseObject);
            if ([responseObject[@"online"] boolValue]==YES) {
                //校验成功
                loginInBlock();
            }else{
                //校验失败
                loginOutBlock();
            }
            
        } withFailure:^(ResponseResult *errorResult) {
            
            loginOutBlock();
            
            NSLog(@"errorResult=%@",errorResult);
        }];
    }
    
    
    
    
    
    [_timer invalidate];
    _timer = nil;
    
}


////是否登录过<特指登陆过并且没有注销>
//- (BOOL)isLogin
//{
//    BOOL islogin = NO;
//    
//    LoginModel * model = [WMCache getDiskLoginModel];
//    if (model) {
//        [WMCache setMemoryLoginModel:model];
//    }
//    
//    if (!stringIsEmpty(model.GUID)&&![model.GUID  isEqualToString:@"0"]) {
//        islogin = YES;
//    }
//    return islogin;
//}

- (void)downloadAndSaveImageWithURLString:(NSString *)urlString
{
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:urlString] options:SDWebImageDownloaderLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
    } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        NSLog(@"image:%@,data:%@,error:%@,finished:%d",image,data,error,finished);
        if (image) {
            [[SDImageCache sharedImageCache] storeImage:image forKey:urlString toDisk:YES];
        }
    }];
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
