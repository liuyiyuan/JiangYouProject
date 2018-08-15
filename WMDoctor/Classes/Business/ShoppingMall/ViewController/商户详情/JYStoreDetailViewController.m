//
//  JYStoreDetailViewController.m
//  WMDoctor
//
//  Created by xugq on 2018/8/7.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYStoreDetailViewController.h"
#import "JYStoreInfoCell.h"
#import "JYStoreStatusCell.h"
#import "JYStoreCouponCell.h"
#import "JYSetMealCell.h"
#import "JYStoreDetailAPIManager.h"
#import "JYStoreEvaluatesAPIManager.h"
#import "JYStoreEvaluatesModel.h"

@interface JYStoreDetailViewController ()<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)JYStoreEvaluatesModel *storeEvaluate;

@end

@implementation JYStoreDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
    [self loadStoreDetailRequest];
    [self loadStoreEvaluatesRequest];
}

- (void)setupView{
    self.title = @"商户详情";
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JYStoreInfoCell class]) bundle:nil] forCellReuseIdentifier:@"JYStoreInfoCell"];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JYStoreStatusCell class]) bundle:nil] forCellReuseIdentifier:@"JYStoreStatusCell"];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JYStoreCouponCell class]) bundle:nil] forCellReuseIdentifier:@"JYStoreCouponCell"];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JYSetMealCell class]) bundle:nil] forCellReuseIdentifier:@"JYSetMealCell"];
    [self.view addSubview:self.tableView];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    } else if (section == 1){
        return 1;
    } else if (section == 2){
        return 1;
    } else if (section == 3){
        return 3;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        JYStoreInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JYStoreInfoCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if (indexPath.section == 1){
        JYStoreStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JYStoreStatusCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if (indexPath.section == 2){
        JYStoreCouponCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JYStoreCouponCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if (indexPath.section == 3){
        JYSetMealCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JYSetMealCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 154.f;
    } else if (indexPath.section == 1){
        return 73.f;
    } else if (indexPath.section == 2){
        return 91.f;
    } else if (indexPath.section == 3){
        return 141.f;
    }
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

//商家信息
- (void)loadStoreDetailRequest{
    JYStoreDetailAPIManager *storeDetailAPIManager = [[JYStoreDetailAPIManager alloc] init];
    NSDictionary *param = @{
                            @"merchantid" : self.storeId
                            };
    [storeDetailAPIManager loadDataWithParams:param withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"store detail : %@", responseObject);
    } withFailure:^(ResponseResult *errorResult) {
        NSLog(@"store detail error : %@", errorResult);
    }];
}

//评价列表
- (void)loadStoreEvaluatesRequest{
    JYStoreEvaluatesAPIManager *storeEvaluatesAPIManager = [[JYStoreEvaluatesAPIManager alloc] init];
    NSDictionary *param = @{
                            @"merchantId" : self.storeId
                            };
    [storeEvaluatesAPIManager loadDataWithParams:param withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        self.storeEvaluate = [[JYStoreEvaluatesModel alloc] initWithDictionary:responseObject error:nil];
        NSLog(@"store evaluates : %@", self.storeEvaluate);
        [self.tableView reloadData];
    } withFailure:^(ResponseResult *errorResult) {
        NSLog(@"store evaluates error : %@", errorResult);
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
