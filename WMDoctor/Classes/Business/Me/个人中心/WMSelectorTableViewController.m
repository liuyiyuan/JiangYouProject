//
//  WMSelectorTableViewController.m
//  WMDoctor
//  微脉选择器（高端酷炫业务逻辑处理，但已废弃）
//  Created by JacksonMichael on 2017/3/21.
//  Copyright © 2017年 Choice. All rights reserved.
//

#import "WMSelectorTableViewController.h"
#import "WMSchoolTypeModel.h"
#import "WMSchoolTypeListAPIManager.h"
#import "WMAreaModel.h"
#import "WMAreaAPIManager.h"
#import "WMSchoolModel.h"
#import "WMSchoolListAPIManager.h"
#import "WMSpecialtieModel.h"
#import "WMSpecialtieListAPIManager.h"
#import "WMEntranceYearModel.h"
#import "WMEntranceYearListAPIManager.h"
#import "WMEducationCustomModel.h"
#import "WMEducationSaveAPIManager.h"
#import "WMStreetsAPIManger.h"
#import "WMVillagesAPIManager.h"

@interface WMSelectorTableViewController ()
{
    NSMutableArray * _allArr;
    NSString * _areaStrCode;
    WMEducationCustomModel * _customModel;
    NSString * _areaStr;
    
}
@end

@implementation WMSelectorTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _areaStrCode = @"0";
    _areaStr = @"";
    _customModel = [[WMEducationCustomModel alloc]init];
    if (!stringIsEmpty(self.educationId)) {
        _customModel.educationId = self.educationId;
    }
    
    [self setupUI];
    [self setupData];
    // Do any additional setup after loading the view.
}


- (void)setupUI{
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = [UIColor colorWithHexString:@"dedede"];
}

- (void)setupData{
    if (_allArr) {
        [_allArr removeAllObjects];
    }else{
        _allArr = [NSMutableArray array];
    }
    
    if (self.selectSytle == WMSelectorStyleEducation) {
        self.title = @"学校添加";
        WMSchoolTypeListAPIManager * apiManager = [[WMSchoolTypeListAPIManager alloc]init];
        [apiManager loadDataWithParams:nil withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
            WMSchoolTypesModel * models = (WMSchoolTypesModel *)responseObject;
            for (WMSchoolTypeModel * model in models.schoolType) {
                [_allArr addObject:model];
            }
            [self.tableView reloadData];
        } withFailure:^(ResponseResult *errorResult) {
            
        }];
    }else if (self.selectSytle == WMSelectorStyleProvince || self.selectSytle == WMSelectorStyleCity || self.selectSytle == WMSelectorStyleArea || self.selectSytle == WMSelectorStyleTown || self.selectSytle == WMSelectorStyleCountry) {
        if (self.selectSytle == WMSelectorStyleProvince) {
            self.title = @"选择省份";
        }else if (self.selectSytle == WMSelectorStyleCity){
            self.title = @"选择城市";
        }else if (self.selectSytle == WMSelectorStyleArea){
            self.title = @"选择地区";
        }else if (self.selectSytle == WMSelectorStyleTown){
            self.title = @"选择街道";
        }else if (self.selectSytle == WMSelectorStyleCountry){
            self.title = @"选择村舍";
        }
        
        if (self.selectSytle == WMSelectorStyleProvince || self.selectSytle == WMSelectorStyleCity || self.selectSytle == WMSelectorStyleArea) {
            WMAreaAPIManager * apiManager = [[WMAreaAPIManager alloc]init];
            [apiManager loadDataWithParams:@{@"parentId":_areaStrCode} withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
                WMAreasModel * models = (WMAreasModel *)responseObject;
                self.tableView.backgroundView = nil;
                if (models.areas.count <= 0) {
                    if (self.isSelectArea) {    //如果是地区选择，不显示缺省页
                        [self.navigationController popViewControllerAnimated:YES];
                    }else{
                        [self noneBackgroundView];
                    }
                    
                }
                for (WMAreaModel * model in models.areas) {
                    [_allArr addObject:model];
                }
                [self.tableView reloadData];
            } withFailure:^(ResponseResult *errorResult) {
                
            }];
        }else if(self.selectSytle == WMSelectorStyleTown){
            WMStreetsAPIManger * apiManager = [[WMStreetsAPIManger alloc]init];
            [apiManager loadDataWithParams:@{@"parentId":_areaStrCode} withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
                WMAreasModel * models = (WMAreasModel *)responseObject;
                self.tableView.backgroundView = nil;
                if (models.areas.count <= 0) {
                    if (self.isSelectArea) {    //如果是地区选择，不显示缺省页
                        [self.navigationController popViewControllerAnimated:YES];
                    }else{
                        [self noneBackgroundView];
                    }
                }
                for (WMAreaModel * model in models.areas) {
                    [_allArr addObject:model];
                }
                [self.tableView reloadData];
            } withFailure:^(ResponseResult *errorResult) {
                
            }];
        }else{
            WMVillagesAPIManager * apiManager = [[WMVillagesAPIManager alloc]init];
            [apiManager loadDataWithParams:@{@"parentId":_areaStrCode} withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
                WMAreasModel * models = (WMAreasModel *)responseObject;
                self.tableView.backgroundView = nil;
                if (models.areas.count <= 0) {
                    if (self.isSelectArea) {    //如果是地区选择，不显示缺省页
                        [self.navigationController popViewControllerAnimated:YES];
                    }else{
                        [self noneBackgroundView];
                    }
                }
                for (WMAreaModel * model in models.areas) {
                    [_allArr addObject:model];
                }
                [self.tableView reloadData];
            } withFailure:^(ResponseResult *errorResult) {
                
            }];
        }
        
        
    }else if (self.selectSytle == WMSelectorStyleSchool){
        self.title = @"选择学校";
        WMSchoolListAPIManager * apiManager = [[WMSchoolListAPIManager alloc]init];
        [apiManager loadDataWithParams:@{@"areaId":_areaStrCode,@"schoolGrade":self.schoolGrade} withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
            WMSchoolsModel * models = (WMSchoolsModel *)responseObject;
            self.tableView.backgroundView = nil;
            if (models.schools.count <= 0) {
                [self noneBackgroundView];
            }
            for (WMSchoolModel * model in models.schools) {
                [_allArr addObject:model];
            }
            [self.tableView reloadData];
        } withFailure:^(ResponseResult *errorResult) {
            
        }];
    }else if(self.selectSytle == WMSelectorStylePro){
        self.title = @"选择专业";
        WMSpecialtieListAPIManager * apiManager = [[WMSpecialtieListAPIManager alloc]init];
        [apiManager loadDataWithParams:@{@"schoolId":_customModel.schoolId} withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
            WMSpecialtiesModel * models = (WMSpecialtiesModel *)responseObject;
            self.tableView.backgroundView = nil;
            if (models.specialties.count <= 0) {
                [self noneBackgroundView];
            }
            for (WMSpecialtieModel * model in models.specialties) {
                [_allArr addObject:model];
            }
            [self.tableView reloadData];
        } withFailure:^(ResponseResult *errorResult) {
            
        }];
    }else if (self.selectSytle == WMSelectorStyleTime){
        self.title = @"选择入学时间";
        WMEntranceYearListAPIManager * apiManager = [[WMEntranceYearListAPIManager alloc]init];
        [apiManager loadDataWithParams:nil withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
            WMEntranceYearModel * models = (WMEntranceYearModel *)responseObject;
            self.tableView.backgroundView = nil;
            if (models.entranceYears.count <= 0) {
                [self noneBackgroundView];
            }
            for (NSString * model in models.entranceYears) {
                [_allArr addObject:model];
            }
            [self.tableView reloadData];
        } withFailure:^(ResponseResult *errorResult) {
            
        }];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0f;
}

#pragma mark - Table view data source

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return _allArr.count;
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"choiceCell"];
    
    if (self.selectSytle == WMSelectorStyleEducation) {
        cell.textLabel.text = ((WMSchoolTypeModel *)_allArr[indexPath.row]).gradeName;
        
    }else if (self.selectSytle == WMSelectorStyleProvince || self.selectSytle == WMSelectorStyleCity || self.selectSytle == WMSelectorStyleArea || self.selectSytle == WMSelectorStyleTown || self.selectSytle == WMSelectorStyleCountry) {
        cell.textLabel.text = ((WMAreaModel *)_allArr[indexPath.row]).areaName;
        
    }else if (self.selectSytle == WMSelectorStyleSchool){
        cell.textLabel.text = ((WMSchoolModel *)_allArr[indexPath.row]).schoolName;
        
    }else if(self.selectSytle == WMSelectorStylePro){
        cell.textLabel.text = ((WMSpecialtieModel *)_allArr[indexPath.row]).specialtyName;
        
    }else if (self.selectSytle == WMSelectorStyleTime){
        cell.textLabel.text = [NSString stringWithFormat:@"%@",_allArr[indexPath.row]];
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"333333"];
    cell.separatorInset = UIEdgeInsetsMake(0,0,0,0);
    
    return cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"indexPath.row==%ld",(long)indexPath.row);
    if (self.selectSytle == WMSelectorStyleEducation) {
        self.schoolGrade = ((WMSchoolTypeModel *)_allArr[indexPath.row]).schoolGrade;
        
    }else if (self.selectSytle == WMSelectorStyleProvince || self.selectSytle == WMSelectorStyleCity || self.selectSytle == WMSelectorStyleArea || self.selectSytle == WMSelectorStyleTown || self.selectSytle == WMSelectorStyleCountry) {
        _areaStrCode = ((WMAreaModel *)_allArr[indexPath.row]).areaId;
//        [_areaStr stringByAppendingString:((WMAreaModel *)_allArr[indexPath.row]).areaName];
        _areaStr = [NSString stringWithFormat:@"%@%@",_areaStr,((WMAreaModel *)_allArr[indexPath.row]).areaName];
        if (!self.isSelectArea && self.selectSytle == WMSelectorStyleArea) {
            self.selectSytle += 2;
        }
        
        if ([self.schoolGrade isEqualToString:@"5"]) {
            self.selectSytle += 4;
        }
        
        
        if (self.isSelectArea) {
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:_areaStrCode,@"areaCodeStr",[NSString stringWithFormat:@"%lu",(unsigned long)self.selectSytle],@"areaStyle", nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SelectAreaCode" object:@"area" userInfo:dic];
            
            NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:_areaStr,@"areaStr", nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SelectArea" object:@"area" userInfo:dic1];
        }
        if (self.selectSytle == WMSelectorStyleCountry && self.isSelectArea) {
            
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        
    }else if (self.selectSytle == WMSelectorStyleSchool){
        _customModel.schoolId = ((WMSchoolModel *)_allArr[indexPath.row]).schoolId;
        if (![self.schoolGrade isEqualToString:@"5"]) {
            _customModel.specialtyId = @"";
            self.selectSytle += 1;
        }
    }else if(self.selectSytle == WMSelectorStylePro){
        _customModel.specialtyId = ((WMSpecialtieModel *)_allArr[indexPath.row]).specialtyId;
        
    }else if (self.selectSytle == WMSelectorStyleTime){
        _customModel.entranceYear = [NSString stringWithFormat:@"%@",_allArr[indexPath.row]];
        WMEducationSaveAPIManager * apiManager = [[WMEducationSaveAPIManager alloc]init];
        [apiManager loadDataWithParams:_customModel.toDictionary withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"%@",responseObject);
            [WMHUDUntil showMessageToWindow:@"保存成功"];
            [self.navigationController popViewControllerAnimated:YES];
        } withFailure:^(ResponseResult *errorResult) {
            
        }];
        
    }
    
    self.selectSytle += 1;
    [self setupData];
    
    
}

#pragma mark - CosomFunction

- (void)noneBackgroundView{
    UIView * backView = [[UIView alloc]initWithFrame:self.tableView.bounds];
    
    UIImageView * theImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 40, 160, 160)];
    theImage.center = CGPointMake(kScreen_width/2, 40+80+64);
    
    UILabel * theLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreen_width, 20)];
    theLabel.center = CGPointMake(kScreen_width/2, 230+64);
    theLabel.textAlignment = NSTextAlignmentCenter;
    
    theLabel.font = [UIFont systemFontOfSize:14];
    theLabel.textColor = [UIColor colorWithHexString:@"999999"];
    
    
    if (self.selectSytle == WMSelectorStyleProvince || self.selectSytle == WMSelectorStyleCity || self.selectSytle == WMSelectorStyleArea || self.selectSytle == WMSelectorStyleTown || self.selectSytle == WMSelectorStyleCountry) {
        theImage.image = [UIImage imageNamed:@"city_default"];
        theLabel.text = @"暂无城市地区信息";
    }else if (self.selectSytle == WMSelectorStyleSchool){
        theImage.image = [UIImage imageNamed:@"me_school_none"];
        theLabel.text = @"暂无学校信息";
    }else if(self.selectSytle == WMSelectorStylePro){
        theImage.image = [UIImage imageNamed:@"pro_default"];
        theLabel.text = @"暂无专业信息";
    }else{
        theImage.image = [UIImage imageNamed:@"city_default"];
        theLabel.text = @"暂无信息";
    }
    
    [backView addSubview:theImage];
    [backView addSubview:theLabel];
    
    self.tableView.backgroundView = backView;
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
