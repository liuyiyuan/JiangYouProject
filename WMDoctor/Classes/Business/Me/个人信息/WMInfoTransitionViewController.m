//
//  WMInfoTransitionViewController.m
//  WMDoctor
//
//  Created by JacksonMichael on 2017/5/24.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMInfoTransitionViewController.h"
#import "WMCertificationViewController.h"

@interface WMInfoTransitionViewController ()
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UILabel *twoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *goBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeightConstraint;

@end

@implementation WMInfoTransitionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([self.save_model.certificationStatus isEqualToString:@"1"] || [self.save_model.certificationStatus isEqualToString:@"2"]) {
        [self.navigationController popViewControllerAnimated:NO];
    }
    [self setupUI];
    
}

- (void)setupUI{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    self.goBtn.layer.cornerRadius = 4;
    self.goBtn.clipsToBounds = YES;
    self.view.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    self.title = self.typeStr;
    if ([self.typeStr isEqualToString:@"擅长"]) {  //等待认证
        self.topLabel.text = @"实名认证后，你可以编辑自己的擅长疾病";
        _imageHeightConstraint.constant = 350;
    }else{//未认证或认证失败
        self.topLabel.text = @"实名认证后，你可以编辑自己的简介";
        _imageHeightConstraint.constant = 383;
    }
    
    self.twoLabel.text = [NSString stringWithFormat:@"%@内容将展示在你的个人主页中",self.typeStr];
    
    self.imageView.image = [UIImage imageNamed:([self.typeStr isEqualToString:@"擅长"])?@"pic_shanchang":@"pic_jianjie"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)goBtn:(id)sender {
    WMCertificationViewController * goVC = [WMCertificationViewController new];
    goVC.isFirstLogin = false;
    goVC.save_model = self.save_model;
    [self.navigationController pushViewController:goVC animated:YES];
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
