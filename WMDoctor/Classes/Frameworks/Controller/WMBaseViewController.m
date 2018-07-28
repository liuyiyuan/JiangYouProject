//
//  ZCBaseViewController.m
//  SZCEvolution
//
//  Created by choice-ios1 on 16/9/29.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import "WMBaseViewController.h"
#import "WMBackButtonItem.h"
#import <UMMobClick/MobClick.h>


@interface WMBaseViewController ()

@end

@implementation WMBaseViewController

#pragma -mark 系统API

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialization];
    }return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialization];
    }return self;
}
// controller 初始化配置
- (void)initialization
{
    _dismissKeyBoard = NO;
    _backTitle = @"返回";
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    

    [MobClick beginLogPageView:NSLocalizedString([self getCurrentPageTitle], nil)];
    NSLog(@"UmengTongji\n%@",NSLocalizedString([self getCurrentPageTitle], nil));
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSLocalizedString([self getCurrentPageTitle], nil)];
}
- (NSString*)getCurrentPageTitle
{
    NSString * pageTitle = self.pageTitle;
    
    if (!_pageTitle) {
        pageTitle = NSStringFromClass([self class]);
    }
    return pageTitle;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self publicSetting];

    // Do any additional setup after loading the view.
}
- (void)publicSetting
{
    //设置页面单击手势，取消第一响应
    if (_dismissKeyBoard==YES) {
        UITapGestureRecognizer * tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardDismiss)];
        [self.view addGestureRecognizer:tapRecognizer];
    }
    
    WMBackButtonItem * backBarItem = [[WMBackButtonItem alloc] initWithTitle:_backTitle
                                                                      target:self
                                                                      action:@selector(backButtonAction:)];
    NSUInteger index = [self.navigationController.viewControllers indexOfObject:self];
    
    if (index != 0) {
        self.navigationItem.leftBarButtonItem = backBarItem;
    }

}
- (void)backButtonAction:(UIBarButtonItem*)item
{
    Class backController = NSClassFromString(self.backController);
    
    NSArray * reverseArray = [[self.navigationController.viewControllers reverseObjectEnumerator] allObjects];
    
    if (self.backController==nil) {
        
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        
        for (UIViewController * controller in reverseArray) {
            
            if ([controller isKindOfClass:backController]) {
                [self.navigationController popToViewController:controller animated:YES];
                break;
            }
        }
    }
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (void)keyboardDismiss
{
    [self.view endEditing:YES];
}
- (void)dealloc
{
    NSLog(@"%@ dealloc",[self class]);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
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
