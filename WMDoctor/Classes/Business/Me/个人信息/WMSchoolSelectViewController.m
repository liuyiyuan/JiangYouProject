//
//  WMSchoolSelectViewController.m
//  WMDoctor
//
//  Created by JacksonMichael on 2017/4/12.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMSchoolSelectViewController.h"
#import "WMSchoolModel.h"
#import "WMSchoolListAPIManager.h"
#import "WMProSelectViewController.h"
#import "WMTimeSelectViewController.h"

@interface WMSchoolSelectViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView * _tableView;
    NSMutableArray * _allArr;
}
@end

@implementation WMSchoolSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupData];
    // Do any additional setup after loading the view.
}

- (void)setupUI{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_width, kScreen_height-SafeAreaTopHeight) style:UITableViewStyleGrouped];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.separatorColor = [UIColor colorWithHexString:@"dedede"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    self.title = @"学校选择";
}

- (void)setupData{
    
    if (_allArr) {
        [_allArr removeAllObjects];
    }else{
        _allArr = [NSMutableArray array];
    }
    
    WMSchoolListAPIManager * apiManager = [[WMSchoolListAPIManager alloc]init];
    [apiManager loadDataWithParams:@{@"areaId":self.areaStrCode,@"schoolGrade":self.customModel.schoolGrade} withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        WMSchoolsModel * models = (WMSchoolsModel *)responseObject;
        _tableView.backgroundView = nil;
        if (models.schools.count <= 0) {
            [self noneBackgroundView];
        }
        for (WMSchoolModel * model in models.schools) {
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

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc]init];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"indexPath.row==%ld",(long)indexPath.row);
    
    _customModel.schoolId = ((WMSchoolModel *)_allArr[indexPath.row]).schoolId;
    if (![_customModel.schoolGrade isEqualToString:@"5"]) { //不是大学都不去专业选择页面
        _customModel.specialtyId = @"";
        WMTimeSelectViewController * goVC = [[WMTimeSelectViewController alloc]init];
        goVC.customModel = self.customModel;
        goVC.schoolName = ((WMSchoolModel *)_allArr[indexPath.row]).schoolName;
        [self.navigationController pushViewController:goVC animated:YES];
        return;
    }
    WMProSelectViewController * goVC = [[WMProSelectViewController alloc]init];
    goVC.customModel = self.customModel;
    goVC.schoolName = ((WMSchoolModel *)_allArr[indexPath.row]).schoolName;
    [self.navigationController pushViewController:goVC animated:YES];
    
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _allArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"choiceCell"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone; 
    cell.textLabel.text = ((WMSchoolModel *)_allArr[indexPath.row]).schoolName;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"333333"];
    cell.separatorInset = UIEdgeInsetsMake(0,0,0,0);
    
    return cell;
}

#pragma mark - CosomFunction

- (void)noneBackgroundView{
    UIView * backView = [[UIView alloc]initWithFrame:_tableView.bounds];
    
    UIImageView * theImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 40, 160, 160)];
    theImage.center = CGPointMake(kScreen_width/2, 40+80+64);
    
    UILabel * theLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreen_width, 20)];
    theLabel.center = CGPointMake(kScreen_width/2, 230+64);
    theLabel.textAlignment = NSTextAlignmentCenter;
    
    theLabel.font = [UIFont systemFontOfSize:14];
    theLabel.textColor = [UIColor colorWithHexString:@"999999"];
    
    
    theImage.image = [UIImage imageNamed:@"me_school_none"];
    theLabel.text = @"暂无学校信息";
    
    
    [backView addSubview:theImage];
    [backView addSubview:theLabel];
    
    _tableView.backgroundView = backView;
}

@end
