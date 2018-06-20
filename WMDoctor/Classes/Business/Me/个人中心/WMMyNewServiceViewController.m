//
//  WMMyNewServiceViewController.m
//  WMDoctor
//
//  Created by JacksonMichael on 2017/12/6.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMMyNewServiceViewController.h"
#import "WMGetDoctorServiceAPIManager.h"
#import "WMServiceListCell.h"
#import "WMDoctorServiceModel.h"
#import "WMCertificationViewController.h"
#import "WMOpenServiceAPIManager.h"
#import "WMMyServiceSetViewController.h"

@interface WMMyNewServiceViewController ()<UITableViewDelegate,UITableViewDataSource,WMServiceListCellDelegate>
{
    WMDoctorServiceModel * model;
    WMDoctorMyServiceModel * _doctorModel;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic, strong)NSMutableArray *dataServiceSource;  //头部数据
@end

@implementation WMMyNewServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    _dataServiceSource = [NSMutableArray array];
    [self initUI];
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initData];
}

- (void)initUI{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    self.tableView.backgroundColor = [UIColor colorWithHexString:@"dedede"];
//    self.view.backgroundColor = [UIColor colorWithHexString:@"dedede"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)initData{
    WMGetDoctorServiceAPIManager * apiManager = [[WMGetDoctorServiceAPIManager alloc]init];
    [apiManager loadDataWithParams:nil withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        model = (WMDoctorServiceModel *)responseObject;
        [_dataServiceSource removeAllObjects];
        [_dataServiceSource addObjectsFromArray:model.myServices];
        [self.tableView reloadData];
    } withFailure:^(ResponseResult *errorResult) {
        
    }];
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0000001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataServiceSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WMServiceListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"WMServiceListCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    [cell setCellValue:_dataServiceSource[indexPath.row]];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)cellClickBtn:(NSString *)str andBtn:(UIButton *)btn{
    if ([model.certificationStatus isEqualToString:@"0"] || [model.certificationStatus isEqualToString:@"3"]) {
        // 1.UIAlertView
        // 2.UIActionSheet
        // iOS8开始:UIAlertController == UIAlertView + UIActionSheet
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"认证后可开启在线咨询服务" preferredStyle:UIAlertControllerStyleAlert];
        
        // 添加按钮
        //        __weak typeof(alert) weakAlert = alert;
        [alert addAction:[UIAlertAction actionWithTitle:@"去认证" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            WMCertificationViewController * goVC = [WMCertificationViewController new];
            goVC.isFirstLogin = false;
            goVC.service_model = model;
            [self.navigationController pushViewController:goVC animated:YES];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            NSLog(@"点击了取消按钮");
        }]];
        
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }else if ([model.certificationStatus isEqualToString:@"1"]){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"您已提交实名认证，请耐心等待" preferredStyle:UIAlertControllerStyleAlert];
        
        // 添加按钮
        //        __weak typeof(alert) weakAlert = alert;
        [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
        }]];
        
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    
    if ([str isEqualToString:@"开启"]) {
        WMOpenServiceAPIManager * manager = [[WMOpenServiceAPIManager alloc]init];
        
        [manager loadDataWithParams:@{@"openService":@"1",@"typeId":[NSString stringWithFormat:@"%ld",(long)btn.tag]} withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"%@",responseObject);
            [self.tableView reloadData];
            [self goServicePriceSet:[NSString stringWithFormat:@"%ld",(long)btn.tag]];
            
        } withFailure:^(ResponseResult *errorResult) {
        }];
    }else{
        [self goServicePriceSet:[NSString stringWithFormat:@"%ld",(long)btn.tag]];
    }
    
    
    
}

- (void)goServicePriceSet:(NSString *)inquiryType{
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
    WMMyServiceSetViewController * doctorVC = [storyboard instantiateViewControllerWithIdentifier:@"WMMyServiceSetViewController"];
    doctorVC.hidesBottomBarWhenPushed = YES;
    doctorVC.inquiryType = inquiryType;
    [self.navigationController pushViewController:doctorVC animated:YES];
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
