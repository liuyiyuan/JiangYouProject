//
//  WMCitySelectViewController.m
//  WMDoctor
//
//  Created by JacksonMichael on 2017/4/12.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMCitySelectViewController.h"
#import "WMAreaModel.h"
#import "WMAreaAPIManager.h"
#import "WMSchoolSelectViewController.h"
#import "WMAreaSelectViewController.h"
#import "WMMyInformationTableViewController.h"

@interface WMCitySelectViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView * _tableView;
    NSMutableArray * _allArr;
}
@end

@implementation WMCitySelectViewController

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
    self.title = @"城市选择";
}

- (void)setupData{
    
    if (_allArr) {
        [_allArr removeAllObjects];
    }else{
        _allArr = [NSMutableArray array];
    }
    
    WMAreaAPIManager * apiManager = [[WMAreaAPIManager alloc]init];
    [apiManager loadDataWithParams:@{@"parentId":self.areaStrCode} withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        WMAreasModel * models = (WMAreasModel *)responseObject;
        _tableView.backgroundView = nil;
        if (models.areas.count <= 0) {
            [self noneBackgroundView];

            if (self.isArea) {    //如果是地区选择，跳回个人信息
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.areaStrCode,@"areaCodeStr",@"1",@"areaStyle", nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"SelectAreaCode" object:@"area" userInfo:dic];
                NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:self.areaStr,@"areaStr", nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"SelectArea" object:@"area" userInfo:dic1];
                
                NSArray * arr =  self.navigationController.viewControllers;
                for (int i = 0; i < arr.count;i++) {
                    UIViewController * views = (UIViewController *)arr[i];
                    if([NSStringFromClass(views.class) isEqualToString:@"WMMyInformationTableViewController"]){
                        WMMyInformationTableViewController *VC=(WMMyInformationTableViewController *)views;
                        [self.navigationController popToViewController:VC animated:YES];
                    }
                    
                }
            }
            
        }
        for (WMAreaModel * model in models.areas) {
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
    
    
    if (self.isArea) {
        NSString * areaStrTemp = [NSString stringWithFormat:@"%@%@",self.areaStr,((WMAreaModel *)_allArr[indexPath.row]).areaName];
        self.saveModel.cityId = ((WMAreaModel *)_allArr[indexPath.row]).areaId;
        WMAreaSelectViewController * goVC = [[WMAreaSelectViewController alloc]init];
        goVC.saveModel = self.saveModel;
        goVC.areaStrCode = ((WMAreaModel *)_allArr[indexPath.row]).areaId;
        goVC.areaStr = areaStrTemp;
        [self.navigationController pushViewController:goVC animated:YES];
    }else{
        //跳转学校业务
        WMSchoolSelectViewController * goVC = [[WMSchoolSelectViewController alloc]init];
        goVC.customModel = self.customModel;
        goVC.areaStrCode = ((WMAreaModel *)_allArr[indexPath.row]).areaId;
        [self.navigationController pushViewController:goVC animated:YES];
    }
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _allArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"choiceCell"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone; 
    cell.textLabel.text = ((WMAreaModel *)_allArr[indexPath.row]).areaName;
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
    
    
    theImage.image = [UIImage imageNamed:@"city_default"];
    theLabel.text = @"暂无城市地区信息";
    
    
    [backView addSubview:theImage];
    [backView addSubview:theLabel];
    
    _tableView.backgroundView = backView;
}

@end
