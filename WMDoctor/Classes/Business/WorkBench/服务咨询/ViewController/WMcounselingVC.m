//
//  WMcounselingVC.m
//  WMDoctor
//
//  Created by xugq on 2018/1/29.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "WMcounselingVC.h"

#import "WMNoCounselingView.h"
#import "WMMyServiceSetViewController.h"

@interface WMcounselingVC ()

@property(nonatomic, strong)WMNoCounselingView *noCounselingView;

@end

@implementation WMcounselingVC

#pragma mark--初始化
- (instancetype)init{
    self = [super init];
    if (self) {
        [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE)]];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self =[super initWithCoder:aDecoder];
    if (self) {
        [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE)]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"咨询服务";
    self.conversationListTableView.backgroundColor=[UIColor colorWithHexString:@"f4f4f4"];
    UIImage *image = [[UIImage imageNamed:@"bt_backarrow"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(navLeftBtnClick)];
    //初始会话类型
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE)]];
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
    doctorVC.inquiryType = @"1";
    [self.navigationController pushViewController:doctorVC animated:YES];
}

- (void)initNoDataView{
    CGRect rect = CGRectMake(0, 64, kScreen_width, kScreen_height);
    self.noCounselingView = [[WMNoCounselingView alloc] initWithFrame:rect];
    [self.noCounselingView.makeMoneyBtn setTitle:@"如何通过咨询服务赚钱" forState:UIControlStateNormal];
    self.emptyConversationView = self.noCounselingView;
}

#pragma mark-- 空白页面
- (void)showEmptyConversationView{
    self.emptyConversationView = self.noCounselingView;
    [self.view addSubview:self.emptyConversationView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.conversationListDataSource.count == 1) {
        RCConversationModel *model = self.conversationListDataSource[0];
        if ([model.targetId isEqualToString:@"system000004"]) {
            [self.conversationListDataSource removeObjectAtIndex:0];
            [self.conversationListTableView reloadData];
            return 0;
        }
    }
    return self.conversationListDataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.conversationListDataSource.count&&indexPath.row < self.conversationListDataSource.count) {
        RCConversationModel *model = self.conversationListDataSource[indexPath.row];
        if ([model.targetId isEqualToString:@"system000004"]) {
            [self.conversationListDataSource removeObjectAtIndex:indexPath.row];
            
            if (self.conversationListDataSource.count == 0) {
                [self showEmptyConversationView];
            }
            if (self.awokeView) {
                self.awokeView.hidden = YES;
                self.awokeView.topView.hidden = YES;
                [[UIApplication sharedApplication].keyWindow willRemoveSubview:self.awokeView];
            }
            [self.conversationListTableView reloadData];
            return 80.f;
        } else{
            return 80.f;
        }
    } else{
        return 80.f;
    }
}

//签到方法重写 签到不在这里
- (void)DaySign{
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
