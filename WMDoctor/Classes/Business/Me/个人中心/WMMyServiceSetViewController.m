//
//  WMMyServiceSetViewController.m
//  WMDoctor
//
//  Created by JacksonMichael on 2017/12/11.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMMyServiceSetViewController.h"
#import "WMServiceSetInfoModel.h"
#import "WMServiceSetInfoAPImanager.h"
#import "WMServiceSetCell.h"
#import "WMServiceDescriptionCellTableViewCell.h"
#import "WMServiceUpdatePriceAPIManager.h"
#import "WMOpenServiceAPIManager.h"
#import "WMApplyCircleCell.h"
#import "WMServiceViewController.h"
#import "AppConfig.h"

@interface WMMyServiceSetViewController ()<UITableViewDelegate,UITableViewDataSource,WMServicePriceChangeDelegate,WMApplyCircelCellDelegate>
{
    WMServiceSetInfoModel * _model;
    NSMutableArray * _dataScore;
}
@end

@implementation WMMyServiceSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self initData];
    
    // Do any additional setup after loading the view.
}

- (void)initUI{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.title = ([self.inquiryType isEqualToString:@"1"])?@"图文咨询设置":@"医聊圈设置";
}

- (void)initData{
    WMServiceSetInfoAPImanager * apiManager = [WMServiceSetInfoAPImanager new];
    if (!_dataScore) {
        _dataScore = [NSMutableArray array];
    }
    
    [apiManager loadDataWithParams:@{@"inquiryType":self.inquiryType} withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        _model = (WMServiceSetInfoModel *)responseObject;
        [_dataScore removeAllObjects];
        [_dataScore addObjectsFromArray:_model.serviceSetting];
        [self.tableView reloadData];
    } withFailure:^(ResponseResult *errorResult) {
        
    }];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([_model.openStatus isEqualToString:@"0"]) {     //没有开启服务(当前版本只可能出现在朋友圈服务中)
        return 2;
    }
    return _model.serviceSetting.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([_model.openStatus isEqualToString:@"0"]) {
        if (indexPath.section == 1) {
            return [CommonUtil heightForLabelWithText:_model.theDescription width:kScreen_width - 30 font:[UIFont systemFontOfSize:14]] + 74;
        }
        return 280;
    }
    if (indexPath.section == _model.serviceSetting.count) {
        return [CommonUtil heightForLabelWithText:_model.theDescription width:kScreen_width - 30 font:[UIFont systemFontOfSize:14]] + 30 + 44;
    }
    return 172;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0000001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_model) {
        return 1;
    }else{
        return 0;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([_model.openStatus isEqualToString:@"1"]) {     //非朋友圈（开启服务）
        if (indexPath.section != _model.serviceSetting.count) {  //有两价格
            WMServiceSetCell * cell = [tableView dequeueReusableCellWithIdentifier:@"WMServiceSetCell" forIndexPath:indexPath];
            [cell setCellValue:_dataScore[indexPath.section]];
            cell.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{  //只有一个价格下面直接展示服务说明
            WMServiceDescriptionCellTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"WMServiceDescriptionCellTableViewCell" forIndexPath:indexPath];
            cell.descriptionLabel.text = _model.theDescription;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }else{      //朋友圈（未开启服务）
        if (indexPath.section == 0) {
            WMApplyCircleCell * cell = [tableView dequeueReusableCellWithIdentifier:@"WMApplyCircleCell" forIndexPath:indexPath];
            cell.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            WMServiceDescriptionCellTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"WMServiceDescriptionCellTableViewCell" forIndexPath:indexPath];
            cell.descriptionLabel.text = _model.theDescription;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    
    
    
}

-(void)cellClickBtn:(NSString *)strTypeId{
    [self doAlertInput:strTypeId];
}

-(void)refreshPrice{
    [self initData];
}

- (void)doAlertInput:(NSString *)strTypeId{
    // 准备初始化配置参数
    NSString *title = @"价格设置";
    NSString *message = @"请输入您要设置的价格";
    NSString *okButtonTitle = @"确认";
    
    // 初始化
    UIAlertController *alertDialog = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    // 创建文本框
    [alertDialog addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = @"请输入1-999之间的整数价格";
        textField.secureTextEntry = NO;
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }];
    
    // 创建操作
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:okButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UITextField *usertext = alertDialog.textFields.firstObject;
        if ([usertext.text floatValue] < 1 ||  [usertext.text floatValue] > 999) {
            [WMHUDUntil showMessageToWindow:@"数额超出限制，请输入1-999之间的整数"];
            return;
        }
        
        // 读取文本框的值显示出来
        
                WMServiceUpdatePriceAPIManager * manager = [[WMServiceUpdatePriceAPIManager alloc]init];
                [manager loadDataWithParams:@{@"price":usertext.text,@"custom":@"2",@"typeId":strTypeId} withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        
//                    _model.price = usertext.text;   //改变显示值
//                    _model.custom = @"2";
//                    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:usertext.text,@"price",_serviceModel.type,@"type", nil];
//                    [[NSNotificationCenter defaultCenter] postNotificationName:@"changePriceNotification" object:@"flagValue" userInfo:dict];
                    [self initData];
                } withFailure:^(ResponseResult *errorResult) {
        
                }];
        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        // 取消按键
        //        self.userOutput.text = @"Clicked 'OK'";
    }];
    
    // 添加操作（顺序就是呈现的上下顺序）
    [alertDialog addAction:cancelAction];
    [alertDialog addAction:okAction];
    
    
    // 呈现警告视图
    
        [self presentViewController:alertDialog animated:YES completion:nil];
}

-(void)goCircle{
    //小脉助手
    WMServiceViewController *serviceVC=[[WMServiceViewController alloc]init];
    serviceVC.conversationType = ConversationType_CUSTOMERSERVICE;
    serviceVC.targetId = RONGCLOUD_SERVICE_ID;
    serviceVC.title = @"小脉助手";
    serviceVC.backName=@"微脉";
    serviceVC.hidesBottomBarWhenPushed = YES;
    [serviceVC sendMessageNew];
    [self.navigationController showViewController:serviceVC sender:nil];
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
