//
//  WMDoctorIncomeViewController.m
//  WMDoctor
//
//  Created by xugq on 2017/10/19.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMDoctorIncomeViewController.h"
#import "WMIncomeCell.h"
#import "WMIncomeAPIManager.h"
#import "WMOrderListModel.h"


@interface WMDoctorIncomeViewController ()

@property(nonatomic, strong)UILabel *incomeLabel;
@property(nonatomic, strong)NSMutableArray *incomes;

@end

@implementation WMDoctorIncomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupData];
    [self setupView];
}

- (void)setupData{
    self.incomes = [NSMutableArray new];
    [self loadDoctorIncomeRequest];
}

- (void)setupView{
    self.title = @"收入说明";
    self.backTitle = @"";
    [self.tableView registerClass:[WMIncomeCell class] forCellReuseIdentifier:@"WMIncomeCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.incomes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WMIncomeCell *cell = (WMIncomeCell *)[tableView dequeueReusableCellWithIdentifier:@"WMIncomeCell" forIndexPath:indexPath];
    WMIncomeModel *incomeModel = self.incomes[indexPath.row];
    cell.numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 18, 15, 10)];
    cell.numberLabel.font = [UIFont systemFontOfSize:14];
    cell.numberLabel.textColor = [UIColor colorWithHexString:@"333333"];
    cell.numberLabel.text = [NSString stringWithFormat:@"%ld.", indexPath.row + 1];//@"1.";
    [cell.contentView addSubview:cell.numberLabel];
    
    cell.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 15, kScreen_width - 55, [CommonUtil heightForLabelWithText:incomeModel.orderDesc width:kScreen_width - 55 font:[UIFont systemFontOfSize:14]])];
    cell.contentLabel.font = [UIFont systemFontOfSize:14];
    cell.contentLabel.numberOfLines = 0;
    cell.contentLabel.textColor = [UIColor colorWithHexString:@"333333"];
//    cell.contentLabel.text = @"您的收入包含图文咨询订单、包月咨询订单、医生朋友圈订单及所有平台活动奖励。";
    cell.contentLabel.text = incomeModel.orderDesc;
    [cell.contentView addSubview:cell.contentLabel];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    WMIncomeModel *incomeModel = self.incomes[indexPath.row];
    return [CommonUtil heightForLabelWithText:incomeModel.orderDesc width:kScreen_width - 55 font:[UIFont systemFontOfSize:14]] + 15;
    
}

- (void)loadDoctorIncomeRequest{
    WMIncomeAPIManager *incomeAPIManager = [[WMIncomeAPIManager alloc] init];
    [incomeAPIManager loadDataWithParams:@{} withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"收入详情data= %@", responseObject);
        for (NSString *desc in [responseObject objectForKey:@"orderDesc"]) {
            WMIncomeModel *income = [[WMIncomeModel alloc] init];
            income.orderDesc = desc;
            [self.incomes addObject:income];
        }
        [self.tableView reloadData];
//        [self.incomes addObjectsFromArray:responseObject];
    } withFailure:^(ResponseResult *errorResult) {
        NSLog(@"收入详情error = %@", errorResult);
    }];
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
