//
//  WMTimeSelectViewController.m
//  WMDoctor
//
//  Created by JacksonMichael on 2017/4/12.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMTimeSelectViewController.h"
#import "WMEntranceYearModel.h"
#import "WMEntranceYearListAPIManager.h"
#import "WMEducationSaveAPIManager.h"
#import "WMSchoolListTableViewController.h"

@interface WMTimeSelectViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView * _tableView;
    NSMutableArray * _allArr;
}
@end

@implementation WMTimeSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupData];
    // Do any additional setup after loading the view.
}

- (void)setupUI{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_width, kScreen_height - SafeAreaTopHeight) style:UITableViewStyleGrouped];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.separatorColor = [UIColor colorWithHexString:@"dedede"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    self.title = @"入学时间选择";
}

- (void)setupData{
    
    if (_allArr) {
        [_allArr removeAllObjects];
    }else{
        _allArr = [NSMutableArray array];
    }
    
    WMEntranceYearListAPIManager * apiManager = [[WMEntranceYearListAPIManager alloc]init];
    [apiManager loadDataWithParams:nil withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        WMEntranceYearModel * models = (WMEntranceYearModel *)responseObject;
        _tableView.backgroundView = nil;
        if (models.entranceYears.count <= 0) {
            [self noneBackgroundView];
        }
        for (NSString * model in models.entranceYears) {
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
    
    _customModel.entranceYear = [NSString stringWithFormat:@"%@",_allArr[indexPath.row]];
    WMEducationSaveAPIManager * apiManager = [[WMEducationSaveAPIManager alloc]init];
    [apiManager loadDataWithParams:_customModel.toDictionary withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        [WMHUDUntil showMessageToWindow:@"保存成功"];
        
        //修改学校显示
        NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:self.schoolName,@"schoolName", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SelectSchoolName" object:@"schoolName" userInfo:dic1];
        
        NSArray * arr =  self.navigationController.viewControllers;
        for (int i = 0; i < arr.count;i++) {
            UIViewController * views = (UIViewController *)arr[i];
            if([NSStringFromClass(views.class) isEqualToString:@"WMSchoolListTableViewController"]){
                WMSchoolListTableViewController *VC=(WMSchoolListTableViewController *)views;
                [self.navigationController popToViewController:VC animated:YES];
            }
            
        }
    } withFailure:^(ResponseResult *errorResult) {
        [WMHUDUntil showMessageToWindow:[NSString stringWithFormat:@"%@",errorResult]];
    }];
    
    
    
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _allArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"choiceCell"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [NSString stringWithFormat:@"%@",_allArr[indexPath.row]];
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
    
    
    theImage.image = [UIImage imageNamed:@"pro_default"];
    theLabel.text = @"暂无专业信息";
    
    
    [backView addSubview:theImage];
    [backView addSubview:theLabel];
    
    _tableView.backgroundView = backView;
}

@end
