//
//  ZCBaseTableViewController.m
//  SZCEvolution
//
//  Created by choice-ios1 on 16/9/29.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import "WMBaseTableViewController.h"
#import "WMBackButtonItem.h"
#import <UMMobClick/MobClick.h>

CGFloat const sectionDefaultHeight = 34.f;


@interface WMBaseTableViewController ()

@end

@implementation WMBaseTableViewController

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
    [MobClick beginLogPageView:NSLocalizedString(NSStringFromClass([self class]), nil)];
    NSLog(@"UmengTongji\n%@",NSLocalizedString(NSStringFromClass([self class]), nil));
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSLocalizedString(NSStringFromClass([self class]), nil)];
    
    //放这里可以
    NSIndexPath * indexPath = [self.tableView indexPathForSelectedRow];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self publicSetting];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (void)publicSetting
{
    
    self.clearsSelectionOnViewWillAppear = NO;
    if (!self.tableView.tableFooterView) {
        self.tableView.tableFooterView = [[UIView alloc] init];//不显示空的tableviewcell
    }
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
- (void)keyboardDismiss
{
    [self.view endEditing:YES];
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
    NSLog(@"%@ dealloc",[self class]);
}
#pragma mark - Table view data source
/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 0;
}
*/

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
