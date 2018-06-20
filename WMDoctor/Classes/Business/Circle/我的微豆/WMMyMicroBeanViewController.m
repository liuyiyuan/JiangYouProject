//
//  WMMyMicroBeanViewController.m
//  WMDoctor
//
//  Created by xugq on 2017/11/27.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMMyMicroBeanViewController.h"
#import "WMMyMicroBeanAPIManager.h"
#import "WMMyMicroBeanCell.h"
#import "WMMyMicroBeanHeaderView.h"
#import "WMMyMicroBeanFooterView.h"
#import "WMIntegralDetailViewController.h"
#import "WMMicroExplainWebViewController.h"
#import "AppConfig.h"

@interface WMMyMicroBeanViewController ()<UITableViewDataSource, UITableViewDelegate>{
    NSInteger _pageNo;
    WMMyMicroBeanModel *_myMicroBeanModel;
    WorkEnvironment _currentEnvir;
}

@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSMutableArray *dataSource;
@property(nonatomic, strong)WMMyMicroBeanHeaderView *myMicroBeanHeaderView;
@property(nonatomic, strong)WMMyMicroBeanFooterView *myMicroBeanFooterView;

@end

@implementation WMMyMicroBeanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _currentEnvir = [AppConfig currentEnvir];   //获取当前运行环境
    //iOS11 适配
    if (@available(iOS 11.0, *)) {
//        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//        self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
//        self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    } else {
        // Fallback on earlier versions
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self setupData];
    [self setupView];
}

- (void)setupData{
    self.dataSource = [NSMutableArray new];
    _pageNo = 1;
    [self loadMyMicroBeanData];
}

- (void)setupView{
    self.title = @"我的微豆";
    self.view.backgroundColor = [UIColor colorWithHexString:@"F5F5F9"];
    
    UIButton *rightBarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBarBtn.frame = CGRectMake(0, 0, 40, 25);
    [rightBarBtn setTitle:@"明细" forState:UIControlStateNormal];
    rightBarBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [rightBarBtn addTarget:self action:@selector(rightBarItemClickAction) forControlEvents:UIControlEventTouchUpInside];
    [rightBarBtn setTintColor:[UIColor whiteColor]];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarBtn];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_width, kScreen_height - SafeAreaTopHeight) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor colorWithHexString:@"F5F5F9"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    _myMicroBeanHeaderView = [[WMMyMicroBeanHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreen_width, 185)];
    _tableView.tableHeaderView = _myMicroBeanHeaderView;
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WMMyMicroBeanCell class]) bundle:nil] forCellReuseIdentifier:@"WMMyMicroBeanCell"];
    //刷新
    __weak typeof(self) weakSelf = self;
    MJWeiMaiFooter *footer = [MJWeiMaiFooter footerWithRefreshingBlock:^{
        [weakSelf loadMyMicroBeanData];
    }];
    _tableView.mj_footer = footer;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WMBeanExchangeModel *beanModel = [self.dataSource objectAtIndex:indexPath.row];
    WMMyMicroBeanCell * cell = [tableView dequeueReusableCellWithIdentifier:@"WMMyMicroBeanCell" forIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setValueWithBeanExchangeModel:beanModel];
    cell.exchange.tag = indexPath.row;
    [cell.exchange addTarget:self action:@selector(exchangeBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WMBeanExchangeModel *beanModel = [self.dataSource objectAtIndex:indexPath.row];
    WMMicroExplainWebViewController *microExplainWebViewController = [[WMMicroExplainWebViewController alloc] init];
    LoginModel *model=[WMLoginCache getMemoryLoginModel];
    
    if ([model.loginFlag isEqual:@"1"]) {
        //这种方式保证返回的值肯定不是nil
        NSString * urlStr = (_currentEnvir == 0)?H5_URL_BEANEXCHANGE_FORMAL:(_currentEnvir == 3)?H5_URL_BEANEXCHANGE_PRE:H5_URL_BEANEXCHANGE_TEST;
        microExplainWebViewController.urlString = [NSString stringWithFormat:@"%@?id=%@", urlStr,beanModel.id];
        microExplainWebViewController.backTitle = @"";
        [self.navigationController pushViewController:microExplainWebViewController animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 102;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

//明细
- (void)rightBarItemClickAction{
    WMIntegralDetailViewController *integralDetailViewController = [[WMIntegralDetailViewController alloc] init];
    integralDetailViewController.backTitle = @"";
    integralDetailViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:integralDetailViewController animated:YES];
}

//兑换
- (void)exchangeBtnClickAction:(UIButton *)button{
    WMBeanExchangeModel *beanModel = [self.dataSource objectAtIndex:button.tag];
    WMMicroExplainWebViewController *microExplainWebViewController = [[WMMicroExplainWebViewController alloc] init];
    LoginModel *model=[WMLoginCache getMemoryLoginModel];

    if ([model.loginFlag isEqual:@"1"]) {
        //这种方式保证返回的值肯定不是nil
        NSString * urlStr = (_currentEnvir == 0)?H5_URL_BEANEXCHANGE_FORMAL:(_currentEnvir == 3)?H5_URL_BEANEXCHANGE_PRE:H5_URL_BEANEXCHANGE_TEST;
        microExplainWebViewController.urlString = [NSString stringWithFormat:@"%@?id=%@", urlStr,beanModel.id];
        microExplainWebViewController.backTitle = @"";
        [self.navigationController pushViewController:microExplainWebViewController animated:YES];
    }
}

- (void)loadMyMicroBeanData{
    WMMyMicroBeanAPIManager *myMicroBeanaAPIManager = [[WMMyMicroBeanAPIManager alloc] init];
    NSDictionary *param = @{
                            @"pageNum" : [NSString stringWithFormat:@"%ld", _pageNo],
                            @"pageSize" : @"15"
                            };
    [myMicroBeanaAPIManager loadDataWithParams:param withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"积分兑换列表数据 : %@", responseObject);
        _pageNo ++;
        if (responseObject != nil) {
            _myMicroBeanModel = [[WMMyMicroBeanModel alloc] initWithDictionary:responseObject error:nil];
            [self.dataSource addObjectsFromArray:_myMicroBeanModel.scoreConversionItems];
            [self.tableView reloadData];
            _myMicroBeanHeaderView.score.text = _myMicroBeanModel.doctorScore;
        }
        [self.tableView.mj_footer endRefreshing];
        if ([_myMicroBeanModel.scoreConversionItems count] < 15) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            self.myMicroBeanFooterView = [[WMMyMicroBeanFooterView alloc] initWithFrame:CGRectMake(0, 0, kScreen_width, 105)];
            self.tableView.tableFooterView = self.myMicroBeanFooterView;
        } else{
            self.tableView.tableFooterView = nil;
        }
       
    } withFailure:^(ResponseResult *errorResult) {
        NSLog(@"积分兑换列表error : %@", errorResult);
        [self.tableView.mj_footer endRefreshing];
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
