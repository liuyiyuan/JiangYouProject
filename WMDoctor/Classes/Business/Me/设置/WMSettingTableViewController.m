//
//  WMSettingTableViewController.m
//  WMDoctor
//  我的设置
//  Created by JacksonMichael on 2016/12/23.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import "WMSettingTableViewController.h"
#import "WMAboutTableViewController.h"
#import "WMLoginOutAPIManager.h"
#import "AppConfig.h"

@interface WMSettingTableViewController ()

@end

@implementation WMSettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([AppConfig currentEnvir] != 0) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"H5Test" style:UIBarButtonItemStylePlain target:self action:@selector(h5RightAction)];
    }
    
}
- (void)h5RightAction {
    WMBaseWKWebController * webVC = [[WMBaseWKWebController alloc] init];
    webVC.urlString = @"http://dev1.m.myweimai.com/temps/doctor_sdk_test.html";
    webVC.pageTitle = @"H5Test";
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source



//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
//    return 2;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
//    return 0;
//}

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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.000001f;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc]init];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"indexPath.row==%ld",(long)indexPath.row);
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {       //前往关于页面
            UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
            WMAboutTableViewController * aboutVC = [storyboard instantiateViewControllerWithIdentifier:@"WMAboutTableViewController"];
            
            [self.navigationController pushViewController:aboutVC animated:YES];
        }else if(indexPath.row == 1){       //前往帮助与反馈界面            
            
            WMBaseWKWebController * webVC = [[WMBaseWKWebController alloc] init];
            webVC.urlString = H5_URL_HELPPAGE;
            webVC.pageTitle = @"帮助与反馈";
            [self.navigationController pushViewController:webVC animated:YES];
        }else if (indexPath.row == 2){
        }
    }else if(indexPath.section == 1){   //退出登陆
        
        WMLoginOutAPIManager * manager = [[WMLoginOutAPIManager alloc]init];
        [manager loadDataWithParams:nil withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kLoginOutSuccessNotification
                                                                object:nil
                                                              userInfo:@{}];
        } withFailure:^(ResponseResult *errorResult) {
            
        }];
        
    }
    
    
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
