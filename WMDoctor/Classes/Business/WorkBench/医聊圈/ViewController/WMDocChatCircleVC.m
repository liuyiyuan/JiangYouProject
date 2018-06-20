//
//  WMDocChatCircleVC.m
//  WMDoctor
//
//  Created by xugq on 2018/1/31.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "WMDocChatCircleVC.h"

#import "WMRCDataManager.h"
#import "WMRCChatListCell.h"
#import "WMNoCounselingView.h"
#import "WMRCChatListSayHelloCell.h"
#import "WMMyServiceSetViewController.h"

@interface WMDocChatCircleVC ()

@property(nonatomic, strong)WMNoCounselingView *noCounselingView;

@end

@implementation WMDocChatCircleVC

#pragma mark--初始化
- (instancetype)init{
    self = [super init];
    if (self) {
        [self setDisplayConversationTypes:@[@(ConversationType_GROUP)]];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self =[super initWithCoder:aDecoder];
    if (self) {
        [self setDisplayConversationTypes:@[@(ConversationType_GROUP)]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"医聊圈";
    self.conversationListTableView.backgroundColor=[UIColor colorWithHexString:@"f4f4f4"];
    UIImage *image = [[UIImage imageNamed:@"bt_backarrow"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(navLeftBtnClick)];
    //初始会话类型
    [self setDisplayConversationTypes:@[@(ConversationType_GROUP)]];
    [self navRightBtn];
    [self initNoDataView];
}

- (void)navLeftBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)navRightBtn{
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 70, 30);
    if ([self.openService integerValue] == 1) {
        [rightBtn setTitle:@"服务设置" forState:UIControlStateNormal];
    } else{
        [rightBtn setTitle:@"开启服务" forState:UIControlStateNormal];
    }
    LoginModel *loginModel = [WMLoginCache getMemoryLoginModel];
    if (loginModel.userType) {
        rightBtn.hidden = YES;
    }
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(navRightBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
}

//服务设置
- (void)navRightBtnClick{
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
    WMMyServiceSetViewController * doctorVC = [storyboard instantiateViewControllerWithIdentifier:@"WMMyServiceSetViewController"];
    doctorVC.hidesBottomBarWhenPushed = YES;
    doctorVC.backTitle = @"";
    doctorVC.inquiryType = @"4";
    [self.navigationController pushViewController:doctorVC animated:YES];
}

- (void)initNoDataView{
    CGRect rect = CGRectMake(0, 64, kScreen_width, kScreen_height);
    self.noCounselingView = [[WMNoCounselingView alloc] initWithFrame:rect];
    [self.noCounselingView.makeMoneyBtn setTitle:@"查看医聊圈操作指南" forState:UIControlStateNormal];
    self.emptyConversationView = self.noCounselingView;
}

#pragma mark-- 空白页面
- (void)showEmptyConversationView{
    self.emptyConversationView = self.noCounselingView;
    [self.view addSubview:self.emptyConversationView];
}

//签到方法重写 签到不在这里
- (void)DaySign{
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
