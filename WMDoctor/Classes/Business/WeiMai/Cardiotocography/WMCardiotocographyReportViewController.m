//
//  WMCardiotocographyReportViewController.m
//  WMDoctor
//
//  Created by JacksonMichael on 2017/7/4.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMCardiotocographyReportViewController.h"
#import "WMCardiotocographyReportCell.h"
#import "WMReportListModel.h"
#import "WMReportListGetAPIManager.h"
#import "WMReportDetailViewController.h"
#import "WMReadReportViewController.h"
#import "WMUNReadReportViewController.h"

@interface WMCardiotocographyReportViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray * _arrList;
    
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;



@end

@implementation WMCardiotocographyReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setupData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setupData{
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    _arrList = [[NSMutableArray  alloc] initWithCapacity:0];
    
    WMReportListGetAPIManager * apiManager = [WMReportListGetAPIManager new];
    [apiManager loadDataWithParams:nil withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        WMReportListModels * models = (WMReportListModels *)responseObject;
        [_arrList removeAllObjects];
        for (WMReportListModel * model in models.reportList) {
            [_arrList addObject:model];
        }
        [self.tableView reloadData];
    } withFailure:^(ResponseResult *errorResult) {
        
    }];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 231.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0000000001f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 15.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"WeiMai" bundle:nil];
    WMReportDetailViewController * reportVC = [storyboard instantiateViewControllerWithIdentifier:@"WMReportDetailViewController"];
    reportVC.title = ((WMReportListModel *)_arrList[indexPath.row]).name;
//    reportVC.report_id = reportVC.title = ((WMReportListModel *)_arrList[indexPath.row]).reportId;
    reportVC.report_id = ((WMReportListModel *)_arrList[indexPath.row]).mid;
    [self.navigationController pushViewController:reportVC animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WMCardiotocographyReportCell * cell = (WMCardiotocographyReportCell *)[tableView dequeueReusableCellWithIdentifier:@"WMCardiotocographyReportCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setCellValue:(WMReportListModel *)_arrList[indexPath.row]];
    
    
    return cell;
}


#pragma mark - 所有报告入口

- (IBAction)unReadReportBtn:(id)sender {
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"WeiMai" bundle:nil];
    WMUNReadReportViewController * reportVC = [storyboard instantiateViewControllerWithIdentifier:@"WMUNReadReportViewController"];
    [self.navigationController pushViewController:reportVC animated:YES];
    
}


- (IBAction)readReportBtn:(id)sender {
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"WeiMai" bundle:nil];
    
    WMReadReportViewController * readreportVC = [storyboard instantiateViewControllerWithIdentifier:@"WMReadReportViewController"];
    [self.navigationController pushViewController:readreportVC animated:YES];
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
