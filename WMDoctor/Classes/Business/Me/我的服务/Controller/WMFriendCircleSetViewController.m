//
//  WMFriednCircleSetViewController.m
//  WMDoctor
//
//  Created by xugq on 2017/12/7.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMFriendCircleSetViewController.h"
#import "WMServiceViewController.h"

@interface WMFriendCircleSetViewController ()

@end

@implementation WMFriendCircleSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"医聊圈设置";
    self.view.backgroundColor = [UIColor colorWithHexString:@"F0F0F0"];
    [self setupView];
}

- (void)setupView{
    UIView *topBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kScreen_width, 212)];
    topBottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topBottomView];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, kScreen_width, 25)];
    title.font = [UIFont systemFontOfSize:18 weight:1.5];
    title.textColor = [UIColor colorWithHexString:@"333333"];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"医聊圈包年服务";
    [topBottomView addSubview:title];
    
    UILabel *content = [[UILabel alloc] initWithFrame:CGRectMake(15, title.bottom + 10, kScreen_width - 30, 60)];
    content.font = [UIFont systemFontOfSize:14];
    content.textColor = [UIColor colorWithHexString:@"999999"];
    content.numberOfLines = 0;
    content.text = @"医聊圈暂不支持医生自己开通。如需开通，请联系当地微脉工作人员或添加微信xxxx，我们会有工作人员联系为您开通该服务。";
    [topBottomView addSubview:content];
    
    UIButton *application = [UIButton buttonWithType:UIButtonTypeCustom];
    application.frame = CGRectMake(15, content.bottom + 20, kScreen_width - 30, 47);
    [application setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [application setTitle:@"申请开通" forState:UIControlStateNormal];
    application.backgroundColor = [UIColor colorWithHexString:@"18A2FF"];
    application.layer.masksToBounds = YES;
    application.layer.cornerRadius = 4;
    [topBottomView addSubview:application];
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, topBottomView.bottom + 10, kScreen_width, 194)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [application addTarget:self action:@selector(applicationClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bottomView];
    
    UILabel *explain = [[UILabel alloc] initWithFrame:CGRectMake(15, 12, kScreen_width - 30, 20)];
    explain.font = [UIFont systemFontOfSize:14];
    explain.textColor = [UIColor colorWithHexString:@"333333"];
    explain.text = @"服务说明";
    [bottomView addSubview:explain];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, explain.bottom + 12, kScreen_width, 1)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"F0F0F0"];
    [bottomView addSubview:lineView];
    
    UILabel *explainContent = [[UILabel alloc] initWithFrame:CGRectMake(15, lineView.bottom + 15, kScreen_width - 30, 50)];
    explainContent.font = [UIFont systemFontOfSize:14];
    explainContent.textColor = [UIColor colorWithHexString:@"333333"];
    explainContent.text = @"1.一个月有效期内，您可通过图文、语音形式无限次咨询医生，医生利用业余时间为您解答；2.医生的回复仅为建议，若病情危急请立即前往医院就诊；3.若医生长时间未回复，您可在我-咨询订单中联系客服退款";
    explainContent.numberOfLines = 0;
    [explainContent sizeToFit];
    [bottomView addSubview:explainContent];
}

//申请开通
- (void)applicationClickAction:(UIButton *)button{
    NSLog(@"申请开通");
    //小脉助手
    WMServiceViewController *serviceVC=[[WMServiceViewController alloc]init];
    serviceVC.conversationType = ConversationType_CUSTOMERSERVICE;
//    serviceVC.targetId = RONGCLOUD_SERVICE_ID;
    serviceVC.title = @"小脉助手";
    serviceVC.backName=@"微脉";
    serviceVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController showViewController:serviceVC sender:nil];
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
