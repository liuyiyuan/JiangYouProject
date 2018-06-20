//
//  WMQuickReplyListViewController.m
//  WMDoctor
//
//  Created by JacksonMichael on 2017/7/27.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMQuickReplyListViewController.h"
#import "WMQuickReplyListCell.h"
#import "QuickEntity+CoreDataClass.h"
#import "WMQuickReplyEditCell.h"
#import "WMQuickReplyEditViewController.h"

@interface WMQuickReplyListViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    LoginModel * _loginModel;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong,nonatomic) NSMutableArray * dataSoure;

@end

@implementation WMQuickReplyListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI{
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorColor = [UIColor colorWithHexString:@"dedede"];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupUI];
    [self setupData];
}

- (void)setupData{
    
    _dataSoure = [NSMutableArray array];
    
    _loginModel = [WMLoginCache getMemoryLoginModel];
    
    _dataSoure = [QuickEntity getQuickEntityList:_loginModel.phone andType:self.typeStr];
    
    [self.tableView reloadData];
    //CGRectMake(0, 0, 1, 1)可以直接返回到UITableView的最顶端
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
}


#pragma mark - UITableViewDelegate


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        QuickEntity * quick = (QuickEntity *)_dataSoure[indexPath.row];
        NSString * theStr = quick.contentText;
        float height = [CommonUtil heightForLabelWithText:theStr width:kScreen_width-30 font:[UIFont systemFontOfSize:14]] + 26;
        return (height < 60)?60:height;
    }else{
        return 50.f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0000000001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0000000001f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"WeiMai" bundle:nil];
        WMQuickReplyEditViewController * quickVC = [storyboard instantiateViewControllerWithIdentifier:@"WMQuickReplyEditViewController"];
        quickVC.typeStr = self.typeStr;
        [self.navigationController pushViewController:quickVC animated:YES];
    }else if (indexPath.section == 0){
        QuickEntity * quick = (QuickEntity *)_dataSoure[indexPath.row];
        
        if ([self.typeStr isEqualToString:@"talk"]) {   //融云聊天
            NSDictionary * dic = [[NSDictionary alloc]initWithObjectsAndKeys:quick.contentText,@"theQuickStr", nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"QuickReplyOftalkNotification" object:@"quickStr" userInfo:dic];
        }else{      //胎心
            NSDictionary * dic = [[NSDictionary alloc]initWithObjectsAndKeys:quick.contentText,@"theQuickStr", nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"QuickReplyNotification" object:@"quickStr" userInfo:dic];
        }
        [self.navigationController popViewControllerAnimated:NO];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return _dataSoure.count;
    }else{
        return 1;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        WMQuickReplyListCell * cell = [self.tableView dequeueReusableCellWithIdentifier:@"WMQuickReplyListCell" forIndexPath:indexPath];
        QuickEntity * quick = (QuickEntity *)_dataSoure[indexPath.row];
        cell.context.text = quick.contentText;
        
        return cell;
    }else{
        WMQuickReplyEditCell * cell = [self.tableView dequeueReusableCellWithIdentifier:@"WMQuickReplyEditCell" forIndexPath:indexPath];
        return cell;
    }
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"dataSoureING:%lu",(unsigned long)_dataSoure.count);
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (indexPath.section == 0) {
            //数据库删除
            QuickEntity * quick = _dataSoure[indexPath.row];
            [QuickEntity deleteQuickEntity:_loginModel.phone andTheType:self.typeStr andTheText:quick.contentText];
            
            //当前数据源删除
            [_dataSoure removeObjectAtIndex:indexPath.row];
            // Delete the row from the data source.
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
        }
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
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
