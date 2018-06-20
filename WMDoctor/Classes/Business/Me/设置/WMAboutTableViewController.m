//
//  WMAboutTableViewController.m
//  WMDoctor
//  关于页面
//  Created by JacksonMichael on 2016/12/23.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import "WMAboutTableViewController.h"
#import "AppConfig.h"
#import "CommonUtil.h"
#import <HZActionSheet.h>
#import "WMDevice.h"
#import "PopUpUtil.h"

@interface WMAboutTableViewController ()<HZActionSheetDelegate>
{
    WorkEnvironment _currentEnvir;
}
@end

@implementation WMAboutTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _currentEnvir = [AppConfig currentEnvir];
    
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    //NSLog(@"infodic = %@",infoDic);
    NSString * displayName = [infoDic objectForKey:@"CFBundleDisplayName"];
    NSString * appVersion = [[WMDevice currentDevice] appVersion];
    //NSString * typeName = nil;
    
    EnvironmentModel *envirModel = [AppConfig httpURLs][_currentEnvir];
    
    _versionLabel.text = [NSString stringWithFormat:@"%@ V%@ %@",displayName,appVersion,envirModel.name];
    
    UITapGestureRecognizer * tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecognizerAction:)];
    _versionLabel.userInteractionEnabled = YES;
    [_versionLabel addGestureRecognizer:tapRecognizer];
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, self.tableView.frame.size.height)];
    imageView.image = [UIImage imageNamed:@"bg_mine_about"];
    self.tableView.backgroundView = imageView;
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma -mark Action
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"indexPath.row==%ld",(long)indexPath.row);
    if (indexPath.row == 0) {
        
        //WMRegistrationAgreementWebViewController * webVC = [[WMRegistrationAgreementWebViewController alloc]init];
        WMBaseWKWebController * webVC = [[WMBaseWKWebController alloc] init];
        webVC.urlString = H5_URL_REGISTRATION;
        //前往用户协议界面
        webVC.pageTitle = @"用户协议";
        [self.navigationController pushViewController:webVC animated:YES];
        
    }else if(indexPath.row == 1){
        //给我们评分
        NSString *str = [NSString stringWithFormat:APPSTORE_WMDOCTOR_URL];
        NSLog(@"str=%@",str);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        
    }
    
}

@end
