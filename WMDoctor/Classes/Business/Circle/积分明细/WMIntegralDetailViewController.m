//
//  WMIntegralDetailViewController.m
//  WMDoctor
//
//  Created by xugq on 2017/11/22.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMIntegralDetailViewController.h"
#import "WMIntegralDetailCell.h"
#import "WMIntegralDetailAPIManager.h"
#import "WMMyMicroBeanViewController.h"

@interface WMIntegralDetailViewController ()<UITableViewDataSource, UITableViewDelegate>{
    NSInteger _pageNo;
    WMIntegralDetailModel *_integralDetailModel;
}

@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSMutableArray *dataSource;

@end

@implementation WMIntegralDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    _pageNo = 1;
    self.dataSource = [NSMutableArray new];
    [self loadIntegralDetailData];
}

- (void)setupView{
    self.title = @"明细";
    self.view.backgroundColor = [UIColor colorWithHexString:@"F4F4F4"];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_width, kScreen_height - SafeAreaTopHeight) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor colorWithHexString:@"F4F4F4"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WMIntegralDetailCell class]) bundle:nil] forCellReuseIdentifier:@"WMIntegralDetailCell"];
    //刷新
    __weak typeof(self) weakSelf = self;
    MJWeiMaiFooter *footer = [MJWeiMaiFooter footerWithRefreshingBlock:^{
        [weakSelf loadIntegralDetailData];
    }];
    _tableView.mj_footer = footer;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WMIntegralModel *integral = [self.dataSource objectAtIndex:indexPath.row];
    WMIntegralDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:@"WMIntegralDetailCell" forIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setValueWithIntegral:integral];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor colorWithHexString:@"F3F5F9"];
    
    UILabel *aweak = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, kScreen_width - 30, 20)];
    aweak.font = [UIFont systemFontOfSize:14];
    aweak.textColor = [UIColor colorWithHexString:@"999999"];
    aweak.text = @"部分微豆非实时到账，详情参照微豆说明";
    [view addSubview:aweak];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 43.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (UIView *)tableHeaderView{
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_width, 80)];
    bottomView.backgroundColor = [UIColor whiteColor];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(15, 29, 70, 22)];
    title.font = [UIFont systemFontOfSize:16];
    title.textColor = [UIColor colorWithHexString:@"333333"];
    title.text = @"我的微豆:";
    [bottomView addSubview:title];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(title.right + 10, 34, 13, 13)];
    imageView.image = [UIImage imageNamed:@"IntegralDetail"];
    [bottomView addSubview:imageView];
    
    UILabel *score = [[UILabel alloc] initWithFrame:CGRectMake(imageView.right + 6.5, 29, 300, 22)];
    score.font = [UIFont systemFontOfSize:16];
    score.textColor = [UIColor colorWithHexString:@"18A2FF"];
    score.text = _integralDetailModel.doctorScore;
    [bottomView addSubview:score];
    
    return bottomView;
}

- (void)loadIntegralDetailData{
    WMIntegralDetailAPIManager *tegralDetailAPIManager = [[WMIntegralDetailAPIManager alloc] init];
    NSDictionary *param = @{
                            @"pageNum" : [NSString stringWithFormat:@"%ld", _pageNo],
                            @"pageSize" : @"15"
                            };
    [tegralDetailAPIManager loadDataWithParams:param withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"积分明细 ： %@", responseObject);
        _pageNo ++;
        if (responseObject != nil) {
            _integralDetailModel = [[WMIntegralDetailModel alloc] initWithDictionary:responseObject error:nil];
            [self.dataSource addObjectsFromArray:_integralDetailModel.scoreHistories];
            [self.tableView reloadData];
            _tableView.tableHeaderView = [self tableHeaderView];
        }
        [self.tableView.mj_footer endRefreshing];
        if ([_integralDetailModel.scoreHistories count] < 15) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    } withFailure:^(ResponseResult *errorResult) {
        NSLog(@"积分明细error : %@", errorResult);
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
