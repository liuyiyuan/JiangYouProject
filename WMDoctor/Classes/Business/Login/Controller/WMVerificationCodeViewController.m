//
//  WMVerificationCodeViewController.m
//  WMDoctor
//
//  Created by JacksonMichael on 2016/12/16.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import "WMVerificationCodeViewController.h"
#import <MZTimerLabel.h>
#import "WMLoginAPIManager.h"
#import "LoginModel.h"
#import "WMVerifyCodeAPIManager.h"
#import "WMGetVoiceCodeAPIManger.h"
#import "WMVerifyCodeParam.h"
#import "WMDevice.h"
#import "WMLoginParam.h"
#import "WMPerfectPerInfoViewController.h"
#import "WMTabBarController.h"

@interface WMVerificationCodeViewController ()<MZTimerLabelDelegate>
@property (weak, nonatomic) IBOutlet MZTimerLabel *countDownLabel;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UILabel *reGetLabel;
@property (weak, nonatomic) IBOutlet UILabel *voiceGetLabel;
@property (weak, nonatomic) IBOutlet UILabel *tryLabel;
@property (weak, nonatomic) IBOutlet UILabel *orLabel;
@property (weak, nonatomic) IBOutlet UILabel *waitLabel;

@property (nonatomic, strong) MZTimerLabel *timerLabel;
@end

@implementation WMVerificationCodeViewController

- (void)viewDidLoad {
    self.dismissKeyBoard = YES;
    [super viewDidLoad];
    [self setupView];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupView{
    [self countDown];
    [_codeTextField becomeFirstResponder];
    [_codeTextField addTarget:self action:@selector(codeTextFieldChanged) forControlEvents:UIControlEventEditingChanged];
    [_codeTextField setValue:@"4" forKey:@"limit"];
    
    _reGetLabel.userInteractionEnabled = YES;
    _voiceGetLabel.userInteractionEnabled = YES;
    _tryLabel.userInteractionEnabled = YES;
    _orLabel.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *reGetTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(reGetlabelTouchUpInside)];
    [_reGetLabel addGestureRecognizer:reGetTapGestureRecognizer];
    
    UITapGestureRecognizer *reGetVoiceTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(reGetVoicelabelTouchUpInside)];
    [_voiceGetLabel addGestureRecognizer:reGetVoiceTapGestureRecognizer];
    
}

//重新获取短信验证码
- (void)reGetlabelTouchUpInside{
    
    //请求接口
    WMVerifyCodeAPIManager *manger = [[WMVerifyCodeAPIManager alloc] init];
    WMLoginParam * param = [[WMLoginParam alloc]init];      //通用一个Model这里要注意更改model要考虑，不过一般不会修改此Model
    param.phone = _phoneNumber;
    [manger loadDataWithParams:param.toDictionary withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self getVerificationCodeComplete];
        
    } withFailure:^(ResponseResult *errorResult) {
        NSLog(@"error=%@",errorResult);
    }];
}
- (void)getVerificationCodeComplete
{
    _waitLabel.hidden = NO;
    _countDownLabel.hidden = NO;
    _reGetLabel.hidden = YES;
    _voiceGetLabel.hidden = YES;
    _tryLabel.hidden = YES;
    _orLabel.hidden = YES;
    //重新计时（记得关闭之前的计时）
    [_timerLabel setCountDownTime:30];
    [_timerLabel start];

}
//重新获取语音验证码
- (void)reGetVoicelabelTouchUpInside{
    WMGetVoiceCodeAPIManger *manger = [[WMGetVoiceCodeAPIManger alloc] init];
    WMLoginParam * param = [[WMLoginParam alloc]init];      //通用一个Model这里要注意更改model要考虑，不过一般不会修改此Model
    param.phone = _phoneNumber;
    [manger loadDataWithParams:param.toDictionary withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self getVerificationCodeComplete];
        
    } withFailure:^(ResponseResult *errorResult) {
        NSLog(@"error=%@",errorResult);
    }];
}

//倒计时
- (void)countDown{
    
    __weak typeof(self) weakself = self;
    
    if (!_timerLabel) {
        
        _timerLabel = [[MZTimerLabel alloc]initWithLabel:_countDownLabel andTimerType:MZTimerLabelTypeTimer];
        _timerLabel.delegate = self;
        _timerLabel.timeFormat = @"00:ss";
        _timerLabel.timeLabel.textColor = [UIColor colorWithHexString:@"1a1a1a"];
        [_timerLabel setCountDownTime:30];
        [_timerLabel startWithEndingBlock:^(NSTimeInterval countTime) {
            
            [weakself.timerLabel reset];
            weakself.waitLabel.hidden = YES;
            weakself.countDownLabel.hidden = YES;
            weakself.reGetLabel.hidden = NO;
            weakself.voiceGetLabel.hidden = NO;
            weakself.tryLabel.hidden = NO;
            weakself.orLabel.hidden = NO;
            
        }];
    }
}

#pragma mark - Event Response
- (void)codeTextFieldChanged{
    
    [self makeAttributedStringWithString:_codeTextField.text];
    
    if (_codeTextField.attributedText.length == 4) {
        NSLog(@"弹框或清除");
        [_codeTextField resignFirstResponder];
        
        WMVerifyCodeParam * param = [[WMVerifyCodeParam alloc]init];
        param.phone = _phoneNumber;
        param.verifyCode = _codeTextField.text;
        param.phoneId = [WMDevice currentDevice].uuidString;
        param.phoneModel = [WMDevice currentDevice].deviceModel;
        param.phoneOS = [WMDevice currentDevice].systemVersion;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        param.cid = [defaults objectForKey:@"clientId"];
        
        WMLoginAPIManager *manger = [[WMLoginAPIManager alloc] init];
        [manger loadDataWithParams:param.toDictionary withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
            
            //
            NSLog(@"ddd=%@",manger.result);
            
            NSLog(@"responseObject=%@",responseObject);
            
            LoginModel * login = [[LoginModel alloc] init];
            login.avatar = responseObject[@"avatar"];
            login.name = responseObject[@"name"];
            login.phone = responseObject[@"phone"];
            login.rongToken = responseObject[@"rongToken"];
            login.sessionId = responseObject[@"sessionId"];
            login.sex = responseObject[@"sex"];
            login.status = responseObject[@"treatStatus"];
            login.userCode = responseObject[@"userCode"];
            login.userId = responseObject[@"userId"];
            login.loginFlag = @"1";
            login.certStatus=responseObject[@"certStatus"];
#warning -mark need modificate from API

            //TO DO>>>
            login.userType = [responseObject[@"userType"]  boolValue];
            
            [WMLoginCache setDiskLoginModel:login];
            [WMLoginCache setMemoryLoginModel:login];
            
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
        } withFailure:^(ResponseResult *errorResult) {
            NSLog(@"error=%@",errorResult);
            
            if (errorResult.code==12001||errorResult.code==12000) {
                NSLog(@"user not exit");
                WMPerfectPerInfoViewController *perfectPerInfoVC=[[WMPerfectPerInfoViewController alloc] init];
                perfectPerInfoVC.phoneNumber=self.phoneNumber;
                [self.navigationController pushViewController:perfectPerInfoVC animated:YES];
                
            }
            else{
                UIWindow * window = [[UIApplication sharedApplication] keyWindow];
                [WMHUDUntil showFailWithMessage:errorResult.message toView:window];
            }
        }];
        
//        [self makeAttributedStringWithString:@""];//验证码框清空
//        if ([_from isEqualToString:@"getBackToCode"]) {//去设置注册设置密码
//            [self loadCheckVerificationCodeData];
//        }else if ([_from isEqualToString:@"quickLoginToCode"]){//校验登录保存所需数据
//            [self loadQuickLoginData];
//        }
    }
}

#pragma mark - Other Methods
//替换富文本
- (void)makeAttributedStringWithString:(NSString *)str{
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:str];
    [attrString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Menlo-Regular" size:24] range:NSMakeRange(0, str.length)];
    [attrString addAttribute:NSKernAttributeName value:@55 range:NSMakeRange(0, str.length)];//字符间距 55pt
    
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.firstLineHeadIndent = 64;//首行头缩进
    [attrString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, str.length)];
    _codeTextField.attributedText = attrString;
    
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
