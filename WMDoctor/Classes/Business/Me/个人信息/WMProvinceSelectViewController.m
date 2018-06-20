//
//  WMProvinceSelectViewController.m
//  WMDoctor
//
//  Created by JacksonMichael on 2017/4/11.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMProvinceSelectViewController.h"
#import "WMAreaModel.h"
#import "WMAreaAPIManager.h"
#import "WMCitySelectViewController.h"
#import "WMSearchSchoolViewController.h"
#import "WMSchoolSelectViewController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

@interface WMProvinceSelectViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView * _tableView;
    NSMutableArray * _allArr;
}
@end

@implementation WMProvinceSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupData];
    // Do any additional setup after loading the view.
}

- (void)setupUI{
    
//    self.fd_prefersNavigationBarHidden = YES;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_width, kScreen_height-SafeAreaTopHeight) style:UITableViewStyleGrouped];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.separatorColor = [UIColor colorWithHexString:@"dedede"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    //navigationItem
    
    
    
    
    //TopView
//    [self.view.layer addSublayer:[CommonUtil backgroundColorInView:self.view andStartColorStr:@"02ccff" andEndColorStr:@"1ba0ff"]];
    
    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_width, 44)];
    topView.backgroundColor = [UIColor colorWithHexString:@"18a2ff"];
    
    UIImageView * topImage = [[UIImageView alloc]initWithFrame:CGRectMake(20, 12, 20, 20)];
    topImage.image = [UIImage imageNamed:@"bt_backarrow"];
    topImage.userInteractionEnabled = YES;
    if (!self.isArea) {
        UIView * topTextfieldView = [[UIView alloc]initWithFrame:CGRectMake(47, 4, kScreen_width-47-28, 32)];
        topTextfieldView.layer.cornerRadius = 16;
        topTextfieldView.clipsToBounds = YES;
        //    topTextfieldView.backgroundColor = [UIColor colorWithHexString:@"f9f9f9"];
        [topTextfieldView.layer addSublayer:[CommonUtil backgroundColorInView:topTextfieldView andStartColorStr:@"22d5fa" andEndColorStr:@"45bcfa"]];
        
        UIImageView * topImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 8, 15, 14)];
        topImageView.image = [UIImage imageNamed:@"ic_sousuo"];
        
        self.title = @"学校选择";
        _tableView.frame = CGRectMake(0, 44, kScreen_width, kScreen_height-SafeAreaTopHeight);
        
        UILabel * topLabel = [[UILabel alloc]initWithFrame:CGRectMake(31, 8, 150, 16)];
        topLabel.text = @"请输入学校名称";
        topLabel.textColor = [UIColor whiteColor];
        topLabel.font = [UIFont systemFontOfSize:11];
        
        [topTextfieldView addSubview:topImageView];
        [topTextfieldView addSubview:topLabel];
        [topView addSubview:topTextfieldView];
        
        UITapGestureRecognizer *reGetTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goSearch)];
        [topTextfieldView addGestureRecognizer:reGetTapGestureRecognizer];
    }else{
//        UILabel * titlelabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 20)];
//        titlelabel.text = @"省级选择";
//        titlelabel.textAlignment = NSTextAlignmentCenter;
//        titlelabel.textColor = [UIColor whiteColor];
//        titlelabel.center = CGPointMake(kScreen_width/2, 22);
//        [topView addSubview:titlelabel];
//
//        UILabel * backLabel = [[UILabel alloc]initWithFrame:CGRectMake(45, 12, 50, 20)];
//        backLabel.text = @"返回";
//        backLabel.textColor = [UIColor whiteColor];
//        [backLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goBackView)]];
//        backLabel.userInteractionEnabled = YES;
//        [topView addSubview:backLabel];
        self.title = @"省级选择";
        topView.hidden = YES;
    }
    [topImage addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goBackView)]];
//    [topView addSubview:topImage];
    [self.view addSubview:topView];
    
    
}

- (void)setupData{
    
    if (_allArr) {
        [_allArr removeAllObjects];
    }else{
        _allArr = [NSMutableArray array];
    }
    
    WMAreaAPIManager * apiManager = [[WMAreaAPIManager alloc]init];
    [apiManager loadDataWithParams:@{@"parentId":@"0"} withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        WMAreasModel * models = (WMAreasModel *)responseObject;
        _tableView.backgroundView = nil;
        if (models.areas.count <= 0) {
                [self noneBackgroundView];
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
        NSString * areaStrTemp = ((WMAreaModel *)_allArr[indexPath.row]).areaName;
        self.saveModel.provinceId = ((WMAreaModel *)_allArr[indexPath.row]).areaId;
        WMCitySelectViewController * goVC = [[WMCitySelectViewController alloc]init];
        goVC.areaStrCode = ((WMAreaModel *)_allArr[indexPath.row]).areaId;
        goVC.areaStr = areaStrTemp;
        goVC.isArea = YES;
        goVC.saveModel = self.saveModel;
        [self.navigationController pushViewController:goVC animated:YES];
    }else{//跳转学校业务
        if ([self.customModel.schoolGrade isEqualToString:@"5"]) {
            //跳转学校业务
            WMSchoolSelectViewController * goVC = [[WMSchoolSelectViewController alloc]init];
            goVC.customModel = self.customModel;
            goVC.areaStrCode = ((WMAreaModel *)_allArr[indexPath.row]).areaId;
            [self.navigationController pushViewController:goVC animated:YES];
            return;
        }
        
        WMCitySelectViewController * goVC = [[WMCitySelectViewController alloc]init];
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

- (void)goSearch{
    WMSearchSchoolViewController * goVC = [[WMSearchSchoolViewController alloc]init];
    goVC.customModel = self.customModel;
    [self.navigationController pushViewController:goVC animated:YES];
}

- (void)goBackView{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
