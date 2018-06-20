//
//  WMMyNameStatusCardViewController.m
//  WMDoctor
//
//  Created by JacksonMichael on 2017/5/19.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMMyNameStatusCardViewController.h"
#import "WMCertificationViewController.h"
#import "WMDoctorServiceModel.h"

@interface WMMyNameStatusCardViewController ()
@property (weak, nonatomic) IBOutlet UILabel *statusTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *goBtn;
@property (nonatomic,strong) WMDoctorServiceModel * service_model;  //我的服务
@end

@implementation WMMyNameStatusCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.goBtn.layer.cornerRadius = 4;
    self.goBtn.clipsToBounds = YES;
    
//    [self setupUI];
    // Do any additional setup after loading the view.
}

- (void)setupUI{
    if (self.service_model) {
        self.status = self.service_model.certificationStatus;
    }else{
        self.service_model = [WMDoctorServiceModel new];
    }
    if ([self.status isEqualToString:@"1"]) {  //等待认证
        self.statusTitleLabel.text = @"您的实名认证正在审核中···";
        self.goBtn.hidden = YES;
    }else{//未认证或认证失败
        self.statusTitleLabel.text = @"实名认证后，可获得微脉医生专属二维码名片";
        self.goBtn.hidden = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)goAuthentication:(id)sender {
    WMCertificationViewController * goVC = [WMCertificationViewController new];
    goVC.isFirstLogin = false;
    goVC.service_model = self.service_model;
    [self.navigationController pushViewController:goVC animated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupUI];
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
