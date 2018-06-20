//
//  WMAddFriendMenuTableViewController.m
//  WMDoctor
//  添加朋友菜单
//  Created by JacksonMichael on 2017/3/17.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMAddFriendMenuTableViewController.h"

@interface WMAddFriendMenuTableViewController ()

@end

@implementation WMAddFriendMenuTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.000000001f;
    }else if (section == 1) {
        return 10.0f;
    }else{
        return 10.0f;
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else if(section == 1){
        return 3;
    }else{
        return 1;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"indexPath.row==%ld",(long)indexPath.row);
//    switch (indexPath.row) {
//        case 0:
//        {
//            [self doAlertInput:nil];
//        }
//            break;
//        case 1:
//        {
//            [self changePriceforCell:self.oneCell];   //改变CELL UI显示
//        }
//            break;
//        case 2:
//        {
//            [self changePriceforCell:self.twoCell];   //改变CELL UI显示
//        }
//            break;
//        case 3:
//        {
//            [self changePriceforCell:self.threeCell];   //改变CELL UI显示
//        }
//            break;
//        case 4:
//        {
//            [self changePriceforCell:self.fourCell];   //改变CELL UI显示
//        }
//            break;
//        default:
//            break;
//    }
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
