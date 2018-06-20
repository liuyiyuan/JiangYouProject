//
//  WMTagPatientViewController.m
//  WMDoctor
//
//  Created by xugq on 2018/5/21.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "WMTagPatientViewController.h"
#import "WMTagPatientAPIManager.h"
#import "WMSearchPatientCell.h"
#import "WMPatientReportedModel.h"
#import "WMPatientDataViewController.h"

@interface WMTagPatientViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *_tableView;
    NSInteger _pageNo;
}
@property(nonatomic, strong)NSMutableArray *dataSource;//数据源
@property(nonatomic, strong)WMTagGroupModel *tagGroup;

@end

@implementation WMTagPatientViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_tableView) {
        [_tableView reloadData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupData];
    [self setupView];
    [self loadDefaultData];
}

-(void)setupView{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.tableFooterView=[UIView new];
    [_tableView setSeparatorInset:UIEdgeInsetsMake(0,70,0,0)];
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:_tableView];
    _tableView.backgroundColor=[UIColor colorWithHexString:@"f4f4f4"];
    _tableView.mj_header = [MJWeiMaiHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadDefaultData)];
    __weak typeof(self) weakSelf = self;
    MJWeiMaiFooter *footer = [MJWeiMaiFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
    
    _tableView.mj_footer = footer;
}

- (void)setupData{
    _pageNo = 1;
    self.title = self.cricleGroupModel.groupName;
    self.view.backgroundColor=[UIColor colorWithHexString:@"f4f4f4"];
    self.dataSource=[[NSMutableArray  alloc] initWithCapacity:0];
}

- (void)loadDefaultData{
    [self loadDataWithPage: 1];
}

- (void)loadMoreData{
    _pageNo += 1;
    [self loadDataWithPage: _pageNo];
}
- (void)loadDataWithPage:(NSInteger)pageIndex{
    
    WMTagPatientAPIManager *tagPatientAPIManager = [[WMTagPatientAPIManager alloc] init];
    NSDictionary *param = @{
                            @"groupId" : self.cricleGroupModel.groupId,
                            @"pageNum" : [NSString stringWithFormat:@"%ld", _pageNo],
                            @"pageSize" : @"20"
                            };
    [tagPatientAPIManager loadDataWithParams:param withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"标签分组 : %@", responseObject);
        _pageNo ++;
        self.tagGroup = [[WMTagGroupModel alloc] initWithDictionary:responseObject error:nil];
        [self.dataSource addObjectsFromArray:self.tagGroup.patients];
        NSLog(@"标签分组model ： %@", self.tagGroup);
        if (self.dataSource.count == 0) {
            [_tableView showListEmptyView:@"Circle_huanzhebaodaoquesheng" title:@"该标签下暂无患者" buttonTitle:nil completion:^(UIButton *button) {
                [self jumpCard];
            }];
        }
        if (self.tagGroup.patients.count < 20) {
            if (self.dataSource.count == 0) {
                _tableView.mj_footer.hidden = YES;
            }
            [_tableView.mj_footer endRefreshingWithNoMoreData];
        }
        [_tableView reloadData];
    } withFailure:^(ResponseResult *errorResult) {
        NSLog(@"标签分组 error%@", errorResult);
    }];
}

-(void)jumpCard{
}

#pragma mark--UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    WMPatientModel *patient = self.dataSource[indexPath.row];
    WMSearchPatientCell *patientReportedCell = (WMSearchPatientCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (!patientReportedCell) {
        patientReportedCell=[[[NSBundle mainBundle]loadNibNamed:@"WMSearchPatientCell" owner:self options:Nil] lastObject];
    }
    [patientReportedCell tagPatientVCSetValueWithWMPatientModel:patient];
    return patientReportedCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WMPatientModel *patient = self.tagGroup.patients[indexPath.row];
    //跳转到患者资料页
    WMPatientDataViewController *patientDataViewController = [[WMPatientDataViewController alloc] init];
    patientDataViewController.userId = patient.weimaihao;
    patientDataViewController.tagPatientModel = patient;
    [self.navigationController pushViewController:patientDataViewController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.f;
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
