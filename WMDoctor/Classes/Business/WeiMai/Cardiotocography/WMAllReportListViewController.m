//
//  WMAllReportListViewController.m
//  WMDoctor
//
//  Created by JacksonMichael on 2017/7/8.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMAllReportListViewController.h"
#import "WMReadReportViewController.h"
#import "WMUNReadReportViewController.h"

#import "WMAllReportListGetAPIManager.h"
#import "WMAllReportGetPageParamModel.h"
#import "WMAllReportListModel.h"

@interface WMAllReportListViewController ()
{
    WMAllReportGetPageParamModel * _customModelss;
    WMAllReportListModel * _models;
    NSString * _lastTitle;
}


@end

@implementation WMAllReportListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _models = [WMAllReportListModel new];
    _customModelss = [WMAllReportGetPageParamModel new];
    
    [self setupUI];
//    [self setupData];
    
    // Do any additional setup after loading the view.
}

- (void)setupUI{
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    [center addObserver:self selector:@selector(receiveNotificiation:) name:@"WMUNReadReportViewController" object:@"unReadCount"];
    
    self.segmentTitleColor = [UIColor colorWithHexString:@"333333"];
    self.segmentHighlightColor = [UIColor colorWithHexString:@"18a2ff"];
    self.segmentBorderColor = [UIColor colorWithHexString:@"18a2ff"];
    
    _lastTitle = @"未处理";
    
    self.title = @"所有报告";
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"WeiMai" bundle:nil];
    WMUNReadReportViewController * reportVC = [storyboard instantiateViewControllerWithIdentifier:@"WMUNReadReportViewController"];
    reportVC.title = _lastTitle;
    
    WMReadReportViewController * readreportVC = [storyboard instantiateViewControllerWithIdentifier:@"WMReadReportViewController"];
    readreportVC.title = @"已处理";
    
    self.viewControllers = @[reportVC, readreportVC];
//    self.segmentControl.titles 
}

- (void)receiveNotificiation:(NSNotification*)sender{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.segmentControl.titles = @[[NSString stringWithFormat:@"待处理 (%@)",[sender.userInfo objectForKey:@"theValue"] ],@"已处理"];
        [self.segmentControl load];
    });
    
}

- (void)setupData{
    _customModelss.page_no = @"1";
    _customModelss.page_row = kPAGEROW;
    _customModelss.begin_date = @"";
    _customModelss.end_date = @"";
    _customModelss.status = @"0";
    LoginModel *themodel = [WMLoginCache getMemoryLoginModel];
    
    _customModelss.p_uid = themodel.phone;
    
    WMAllReportListGetAPIManager * apiManagerss = [WMAllReportListGetAPIManager new];
    [apiManagerss loadDataWithParams:_customModelss.toDictionary withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        _models = (WMAllReportListModel *)responseObject;
        
        WMAllReportListModels * modelss = (WMAllReportListModels *)_models.allReportsResult;
        
        
        _lastTitle = [NSString stringWithFormat:@"待处理 (%@)",modelss.records];
        
        [self setupUI];
        
        
    } withFailure:^(ResponseResult *errorResult) {

    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"WMUNReadReportViewController" object:@"unReadCount"];
    
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
