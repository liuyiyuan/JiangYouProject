//
//  WMRecommenDepartViewController.m
//  WMDoctor
//
//  Created by 茭白 on 2017/3/24.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMRecommenDepartViewController.h"
#import "WMRecommendDocViewController.h"
#import "WMDoctorOfficesAPIManager.h"
#import "WMDoctorOfficesModel.h"

@interface WMRecommenDepartViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
}
@property (nonatomic ,strong)NSMutableArray *dataSource;
@end

@implementation WMRecommenDepartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"选择科室";
    [self setupView];
    [self getLoadData];
    self.dataSource=[[NSMutableArray alloc] initWithCapacity:0];
    // Do any additional setup after loading the view.
}
- (void)setupView {
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_width, kScreen_height) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
    self.view.backgroundColor=[UIColor colorWithHexString:@"f4f4f4"];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0);
    _tableView.tableFooterView=[UIView new];
    
    //刷新
    
    
}
-(void)getLoadData{
    WMDoctorOfficesAPIManager *doctorOfficesAPIManager=[[WMDoctorOfficesAPIManager alloc] init];
    
    [doctorOfficesAPIManager loadDataWithParams:nil withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"responseObject==%@",responseObject);
        WMDoctorOfficesModel *doctorOfficesModel=[[WMDoctorOfficesModel alloc] initWithDictionary:responseObject error:nil];
        
        [self.dataSource addObjectsFromArray:doctorOfficesModel.offices];
        [_tableView reloadData];
        
    } withFailure:^(ResponseResult *errorResult) {
        
    }];

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataSource.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    WMDoctorOfficesDetailModel *model=self.dataSource[indexPath.row];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.textLabel.font=[UIFont systemFontOfSize:14.0];
        cell.textLabel.textColor=[UIColor colorWithHexString:@"333333"];
    }
    
    cell.textLabel.text=model.officeName;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头

    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    WMRecommendDocViewController *recommendDocVC=[[WMRecommendDocViewController alloc] init];
    WMDoctorOfficesDetailModel *model=self.dataSource[indexPath.row];
    recommendDocVC.officeId=model.officeId;
    recommendDocVC.titleName=model.officeName;
    recommendDocVC.targetIdStr=self.targetIdStr;
    recommendDocVC.dingdanhao=self.dingdanhao;
    [self.navigationController pushViewController:recommendDocVC animated:YES];

    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 45;
    
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
