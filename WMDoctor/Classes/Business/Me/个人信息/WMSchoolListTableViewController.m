//
//  WMSchoolListTableViewController.m
//  WMDoctor
//  学校添加
//  Created by JacksonMichael on 2017/3/21.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMSchoolListTableViewController.h"
#import "WMSelectorTableViewController.h"
#import "WMDoctorEducationsModel.h"
#import "WMDoctorEducationListAPIManager.h"
#import "WMEducationSelectViewController.h"
#import "WMProvinceSelectViewController.h"
#import "WMEducationCustomModel.h"

@interface WMSchoolListTableViewController ()
{
    NSMutableArray * _allSchoolArr;
}
@end

@implementation WMSchoolListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
//    [self setupData];
    
    // Do any additional setup after loading the view.
}

- (void)setupUI{
    UIView * backView = [[UIView alloc]initWithFrame:self.tableView.bounds];
    
    UIImageView * theImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 40, 160, 160)];
    theImage.center = CGPointMake(kScreen_width/2, 40+80);
    theImage.image = [UIImage imageNamed:@"me_school_none"];
    
    UILabel * theLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreen_width, 20)];
    theLabel.center = CGPointMake(kScreen_width/2, 230);
    theLabel.textAlignment = NSTextAlignmentCenter;
    theLabel.text = @"添加学校信息让医生找到你";
    theLabel.font = [UIFont systemFontOfSize:14];
    theLabel.textColor = [UIColor colorWithHexString:@"999999"];
    
    UIButton * theBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 175, 40)];
    [theBtn setTitle:@"添加学校" forState:UIControlStateNormal];
    theBtn.layer.cornerRadius = 4;
    theBtn.clipsToBounds = YES;
    theBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [theBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    theBtn.center = CGPointMake(kScreen_width/2, 294);
    [theBtn addTarget:self action:@selector(goAddSchool) forControlEvents:UIControlEventTouchUpInside];
//    [theBtn.layer addSublayer:[CommonUtil backgroundColorInView:theBtn andStartColorStr:@"02ccff" andEndColorStr:@"1ba0ff"]];
    theBtn.backgroundColor = [UIColor colorWithHexString:@"18a2ff"];
    
    [backView addSubview:theImage];
    [backView addSubview:theLabel];
    [backView addSubview:theBtn];
    
    self.tableView.backgroundView = backView;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupData{
    _allSchoolArr = [NSMutableArray array];
    if (_allSchoolArr) {
        [_allSchoolArr removeAllObjects];
    }
    
    WMDoctorEducationListAPIManager * apiManager = [[WMDoctorEducationListAPIManager alloc]init];
    [apiManager loadDataWithParams:nil withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        WMDoctorEducationsModel * models = (WMDoctorEducationsModel *)responseObject;
        if (models.doctorEducations.count > 0) {
            self.tableView.backgroundView = nil;
        }
        
        _allSchoolArr = [models.doctorEducations mutableCopy];
        [self.tableView reloadData];
    } withFailure:^(ResponseResult *errorResult) {
        
    }];
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (_allSchoolArr.count < 1) {
        return 0.000000001;
    }
    return 100.f;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (_allSchoolArr.count < 1) {
        return nil;
    }
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_width, 100)];
    UIButton * addBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 175, 40)];
    [addBtn setTitle:@"添加学校" forState:UIControlStateNormal];
    addBtn.titleLabel.textColor = [UIColor whiteColor];
    addBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    //    addBtn.titleLabel.text = @"添加学校";
//    [addBtn.layer addSublayer:[CommonUtil backgroundColorInView:addBtn andStartColorStr:@"02ccff" andEndColorStr:@"1ba0ff"]];
    addBtn.backgroundColor = [UIColor colorWithHexString:@"18a2ff"];
    addBtn.layer.cornerRadius = 4;
    addBtn.clipsToBounds = YES;
    [addBtn addTarget:self action:@selector(goAddSchool) forControlEvents:UIControlEventTouchUpInside];
    addBtn.center = CGPointMake(kScreen_width/2, 30+24);
    
    [view addSubview:addBtn];
    return view;
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return _allSchoolArr.count;
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"schoolCell"];
    
    WMDoctorEducationModel * model = _allSchoolArr[indexPath.row];
    cell.textLabel.text = model.gradeName;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"a8a8a8"];
    cell.detailTextLabel.text = model.schoolName;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    cell.detailTextLabel.textColor = [UIColor colorWithHexString:@"333333"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.separatorInset = UIEdgeInsetsMake(0,0,0,0);
    
    return cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"indexPath.row==%ld",(long)indexPath.row);
    WMDoctorEducationModel * model = _allSchoolArr[indexPath.row];
    WMEducationCustomModel * customModel = [[WMEducationCustomModel alloc]init];
    customModel.educationId = model.educationId;
    customModel.schoolGrade = model.schoolGrade;
    WMProvinceSelectViewController * goVC = [[WMProvinceSelectViewController alloc]init];
    goVC.customModel = customModel;
    goVC.backTitle = @"";
    [self.navigationController pushViewController:goVC animated:YES];
    
}

#pragma mark - CosomFunction

/**
 去选择学历
 */
- (void)goAddSchool{
    [self.navigationController pushViewController:[[WMEducationSelectViewController alloc]init] animated:YES];
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
