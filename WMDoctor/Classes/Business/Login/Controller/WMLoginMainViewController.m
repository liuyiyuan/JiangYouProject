//
//  LoginMainViewController.m
//  WMDoctor
//  登陆主界面
//  Created by JacksonMichael on 2016/12/14.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import "WMLoginMainViewController.h"
#import "WMVerifyCodeAPIManager.h"
#import "NSString+Regular.h"
#import "WMLoginParam.h"
#import "AppConfig.h"

@interface WMLoginMainViewController ()<UITextFieldDelegate>
{
    WorkEnvironment _currentEnvir;
}
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIImageView *logoImage;


@end

@implementation WMLoginMainViewController

- (void)viewDidLoad {
    
    self.dismissKeyBoard = YES;
    _currentEnvir = [AppConfig currentEnvir];
    [super viewDidLoad];
    [self setupView];
    
    // Do any additional setup after loading the view.
}

//初始化UI
- (void)setupView{
    
    //输入框下划线
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, _phoneTextField.frame.size.height-1, _phoneTextField.frame.size.width, 1)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"3d94ea"];
    [_phoneTextField addSubview:lineView];
    [_phoneTextField setValue:@"15" forKey:@"limit"];
    _phoneTextField.delegate = self;
    _phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_phoneTextField becomeFirstResponder];
    //一键登录按钮
    _loginBtn.layer.cornerRadius = 5;
    _loginBtn.titleLabel.textColor = [UIColor colorWithWhite:1 alpha:0.4];
    _loginBtn.userInteractionEnabled = NO;
    
    [_phoneTextField addTarget:self action:@selector(phoneTextFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    
    
    
    //切库操作(只在非正式环境启用)
    if (_currentEnvir != WorkInRelease) {
        UITapGestureRecognizer * tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecognizerAction:)];
        self.logoImage.userInteractionEnabled = YES;
        [self.logoImage addGestureRecognizer:tapRecognizer];
    }
    
    
}
- (IBAction)loginBtn:(id)sender {
    
    NSString *phone = [_phoneTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (![phone isMobileNumber]) {

        [WMHUDUntil showMessage:NSLocalizedString(@"kText_errorPhone", nil) toView:self.view];
        return;
    }
    WMVerifyCodeAPIManager *manger = [[WMVerifyCodeAPIManager alloc] init];
    WMLoginParam * param = [[WMLoginParam alloc]init];
    param.phone = phone;
    [manger loadDataWithParams:param.toDictionary withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"responseObject=%@,messge=%@",responseObject,manger.result.message);
        [self performSegueWithIdentifier:@"goVerificationCode" sender:nil];
    } withFailure:^(ResponseResult *errorResult) {
        NSLog(@"error=%@",errorResult);
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
//    [UIApplication sharedApplication].statusBarHidden = YES;
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ((string.length + textField.text.length) >= 15 && ![string isEqualToString:@""]) {
        _loginBtn.userInteractionEnabled = YES;
        _loginBtn.titleLabel.textColor = [UIColor colorWithWhite:1 alpha:1];
    }else{
        _loginBtn.titleLabel.textColor = [UIColor colorWithWhite:1 alpha:0.4];
        _loginBtn.userInteractionEnabled = NO;
    }
    
    
    if ([string isEqualToString:@""] && (textField.text.length == 5 || textField.text.length == 11)) {
        textField.text = [textField.text substringToIndex:textField.text.length -2];
        return  YES;
    }else if([string isEqualToString:@""]){
        return YES;
    }
    
    if (textField.text.length == 3 || textField.text.length == 9) {
        textField.text = [NSString stringWithFormat:@"%@  ",textField.text];
    }
    NSLog(@"range:%lu  -----  string:%@",(unsigned long)range.length,string);
    
    NSLog(@"phone:%@",[textField.text stringByReplacingOccurrencesOfString:@" " withString:@""]);
    
    return YES;
}
- (void)phoneTextFieldChanged:(UITextField*)textField
{
    NSLog(@"564=%@",textField.text);
    if ([textField.text isEqualToString:@""]) {
        _loginBtn.titleLabel.textColor = [UIColor colorWithWhite:1 alpha:0.4];
        _loginBtn.userInteractionEnabled = NO;
    }
}

#pragma -mark Action   切库操作
- (void)tapRecognizerAction:(UIGestureRecognizer *)recognizer
{
    if (_currentEnvir!=0) {
        
        [PopUpUtil alertWithMessage:@"上帝的存在是不言自明的真理无需任何解释" toViewController:self withCompletionHandler:^{
            [self changeAppVersion];
        }];
        
    }
}
//切库操作
- (void)changeAppVersion{
    
    NSMutableArray * unProductEnvirs = [AppConfig httpURLs];
    
    [unProductEnvirs removeObjectAtIndex:0];
    
    NSMutableArray * titleArray = [NSMutableArray array];
    
    for (EnvironmentModel * environment in unProductEnvirs) {
        [titleArray addObject:environment.name];
    }
    
    WorkEnvironment type = _currentEnvir -1;
    
    HZActionSheet * sheet = [[HZActionSheet alloc] initWithTitle:@"恭喜你开启了应用的彩蛋-切换库"
                                                        delegate:self
                                               cancelButtonTitle:@"取消"
                                       destructiveButtonIndexSet:[NSIndexSet indexSetWithIndex:type]
                                               otherButtonTitles:titleArray];
    [sheet showInView:self.view];
}
#pragma -mark HZActionSheetDelegate
- (void)actionSheet:(HZActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    WorkEnvironment type =_currentEnvir -1;
    
    if (buttonIndex==actionSheet.cancelButtonIndex||buttonIndex==type) {
        return;
    }
    [AppConfig saveEnvirWithIndex:buttonIndex+1];
    //保存数据，闪退应用
    [PopUpUtil alertWithMessage:@"上帝的存在是不言自明的真理无需任何解释" toViewController:self withCompletionHandler:nil];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier  isEqual: @"goVerificationCode"]) {
        [segue.destinationViewController setValue:[_phoneTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""] forKey:@"phoneNumber"];
    }
}


@end
