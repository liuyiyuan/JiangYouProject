//
//  WMEducationSelectViewController.m
//  WMDoctor
//
//  Created by JacksonMichael on 2017/4/11.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMEducationSelectViewController.h"
#import "WMSchoolTypeModel.h"
#import "WMSchoolTypeListAPIManager.h"
#import "WMProvinceSelectViewController.h"

@interface WMEducationSelectViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView * _tableView;
    NSMutableArray * _allArr;
    WMEducationCustomModel * _customModel;
}
@end

@implementation WMEducationSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _customModel = [[WMEducationCustomModel alloc]init];
    [self setupUI];
    [self setupData];
    // Do any additional setup after loading the view.
}

- (void)setupUI{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_width, kScreen_height) style:UITableViewStyleGrouped];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.separatorColor = [UIColor colorWithHexString:@"dedede"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

- (void)setupData{
    
    
    if (_allArr) {
        [_allArr removeAllObjects];
    }else{
        _allArr = [NSMutableArray array];
    }
    
    WMSchoolTypeListAPIManager * apiManager = [[WMSchoolTypeListAPIManager alloc]init];
    [apiManager loadDataWithParams:nil withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        WMSchoolTypesModel * models = (WMSchoolTypesModel *)responseObject;
        for (WMSchoolTypeModel * model in models.schoolType) {
            [_allArr addObject:model];
        }
        [_tableView reloadData];
    } withFailure:^(ResponseResult *errorResult) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.00000001f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"indexPath.row==%ld",(long)indexPath.row);
    _customModel.schoolGrade = ((WMSchoolTypeModel *)_allArr[indexPath.row]).schoolGrade;
    WMProvinceSelectViewController * goVC = [[WMProvinceSelectViewController alloc]init];
    goVC.customModel = _customModel;
    [self.navigationController pushViewController:goVC animated:YES];
    
    
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _allArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"choiceCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone; 
    cell.textLabel.text = ((WMSchoolTypeModel *)_allArr[indexPath.row]).gradeName;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"333333"];
    cell.separatorInset = UIEdgeInsetsMake(0,0,0,0);
    
    return cell;
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
