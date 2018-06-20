//
//  WMQuestionsSettingViewController.m
//  WMDoctor
//
//  Created by xugq on 2017/12/21.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMQuestionsSettingViewController.h"

@interface WMQuestionsSettingViewController ()

@property(nonatomic, strong)UISwitch *mySwitch;

@end

@implementation WMQuestionsSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
}

- (void)setupView{
    self.title = @"消息提醒";
    self.view.backgroundColor = [UIColor colorWithHexString:@"F4F4F4"];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kScreen_width, 50)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 50)];
    title.font = [UIFont systemFontOfSize:16];
    title.textColor = [UIColor colorWithHexString:@"333333"];
    title.text = @"新消息推送";
    [bottomView addSubview:title];
    
    self.mySwitch = [[UISwitch alloc] initWithFrame:CGRectMake(kScreen_width - 15 - 51, 9, 51, 31)];
    [self setSwitchState];
    [self.mySwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:self.mySwitch];
    
    UILabel *awoke = [[UILabel alloc] initWithFrame:CGRectMake(15, 75, kScreen_width - 30, 36)];
    awoke.font = [UIFont systemFontOfSize:13];
    awoke.textColor = [UIColor colorWithHexString:@"999999"];
    awoke.text = @"开启消息推送，有新的一问医答订单发布，将第一时间通知到您，大大提高您抢单几率";
    awoke.numberOfLines = 0;
    [self.view addSubview:awoke];
}

- (void)setSwitchState{
    LoginModel * loginModel = [WMLoginCache getMemoryLoginModel];
    NSString *key = [NSString stringWithFormat:@"Shield_%@", loginModel.phone];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:key] isEqualToString:@"YES"]) {
        self.mySwitch.on = NO;
    } else{
        self.mySwitch.on = YES;
    }
}

//开关点击
- (void)switchAction:(UISwitch *)mySwitch{
    LoginModel * loginModel = [WMLoginCache getMemoryLoginModel];
    NSString *key = [NSString stringWithFormat:@"Shield_%@", loginModel.phone];
    BOOL Shield = YES;
    if ([mySwitch isOn] == NO) {
        Shield = YES;
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:key];
    } else{
        Shield = NO;
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:key];
    }
    
    //屏蔽与接收消息
    [[RCIMClient sharedRCIMClient] setConversationNotificationStatus:ConversationType_PRIVATE
                                                            targetId:@"system000004"
                                                           isBlocked:Shield
                                                             success:^(RCConversationNotificationStatus nStatus) {
                                                                 NSLog(@"设置成功");
                                                             } error:^(RCErrorCode status) {
                                                                 NSLog(@"屏蔽一问医答失败");
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
