//
//  JYStoresViewController.m
//  WMDoctor
//
//  Created by xugq on 2018/8/7.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "JYStoresViewController.h"
#import "JYStoreModuleCell.h"
#import "JYStoresActivitesCell.h"
#import "JYSCCGoodsCell.h"
#import "JYStoreActiveCarefullyChooseaAPIManager.h"
#import "JYStoreActiveCarefullyChooseModel.h"
#import "JYSCCStoreAPIManager.h"
#import "JYSCCStoreModel.h"
#import "JYStoreDetailViewController.h"

@interface JYStoresViewController ()<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSMutableArray *actives;
@property(nonatomic, strong)NSMutableArray *dataSource;

@end

@implementation JYStoresViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupData];
    [self setupView];
    [self loadActiveCarefullyChooseRequest];
    [self loadCarefullyChooseStoresRequest];
}

- (void)setupData{
    self.actives = [NSMutableArray array];
    self.dataSource = [NSMutableArray array];
}

- (void)setupView{
    self.title = @"商户列表";
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [_tableView registerClass:[JYStoreModuleCell class] forCellReuseIdentifier:@"JYStoreModuleCell"];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JYStoresActivitesCell class]) bundle:nil] forCellReuseIdentifier:@"JYStoresActivitesCell"];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JYSCCGoodsCell class]) bundle:nil] forCellReuseIdentifier:@"JYSCCGoodsCell"];
    [self.view addSubview:self.tableView];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    } else if (section == 1){
        return 1;
    } else if (section == 2){
        return 5;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        JYStoreModuleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JYStoreModuleCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if (indexPath.section == 1){
        JYStoresActivitesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JYStoresActivitesCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.actives.count > 0) {
            [cell setValueWithActives:self.actives];
        }
        return cell;
    } else if (indexPath.section == 2){
        JYSCCGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JYSCCGoodsCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        JYSomeOneStoreModel *store = [self.dataSource objectAtIndex:indexPath.row];
        JYStoreDetailViewController *storeDetailViewController = [[JYStoreDetailViewController alloc] init];
        storeDetailViewController.storeId = store.merchantId;
        [self.navigationController pushViewController:storeDetailViewController animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 80.f;
    } else if (indexPath.section == 1){
        return 253.f;
    } else if (indexPath.section == 2){
        return 260.f;
    }
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth, 44)];
        label.text = @"活动精彩";
        label.font = [UIFont systemFontOfSize:15];
        [view addSubview:label];
        return view;
    } else if (section == 2){
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 65, 44)];
        label.text = @"便利生活";
        label.font = [UIFont systemFontOfSize:15];
        [view addSubview:label];
        
        UILabel *characterLabel = [[UILabel alloc] initWithFrame:CGRectMake(label.right + 6, 0, 45, 10)];
        characterLabel.text = @"品质美味";
        characterLabel.font = [UIFont systemFontOfSize:10];
        characterLabel.textColor = [UIColor colorWithHexString:@"#7E7D7D"];
        [view addSubview:characterLabel];
        return view;
    }
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1 || section == 2) {
        return 44.f;
    }
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (void)loadActiveCarefullyChooseRequest{
    JYStoreActiveCarefullyChooseaAPIManager *activeCarefullyChooseAPIManager = [[JYStoreActiveCarefullyChooseaAPIManager alloc] init];
    [activeCarefullyChooseAPIManager loadDataWithParams:@{} withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"activeCarefullyChoose data : %@", responseObject);
        for (NSDictionary *dic in responseObject) {
            JYStoreActiveCarefullyChooseModel *active = [[JYStoreActiveCarefullyChooseModel alloc] initWithDictionary:dic error:nil];
            [self.actives addObject:active];
        }
        [self.tableView reloadData];
    } withFailure:^(ResponseResult *errorResult) {
        NSLog(@"activeCarefullyChoose error : %@", errorResult);
    }];
}

- (void)loadCarefullyChooseStoresRequest{
    JYSCCStoreAPIManager *sccStoreAPIManager = [[JYSCCStoreAPIManager alloc] init];
    [sccStoreAPIManager loadDataWithParams:@{} withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"sccStore : %@", responseObject);
        JYSCCStoreModel *sccStoreModel = [[JYSCCStoreModel alloc] initWithDictionary:responseObject error:nil];
        [self.dataSource addObjectsFromArray:sccStoreModel.selectedArray];
        [self.tableView reloadData];
    } withFailure:^(ResponseResult *errorResult) {
        NSLog(@"sccStore error : %@", errorResult);
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
