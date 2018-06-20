//
//  WMMyServiceTableViewController.m
//  WMDoctor
//  我的服务设置
//  Created by JacksonMichael on 2016/12/23.
//  Copyright © 2016年 Choice. All rights reserved.
//

#import "WMMyServiceTableViewController.h"
#import "WMServiceUpdatePriceAPIManager.h"
#import "WMGetServicePriceAPIManager.h"
#import "WMServicePriceModel.h"
#import "WMOpenServiceCell.h"
#import "WMServiceTitleCell.h"
#import "WMServiceCustomPriceCell.h"
#import "WMServiceDescriptionCell.h"
#import "WMOpenServiceAPIManager.h"

@interface WMMyServiceTableViewController ()<cellClickSwitchDelegate>
{
    WMServicePriceModel * _model;
}


@end

@implementation WMMyServiceTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setupUI];
    [self setupData];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI{
    self.tableView.backgroundColor=[UIColor colorWithHexString:@"f4f4f4"];
    if ([self.serviceModel.type isEqualToString:@"0"]) {
        self.title = @"图文咨询";
    }else{
        self.title = @"包月咨询";
    }
}

- (void)setupData{
    WMGetServicePriceAPIManager * apiManager = [[WMGetServicePriceAPIManager alloc]init];
    
    [apiManager loadDataWithParams:@{@"typeId":self.serviceModel.typeId,@"type":self.serviceModel.type,@"pricingPrivilege":self.serviceModel.pricingPrivilege} withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        _model = (WMServicePriceModel *)responseObject;
        
        NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:_model.price,@"price",_serviceModel.type,@"type", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changePriceNotification" object:@"flagValue" userInfo:dict];
        
        [self.tableView reloadData];
    } withFailure:^(ResponseResult *errorResult) {
        
    }];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (![self.serviceModel.pricingPrivilege isEqualToString:@"1"] && (indexPath.section == 2 || indexPath.section == 3)) {
        return 0.0000000001f;
    }
    
    if (indexPath.section == 4 && indexPath.row == 1) {
        
        return [CommonUtil heightForLabelWithText:_model.descriptionStr width:kScreen_width-30 font:[UIFont systemFontOfSize:14]] + 25;
    }else{
        return 50.f;
    }

    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.0000001f;
    }else if (section == 1){
        return 10.f;
    }else if (section == 2){
        return 0.00000001f;
    }else{
        return 10.f;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00000001f;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else if(section == 1){
        return 1;
    }else if(section == 2){
        if (_model) {
            
            return _model.prices.count;
        }
        return 0;
    }else if(section == 3){
        return 1;
    }else{
        return 2;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    if (indexPath.section == 0) {
        WMOpenServiceCell * cell = (WMOpenServiceCell *)[tableView dequeueReusableCellWithIdentifier:@"WMOpenServiceCell" forIndexPath:indexPath];
        cell.openServiceSwitch.on = self.serviceModel.openService;
        cell.cellDelegate = self;
        return cell;
    }else if(indexPath.section == 1){
        WMServiceTitleCell * cell = (WMServiceTitleCell *)[tableView dequeueReusableCellWithIdentifier:@"WMServiceTitleCell" forIndexPath:indexPath];
        if ([self.serviceModel.pricingPrivilege isEqualToString:@"1"]) {     //有定价权限
            [cell setCellValue:@"您可以选择推荐价格或者自定义" andPrice:@""];
        }else{
            if ([self.serviceModel.type isEqualToString:@"0"]) {//0图文1包月
                [cell setCellValue:@"" andPrice:[NSString stringWithFormat:@"%@元/次",_model.price]];
            }else{
                [cell setCellValue:@"" andPrice:[NSString stringWithFormat:@"%@元/月",_model.price]];
            }
        }
        cell.titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
        if (!self.serviceModel.openService) {
            cell.titleLabel.textColor = [UIColor colorWithHexString:@"999999"];
        }
        
        
        
        return cell;
    }else if(indexPath.section == 2) {
        UITableViewCell * cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WMPriceCell"];
        if ([_model.type isEqualToString:@"0"]) {   //0图文1包月
            cell.textLabel.text = [NSString stringWithFormat:@"%@元/次",_model.prices[indexPath.row]];
        }else{
            cell.textLabel.text = [NSString stringWithFormat:@"%@元/月",_model.prices[indexPath.row]];
        }
        cell.textLabel.textColor = [UIColor colorWithHexString:@"666666"];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        
        if (![_model.custom isEqualToString:@"2"] && [_model.price isEqualToString:[NSString stringWithFormat:@"%@", _model.prices[indexPath.row]]]) {
            UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
            imageView.image = [UIImage imageNamed:@"ic_gouxuan"];
            cell.accessoryView = imageView;
        }
        
        if (!self.serviceModel.openService) {
            cell.textLabel.textColor = [UIColor colorWithHexString:@"999999"];
            cell.accessoryView = nil;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else if (indexPath.section == 3){
        WMServiceCustomPriceCell * cell =(WMServiceCustomPriceCell *)[tableView dequeueReusableCellWithIdentifier:@"WMServiceCustomPriceCell" forIndexPath:indexPath];
        
        cell.nothingLabel.textColor = [UIColor colorWithHexString:@"666666"];
        if (!self.serviceModel.openService) {
            cell.nothingLabel.textColor = [UIColor colorWithHexString:@"999999"];
        }
        
        if ([_model.custom isEqualToString:@"2"]) {
            if ([_model.type isEqualToString:@"0"]) {   //0图文1包月
                cell.priceLabel.text = [NSString stringWithFormat:@"%@元/次",_model.price];
            }else{
                cell.priceLabel.text = [NSString stringWithFormat:@"%@元/月",_model.price];
            }
        }else{
            cell.priceLabel.text = @"";
        }
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        return cell;
    }else{
        if (indexPath.row == 0) {
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"WMServiceDescriptionTitleCell" forIndexPath:indexPath];
            return cell;
        }else{
            WMServiceDescriptionCell * cell =(WMServiceDescriptionCell *)[tableView dequeueReusableCellWithIdentifier:@"WMServiceDescriptionCell" forIndexPath:indexPath];
            cell.descriptionLabel.text = _model.descriptionStr;
            return cell;
        }
    }
    
}


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

//改变勾选状态
//- (void)changeCellStatus:(UITableViewCell *)cell{
//    self.customPriceCell.accessoryView = nil;
//    self.oneCell.accessoryView = nil;
//    self.twoCell.accessoryView = nil;
//    self.threeCell.accessoryView = nil;
//    self.fourCell.accessoryView = nil;
//    self.customPriceCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    self.oneCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    self.twoCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    self.threeCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    self.fourCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    
//    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
//    imageView.image = [UIImage imageNamed:@"ic_mine_select"];
//    cell.accessoryView = imageView;
//    
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"indexPath.row==%ld",(long)indexPath.row);
    
    if (!self.serviceModel.openService) {
        return;
    }
    
    
    if ([self.serviceModel.pricingPrivilege isEqualToString:@"1"] && indexPath.section == 3) {
        [self doAlertInput:nil];
    }
    
    if ([self.serviceModel.pricingPrivilege isEqualToString:@"1"] && indexPath.section == 2) {
        WMServiceUpdatePriceAPIManager * manager = [[WMServiceUpdatePriceAPIManager alloc]init];
        [manager loadDataWithParams:@{@"price":[NSString stringWithFormat:@"%@", _model.prices[indexPath.row]],@"custom":@"1",@"typeId":self.serviceModel.typeId} withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
            
            _model.price = [NSString stringWithFormat:@"%@", _model.prices[indexPath.row]];   //改变显示值
            _model.custom = @"1";
            NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:_model.price,@"price",_serviceModel.type,@"type", nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"changePriceNotification" object:@"flagValue" userInfo:dict];
            [self.tableView reloadData];
        } withFailure:^(ResponseResult *errorResult) {
            
        }];
    }
    
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


//请求网络改变价格
- (void)changePriceforCell:(UITableViewCell *)cell{
    
//    NSString * price = @"";
//    if (cell == self.oneCell) {
//        price = @"19.00";
//    }else if (cell == self.twoCell){
//        price = @"29.00";
//    }else if (cell == self.threeCell){
//        price = @"39.00";
//    }else if (cell == self.fourCell){
//        price = @"49.00";
//    }
//    
//    WMchangePriceAPIManager * manager = [[WMchangePriceAPIManager alloc]init];
//    [manager loadDataWithParams:@{@"price":price} withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
//        NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:price,@"price", nil];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"changePriceNotification" object:nil userInfo:dict];
//        [self changeCellStatus:cell];   //改变CELL UI显示
//    } withFailure:^(ResponseResult *errorResult) {
//        
//    }];
}




- (IBAction)doAlertInput:(id)sender {
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
        [manager loadDataWithParams:@{@"price":usertext.text,@"custom":@"2",@"typeId":self.serviceModel.typeId} withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
            
            _model.price = usertext.text;   //改变显示值
            _model.custom = @"2";
            NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:usertext.text,@"price",_serviceModel.type,@"type", nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"changePriceNotification" object:@"flagValue" userInfo:dict];
            [self.tableView reloadData];
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

#pragma mark - cellClickSwitchDelegate

- (void)changedSwitchValue:(BOOL)on{
    
    
    WMOpenServiceAPIManager * manager = [[WMOpenServiceAPIManager alloc]init];
    
    [manager loadDataWithParams:@{@"openService":@(on),@"typeId":self.serviceModel.typeId} withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        _serviceModel.openService = on;
        
        NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:@(on),@"flag",_serviceModel.type,@"type", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeOpenServiceNotification" object:@"flagValue" userInfo:dict];
        
        [self.tableView reloadData];
    } withFailure:^(ResponseResult *errorResult) {
    }];
    
    
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
