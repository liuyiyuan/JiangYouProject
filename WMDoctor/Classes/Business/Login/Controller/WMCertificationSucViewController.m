//
//  WMCertificationSucViewController.m
//  WMDoctor
//
//  Created by 茭白 on 2017/5/17.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMCertificationSucViewController.h"

@interface WMCertificationSucViewController ()

@end

@implementation WMCertificationSucViewController

- (void)viewDidLoad {
    self.fd_interactivePopDisabled = YES;
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithImage:[UIImage new] style:UIBarButtonItemStylePlain target:self action:nil];
    self.title=@"实名认证";
    self.view.backgroundColor=[UIColor colorWithHexString:@"ffffff"];
    [self setupView];
    // Do any additional setup after loading the view.
}

-(void)setupView{
    //图片
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_duihao"]];
    imageView.frame = CGRectMake(129.0/375*kScreen_width, 94, 30, 30);
    [self.view addSubview:imageView];
    
    //取消
    UILabel *cancelLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageView.frame.origin.x+imageView.width+15, 97, 80, 25)];
    cancelLabel.text = @"提交成功";
    cancelLabel.textColor = [UIColor colorWithHexString:@"#333333"];//colorFromHexRGB:@"#333333"];
    cancelLabel.font = [UIFont systemFontOfSize:18.0];
    [self.view addSubview:cancelLabel];
    
    //详细
    UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, imageView.frame.origin.y+imageView.height+30, kScreen_width-60, 30)];
    detailLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    detailLabel.font = [UIFont systemFontOfSize:14.0];
    detailLabel.numberOfLines = 0;
    detailLabel.text = @"你的认证资料已提交成功，我们将在1-3个工作日内为你审核！请保持手机通畅。";
    CGFloat textHeight = [CommonUtil heightForLabelWithText:detailLabel.text width:detailLabel.width font:[UIFont systemFontOfSize:14.0]];
    detailLabel.frame = CGRectMake(30, imageView.frame.origin.y+imageView.height+30, kScreen_width-60, textHeight+10);
    [self.view addSubview:detailLabel];
    
    //知道按钮
    UIButton *iknowButton = [[UIButton alloc] initWithFrame:CGRectMake(100.0/375*kScreen_width,detailLabel.height+detailLabel.frame.origin.y+30,kScreen_width-100.0/375*kScreen_width*2,40)];
    //[iknowButton wmButtonWithTitle:@"知道了"];
    //[iknowButton wmButtonWithFontSize:18.0];
    [iknowButton setTitle:@"完成" forState:UIControlStateNormal];
    iknowButton.titleLabel.font=[UIFont systemFontOfSize:16.00];
    [iknowButton setBackgroundColor:[UIColor colorWithHexString:@"18a2ff"]];
    [iknowButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    iknowButton.layer.cornerRadius=4;
    iknowButton.layer.masksToBounds=YES;

    [iknowButton addTarget:self action:@selector(iKnowButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:iknowButton];
    
    //联系客服按钮
    UIButton *serviceButton = [[UIButton alloc] initWithFrame:CGRectMake(100.0/375*kScreen_width,iknowButton.frame.origin.y+40+20,iknowButton.width,40)];
    [serviceButton setTitle:@"进入微脉" forState:UIControlStateNormal];
    serviceButton.titleLabel.font=[UIFont systemFontOfSize:16.00];
    [serviceButton setBackgroundColor:[UIColor whiteColor]];
    [serviceButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    serviceButton.layer.borderColor=[[UIColor colorWithHexString:@"dbdbdb"] CGColor];
    serviceButton.layer.borderWidth=1;
    serviceButton.layer.cornerRadius=4;
    serviceButton.layer.masksToBounds=YES;
    [serviceButton addTarget:self action:@selector(serviceButtonAction) forControlEvents:UIControlEventTouchUpInside];
    //[self.view addSubview:serviceButton];
}
- (void)iKnowButtonAction{
    NSLog(@"知道了完善个人信息");
    if (self.isFirstLogin==YES) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kLoginInSuccessNotification
                                                            object:nil
                                                          userInfo:@{@"EnterType":@"CheckEnter"}];
    }
    else{
        NSArray * arr =  self.navigationController.viewControllers;
        UIViewController *viewController=arr[arr.count-3];
        [self.navigationController popToViewController:viewController animated:YES];
    }
   
}

- (void)serviceButtonAction{
    NSLog(@"进入微脉");
    
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
